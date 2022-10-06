##4 developing functions: nitrogen pools 
"""
note: NH4/NO3 deposition has not been added!
"""
function NPools!(
    par::SoilPar,par_add::AddPar,par_der::DerPar,vG::vanGenuchtenPar,
    cpools::Pools,npools::Pools,rCN::Pools,mnpools::MNPools,
    cfluxes::Fluxes,enzymes_n::Enzyme_N,enzymes_c::Enzyme_N,input_c,
    inp_cpools, inp_npools, inp_rCN, inp_mnpools, inp_enzymes_c, inp_enzymes_n
)

    @unpack POMo,POMh,MOM,DOM,QOM,MBA,MBD,EPO,EPH,EM = cpools
    @unpack CN_MB_min,CN_MB_max,f_l_pomo,f_l_pomh,f_l_dom,rCN_LIG2LAB,CN_LITT_avg,CN_ENZP,CN_ENZM = par_add

    litter_pomo = input_c.litter_pomo_array/par_der.CN_LITT_POMo
    litter_pomh = input_c.litter_pomh_array/par_add.CN_LITT_POMh
    litter_dom = input_c.litter_dom_array/par_der.CN_LITT_DOM

    pomo_dec = MM(par,inp_cpools,Flux_POMo)/inp_rCN.POMo; 
    pomh_dec = MM(par,inp_cpools,Flux_POMh)/inp_rCN.POMh;
    mom_dec = MM(par,inp_cpools,Flux_MOM)/inp_rCN.MOM; 
    dom_dec = MM(par,inp_cpools,Flux_DOM)/inp_rCN.DOM;

    pomo_dom,pomo_mom = Flux!(par,inp_cpools,cfluxes,Flux_POMo) ./inp_rCN.POMo;
    pomh_dom,pomh_mom = Flux!(par,inp_cpools,cfluxes,Flux_POMh) ./inp_rCN.POMh;
    dom_mba, dom_qom, qom_dom = Flux!(par,inp_cpools,cfluxes,Flux_DOM) ./inp_rCN.DOM;
    
    mba_mortality, mba_dom, mba_pomo, mba_pomh,
    mba_mbd, _mba_CO2_growth, _mba_CO2_maintn = 
    Flux!(par,inp_cpools,cfluxes,Flux_MBA) ./inp_rCN.MBA;

    mbd_mba, _mbd_CO2_maintn = Flux!(par,inp_cpools,cfluxes,Flux_MBD) ./inp_rCN.MBD;

    _epo_dom,_eph_dom,_em_dom = EnzymeTurnover(par,inp_cpools);
    epo_dom = _epo_dom/CN_ENZP; # rCN.EPO is constant, does not change with time; same for the other two enzymes 
    eph_dom = _eph_dom/CN_ENZP;
    em_dom = _em_dom/CN_ENZM;

    _mba_eph, _mba_epo, _mba_em = EnzymeProduction(par,inp_cpools);
    mba_eph = _mba_eph/CN_ENZP
    mba_epo = _mba_epo/CN_ENZP
    mba_em  = _mba_em/CN_ENZM

# ============= mineral N fluxes ====================
    # nitrogen mineralization for the first time
    phi = fNLimit_MB(inp_rCN.MBA,CN_MB_min,CN_MB_max,par.wdorm); 
    par_der.YgN = phi;
    Nmn_MBA = (1.0 - par_der.YgN) * dom_mba; # mineral N goes to NH4+

    # immobilization: first time
    Nim_NH4,Nim_NO3,Nim = NImmob(par,inp_mnpools,inp_npools,phi) # microbes
    Nim_NH4_VG,Nim_NO3_VG,Nim_VG = NImmob(par,par_add,inp_mnpools,GPP) # plants 
    
# ============= organic nitrogen balance ====================
    npools.POMo = inp_npools.POMo - pomo_dec + mba_pomo + litter_pomo
    npools.POMh = inp_npools.POMh - pomh_dec + mba_pomh + litter_pomh 
    npools.MOM  = inp_npools.MOM - mom_dec + pomo_mom + pomh_mom  
    npools.QOM  = inp_npools.QOM - qom_dom + dom_qom 
    npools.DOM  = (inp_npools.DOM - dom_dec - dom_qom + qom_dom + litter_dom + pomh_dom 
                + pomo_dom + mba_dom + epo_dom + eph_dom + em_dom)

    npools.MBA = (inp_npools.MBA - mba_mortality - mba_mbd - Nmn_MBA + Nim
                + dom_mba + mbd_mba - mba_eph - mba_epo - mba_em)

    npools.MBD = inp_npools.MBD - mbd_mba + mba_mbd

    npools.EPO = inp_npools.EPO + mba_epo - epo_dom
    npools.EPH = inp_npools.EPH + mba_eph - eph_dom
    npools.EM  = inp_npools.EM  + mba_em  - em_dom
    
# ============= mineral nitrogen balance: first check ====================
    mnpools.NH4 = inp_mnpools.NH4 - Nim_NH4 - Nim_NH4_VG + Nmn_MBA
    mnpools.NO3 = inp_mnpools.NO3 - Nim_NO3 - Nim_NO3_VG
    # mnpools.NO2 = inp_mnpools.NO2  (NO NEED TO UPDATE; SAME FOR NO,N2O,N2)

    Nmn_MBD, Nmn_MBA, Nim_NH4, Nim_NO3 = 
    Overflow!(par,par_add,par_der,
        cpools,npools,rCN,mnpools,
        inp_cpools, inp_npools, inp_rCN, inp_mnpools,
        Nmn_MBA, Nim_NH4, Nim_NH4_VG,Nim_NO3, Nim_NO3_VG
    )

    # Nmn = Nmn_MBD + Nmn_MBA; # note: mineral fluxes have NOT been included!
    mnpools.NH4 = inp_mnpools.NH4 - Nim_NH4 - Nim_NH4_VG + Nmn_MBA + Nmn_MBD
    mnpools.NO3 = inp_mnpools.NO3 - Nim_NO3 - Nim_NO3_VG 

    # N-fixation, nitrification & denitrification
    NFix,Nitrif,Denit = NFixNitDen(par,enzymes_c,mnpools,inp_enzymes_c,inp_mnpools)

    phi = 1.0 - fO2_scalar(SWC,par_add.porosity)

    mnpools.NH4 = mnpools.NH4 + NFix - Nitrif 
    mnpools.NO3 = mnpools.NO3 + Nitrif*(1.0-phi) - Denit[1]
    mnpools.NO2 = inp_mnpools.NO2 + Denit[1] - Denit[2]
    mnpools.NO  = inp_mnpools.NO  + Denit[2] - Denit[3]
    mnpools.N2O = inp_mnpools.N2O + Nitrif*phi + Denit[3] - Denit[4]
    mnpools.N2  = inp_mnpools.N2 + Denit[4] - NFix 

    _SOM = inp_npools.POMh + inp_npools.POMo + inp_npools.MOM + inp_npools.DOM 
    rtp2 = (inp_mnpools.NH4 + inp_mnpools.NO3 + inp_mnpools.NO2)/_SOM 
    rtp1 = par.fpENZN * rtp2 *(_mba_eph+_mba_epo+_mba_em)
    MBA_ENZNm, ENZNm_DOM = ENZNm(par,inp_mnpools,inp_enzymes_c,rtp1)

    enzymes_c.ENZNm = inp_enzymes_c.ENZNm + MBA_ENZNm - ENZNm_DOM
    enzymes_n.ENZNm = enzymes_c.ENZNm/par_add.CN_ENZM

    cpools.MBA = cpools.MBA - sum(MBA_ENZNm) + sum(ENZNm_DOM) # ENZNm_DOM is for microbes for it is intracellular enzyme
    npools.MBA = npools.MBA - sum(MBA_ENZNm)/par_add.CN_ENZM + sum(ENZNm_DOM)/par_add.CN_ENZM

    NO_efflux = fGasEfflux("NO", mnpools.NO, par_add.porosity, 0.5*par_add.SoilDepth, 
                    par_add.altitude, par_der.SWCFC, SWC, TMP)

    N2O_efflux = fGasEfflux("N2O", mnpools.N2O, par_add.porosity, 0.5*par_add.SoilDepth, 
                    par_add.altitude, par_der.SWCFC, SWC, TMP)

    N2_efflux = fGasEfflux("N2", mnpools.N2, par_add.porosity, 0.5*par_add.SoilDepth, 
                    par_add.altitude, par_der.SWCFC, SWC, TMP)

    mnpools.NO  = mnpools.NO - NO_efflux
    mnpools.N2O = mnpools.N2O - N2O_efflux
    mnpools.N2  = mnpools.N2 - N2_efflux

    # NH4 Soprtion-Desorption 
    NH4sorption!(mnpools,par)
    # NO3 and NO2 Leaching
    par_der.fNO3_Leaching = fracNO3_Leaching(TMP,SWC,par_add.porosity,par_der.SWCFC,
                                par_add.Ksat,par_add.Lambda,par.rNleach,par_add.SoilDepth,1.0)
    NO3NO2Leaching!(mnpools,par_der)

    return nothing 
end


# sINI%fNO3_Leaching = fracNO3_Leaching(sINP%tmp,sINP%SWC,sINI%porosity,sINI%SWCFC,sINI%Ksat,sINI%Lambda,&
# sPAR%rNleach, sINI%soilDepth,1.d0)