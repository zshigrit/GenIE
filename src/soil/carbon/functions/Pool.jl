##4 developing functions: carbon pools 
""" carbon only """
function CPools!(par::SoilPar,pools::Pools,inp_pools::Pools,fluxes::Fluxes,input_c)
    @unpack POMo,POMh,MOM,DOM,QOM,MBA,MBD,EPO,EPH,EM = inp_pools
    # @unpack EPO,EPH,EM = pools
    litter_pomo = input_c.litter_pomo_array
    litter_pomh = input_c.litter_pomh_array
    litter_dom = input_c.litter_dom_array

    pomo_dec = MM(par,inp_pools,Flux_POMo); pomh_dec = MM(par,inp_pools,Flux_POMh);
    mom_dec = MM(par,inp_pools,Flux_MOM); dom_dec = MM(par,inp_pools,Flux_DOM);
    # println(mom_dec)

    pomo_dom,pomo_mom = Flux!(par,inp_pools,fluxes,Flux_POMo)
    pomh_dom,pomh_mom = Flux!(par,inp_pools,fluxes,Flux_POMh)
    dom_mba, dom_qom, qom_dom = Flux!(par,inp_pools,fluxes,Flux_DOM)
    Flux!(par,inp_pools,fluxes,Flux_MOM)
    
    mba_mortality, mba_dom, mba_pomo, mba_pomh,
    mba_mbd, mba_CO2_growth, mba_CO2_maintn = 
    Flux!(par,inp_pools,fluxes,Flux_MBA);

    mbd_mba, mbd_CO2_maintn = Flux!(par,inp_pools,fluxes,Flux_MBD)

    epo_dom,eph_dom,em_dom = EnzymeTurnover(par,inp_pools)

    mba_eph, mba_epo, mba_em = EnzymeProduction(par,inp_pools)

    pools.POMo = POMo - pomo_dec + mba_pomo + litter_pomo
    pools.POMh = POMh - pomh_dec + mba_pomh + litter_pomh
    pools.MOM = MOM - mom_dec + pomo_mom + pomh_mom 
    pools.DOM = (DOM - dom_dec - dom_qom + qom_dom + litter_dom + pomh_dom 
                + pomo_dom + mba_dom + epo_dom + eph_dom + em_dom)
    pools.QOM = QOM - qom_dom + dom_qom

    pools.MBA = (MBA - mba_mortality - mba_mbd - mba_CO2_growth 
                - mba_CO2_maintn + dom_mba + mbd_mba
                - mba_eph - mba_epo - mba_em)

    pools.MBD = MBD - mbd_mba - mbd_CO2_maintn + mba_mbd

    pools.EPO = EPO + mba_epo - epo_dom
    pools.EPH = EPH + mba_eph - eph_dom
    pools.EM = EM + mba_em - em_dom
    
    return nothing 
end


# """ carbon and nitrogen: in progress """

# function CPools!(par::SoilPar,pools::Pools,fluxes::Fluxes,input_c)
#     @unpack POMo,POMh,MOM,DOM,QOM,MBA,MBD,EPO,EPH,EM = pools
#     # @unpack EPO,EPH,EM = pools
#     litter_pomo = input_c.litter_pomo_array
#     litter_pomh = input_c.litter_pomh_array
#     litter_dom = input_c.litter_dom_array

#     pomo_dec = MM(par,pools,Flux_POMo); pomh_dec = MM(par,pools,Flux_POMh);
#     mom_dec = MM(par,pools,Flux_MOM); dom_dec = MM(par,pools,Flux_DOM);

#     pomo_dom,pomo_mom = Flux!(par,pools,fluxes,Flux_POMo)
#     pomh_dom,pomh_mom = Flux!(par,pools,fluxes,Flux_POMh)
#     dom_mba, dom_qom, qom_dom = Flux!(par,pools,fluxes,Flux_DOM)
    
#     mba_mortality, mba_dom, mba_pomo, mba_pomh,
#     mba_mbd, mba_CO2_growth, mba_CO2_maintn = 
#     Flux!(par,pools,fluxes,Flux_MBA);

#     mbd_mba, mbd_CO2_maintn = Flux!(par,pools,fluxes,Flux_MBD)

#     epo_dom,eph_dom,em_dom = EnzymeTurnover(par,pools)

#     mba_eph, mba_epo, mba_em = EnzymeProduction(par,pools)

#     pools.POMo = POMo - pomo_dec + mba_pomo + litter_pomo
#     pools.POMh = POMh - pomh_dec + mba_pomh + litter_pomh
#     pools.MOM = MOM - mom_dec + pomo_mom + pomh_mom 
#     pools.DOM = (DOM - dom_dec - dom_qom + qom_dom + litter_dom + pomh_dom 
#                 + pomo_dom + mba_dom + epo_dom + eph_dom + em_dom)
#     pools.QOM = QOM - qom_dom + dom_qom

#     pools.MBA = (MBA - mba_mortality - mba_mbd - mba_CO2_growth 
#                 - mba_CO2_maintn + dom_mba + mbd_mba
#                 - mba_eph - mba_epo - mba_em)

#     pools.MBD = MBD - mbd_mba - mbd_CO2_maintn + mba_mbd

#     pools.EPO = EPO + mba_epo - epo_dom
#     pools.EPH = EPH + mba_eph - eph_dom
#     pools.EM = EM + mba_em - em_dom
    
#     return nothing 
# end