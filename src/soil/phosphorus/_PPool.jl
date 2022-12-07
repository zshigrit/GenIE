"""
    PPools!( # flag need to deepcopy all pools to avoid changes in functions
    soil::Soil,
    par::SoilPar,par_add::AddPar,par_der::DerPar,vG::vanGenuchtenPar,
    cpools::Pools,ppools::Pools,rCP::Pools,ip::MPPools,
    cfluxes::Fluxes,enzymes_c::Enzyme_N,input_c,
    inp_cpools, inp_ppools, inp_rCP, inp_ip, inp_enzymes_c, inp_enzymes_n,
    GPP,SWC,TMP,leaf::Leaf #rCN_leaf,rCNmax_leaf,rCNmin_leaf
)

TBW
"""
function PPools!( # flag need to deepcopy all pools to avoid changes in functions
    par::SoilPar,par_add::AddPar,par_der::DerPar,
    cpools::Pools,ppools::Pools,rCP::Pools,ip::MPPools,
    cfluxes::Fluxes,enzymes_c::Enzyme_N,input_c,
    inp_cpools, inp_ppools, inp_rCP, inp_ip, inp_enzymes_c, inp_enzymes_n,
    GPP,leaf::Leaf #rCN_leaf,rCNmax_leaf,rCNmin_leaf
)

    # @unpack POMo,POMh,MOM,DOM,QOM,MBA,MBD,EPO,EPH,EM = cpools
    @unpack CN_MB_min,CN_MB_max,f_l_pomo,f_l_pomh,f_l_dom,rCN_LIG2LAB,CN_LITT_avg,CN_ENZP,CN_ENZM = par_add

    const litterNPratio = 15.0 # flag treat it constant for now
    ip.POx = ip.POx * (1000.0/1e6) # convert from g/m2 to mg/cm3
    inp_ip.POx = inp_ip.POx * (1000.0/1e6) # convert from g/m2 to mg/cm3

    litter_pomo = input_c[1]/par_der.CN_LITT_POMo/litterNPratio;
    litter_pomh = input_c[2]/par_add.CN_LITT_POMh/litterNPratio;
    litter_dom  = input_c[3]/par_der.CN_LITT_DOM/litterNPratio;

    pomo_dec = MM(par,inp_cpools,Flux_POMo)/inp_rCP.POMo; 
    pomh_dec = MM(par,inp_cpools,Flux_POMh)/inp_rCP.POMh;
    mom_dec = MM(par,inp_cpools,Flux_MOM)/inp_rCP.MOM; 
    dom_dec = MM(par,inp_cpools,Flux_DOM)/inp_rCP.DOM;

    pomo_dom,pomo_mom = Flux!(par,inp_cpools,cfluxes,Flux_POMo) ./inp_rCP.POMo;
    pomh_dom,pomh_mom = Flux!(par,inp_cpools,cfluxes,Flux_POMh) ./inp_rCP.POMh;
    dom_mba, dom_qom, qom_dom = Flux!(par,inp_cpools,cfluxes,Flux_DOM) ./inp_rCP.DOM;
    
    mba_mortality, mba_dom, mba_pomo, mba_pomh,
    mba_mbd, _mba_CO2_growth, _mba_CO2_maintn = 
    Flux!(par,inp_cpools,cfluxes,Flux_MBA) ./inp_rCP.MBA;

    mbd_mba, _mbd_CO2_maintn = Flux!(par,inp_cpools,cfluxes,Flux_MBD) ./inp_rCP.MBD;

    _epo_dom,_eph_dom,_em_dom = EnzymeTurnover(par,inp_cpools);
    epo_dom = _epo_dom/CP_ENZP; # rCN.EPO is constant, does not change with time; same for the other two enzymes 
    eph_dom = _eph_dom/CP_ENZP;
    em_dom = _em_dom/CP_ENZM;

    _mba_eph, _mba_epo, _mba_em = EnzymeProduction(par,inp_cpools);
    mba_eph = _mba_eph/CP_ENZP
    mba_epo = _mba_epo/CP_ENZP
    mba_em  = _mba_em/CP_ENZM

# ============= mineral P fluxes ====================
    # phosphorus mineralization for the first time
    phi = fNLimit_MB(inp_rCN.MBA,CN_MB_min,CN_MB_max,par.wdorm); 
    par_der.YgN = phi;
    Nmn_MBA = (1.0 - par_der.YgN) * dom_mba; # mineral N goes to NH4+
    Pmn_MBA = Nmn_MBA / inp_rNP.MBA;     

    # immobilization: first time
    Nim_NH4,Nim_NO3,Nim = NImmob(par,inp_mnpools,inp_npools,phi) # microbes
    Pim = Nim/oppar.rNPmic0
    if Pim>ip.POx
        Pim = ip.POx
    end
    # Nim_NH4_VG,Nim_NO3_VG,Nim_VG = NImmob(par,par_add,inp_mnpools,GPP) # plants 

    # ============= an alternate P uptake by vegetation replacing the above one ================
    mnpools.NH4 = inp_mnpools.NH4 - Nim_NH4 + Nmn_MBA
    mnpools.NO3 = inp_mnpools.NO3 - Nim_NO3 
    # Nim_NH4_VG,Nim_NO3_VG,Nim_VG,Nuptake = NImmobAlt(par,par_add,mnpools,GPP,rCN_leaf,rCNmax_leaf,rCNmin_leaf) # plants
    Nim_NH4_VG,Nim_NO3_VG,Nim_VG,Nuptake = NImmobAlt(par,par_add,mnpools,GPP,leaf)
 
    ip.POx = inp_ip.POx - Pim + Pmn_MBA
    Pim_VG = Nim_VG/oppar.rNPplant0 
    if Pim_VG>ip.POx;Pim_VG = ip.POx;end
    # ============= an alternate N uptake by vegetation replacing the above one ================

    # biochemical P mineralization from DOM
    Pbiochem = oppar.kbc * inp_ppools.DOM
    
# ============= organic phosphorus balance ====================
    ppools.POMo = inp_ppools.POMo - pomo_dec + mba_pomo + litter_pomo
    ppools.POMh = inp_ppools.POMh - pomh_dec + mba_pomh + litter_pomh 
    ppools.MOM  = inp_ppools.MOM - mom_dec + pomo_mom + pomh_mom  
    ppools.QOM  = inp_ppools.QOM - qom_dom + dom_qom 
    ppools.DOM  = (inp_ppools.DOM - dom_dec - dom_qom + qom_dom + litter_dom + pomh_dom 
                + pomo_dom + mba_dom + epo_dom + eph_dom + em_dom - Pbiochem)

    ppools.MBA = (inp_ppools.MBA - mba_mortality - mba_mbd - Nmn_MBA + Nim
                + dom_mba + mbd_mba - mba_eph - mba_epo - mba_em)

    ppools.MBD = inp_ppools.MBD - mbd_mba + mba_mbd

    ppools.EPO = inp_ppools.EPO + mba_epo - epo_dom
    ppools.EPH = inp_ppools.EPH + mba_eph - eph_dom
    ppools.EM  = inp_ppools.EM  + mba_em  - em_dom
    
# ============= mineral phosphorus balance: first check ====================
    ip.POx = inp_ip.POx - Pim - Pim_VG + Pmn_MBA

    Nmn_MBD, Nmn_MBA, Nim_NH4, Nim_NO3 = 
    Overflow!(par,par_add,par_der,
        cpools,npools,rCN,mnpools,
        inp_cpools, inp_npools, inp_rCN, inp_mnpools,
        Nmn_MBA, Nim_NH4, Nim_NH4_VG,Nim_NO3, Nim_NO3_VG
    )
    
    Pmn_MBD, Pmn_MBA, Pim = Nmn_MBD/inp_rNP.MBD, Nmn_MBA/inp_rNP.MBA, (Nim_NH4+Nim_NO3)/OPPar.rNPmic0

    ip.POx = inp_ip.POx - Pim - Pim_VG + Pmn_MBA + Pmn_MBD + Pbiochem

    # inorganic phosphorus processes: sorption,desorption,precipitation,desolution,occlusion
    ip.POx = ip.POx / (1000.0/1e6) # convert to gP/m2 for IP pool dynamic (in unit g/m2)
    IPpoolUpdate!(ip,ppar)

    _SOM = inp_npools.POMh + inp_npools.POMo + inp_npools.MOM + inp_npools.DOM 
    rtp2 = (inp_mnpools.NH4 + inp_mnpools.NO3 + inp_mnpools.NO2)/_SOM 
    rtp1 = par.fpENZN * rtp2 *(_mba_eph+_mba_epo+_mba_em)
    MBA_ENZNm, ENZNm_DOM = ENZNm(par,inp_mnpools,inp_enzymes_c,rtp1)

    enzymes_c.ENZNm = inp_enzymes_c.ENZNm + MBA_ENZNm - ENZNm_DOM
    enzymes_p.ENZNm = enzymes_c.ENZNm/oppar.CP_ENZM

    ppools.MBA = ppools.MBA - sum(MBA_ENZNm)/oppar.CP_ENZM + sum(ENZNm_DOM)/oppar.CP_ENZM

    return nothing 
end
