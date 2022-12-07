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
const litterNPratio = 15.0 # flag treat it constant for now
function OPPools!( # flag need to deepcopy all pools to avoid changes in functions
    par::SoilPar,par_add::AddPar,par_der::DerPar,
    cpools::Pools,ppools::Pools,rCP::Pools,ip::MPPools,
    cfluxes::Fluxes,enzymes_c::Enzyme_N,input_c,
    inp_cpools, inp_ppools, inp_rCP, inp_ip, inp_enzymes_c, inp_enzymes_n,
    GPP,leaf::Leaf, #rCN_leaf,rCNmax_leaf,rCNmin_leaf
    Pbiochem,Pmn_MBA,Pim,oppar::OPPar
)

    # @unpack POMo,POMh,MOM,DOM,QOM,MBA,MBD,EPO,EPH,EM = cpools
    @unpack CN_MB_min,CN_MB_max,f_l_pomo,f_l_pomh,f_l_dom,rCN_LIG2LAB,CN_LITT_avg,CN_ENZP,CN_ENZM = par_add

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
    epo_dom = _epo_dom/oppar.CP_ENZM; # rCN.EPO is constant, does not change with time; same for the other two enzymes 
    eph_dom = _eph_dom/oppar.CP_ENZM;
    em_dom = _em_dom/oppar.CP_ENZM;

    _mba_eph, _mba_epo, _mba_em = EnzymeProduction(par,inp_cpools);
    mba_eph = _mba_eph/oppar.CP_ENZM
    mba_epo = _mba_epo/oppar.CP_ENZM
    mba_em  = _mba_em/oppar.CP_ENZM


# ============= organic phosphorus balance ====================
    ppools.POMo = inp_ppools.POMo - pomo_dec + mba_pomo + litter_pomo
    ppools.POMh = inp_ppools.POMh - pomh_dec + mba_pomh + litter_pomh 
    ppools.MOM  = inp_ppools.MOM - mom_dec + pomo_mom + pomh_mom  
    ppools.QOM  = inp_ppools.QOM - qom_dom + dom_qom 
    ppools.DOM  = (inp_ppools.DOM - dom_dec - dom_qom + qom_dom + litter_dom + pomh_dom 
                + pomo_dom + mba_dom + epo_dom + eph_dom + em_dom - Pbiochem)

    ppools.MBA = (inp_ppools.MBA - mba_mortality - mba_mbd - Pmn_MBA + Pim
                + dom_mba + mbd_mba - mba_eph - mba_epo - mba_em)

    ppools.MBD = inp_ppools.MBD - mbd_mba + mba_mbd

    ppools.EPO = inp_ppools.EPO + mba_epo - epo_dom
    ppools.EPH = inp_ppools.EPH + mba_eph - eph_dom
    ppools.EM  = inp_ppools.EM  + mba_em  - em_dom
    return nothing 
end
