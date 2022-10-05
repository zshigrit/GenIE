# Spin-off ModRunSL! below
# tidy ModRunSL up 
function soil_bgc!(
        soil::Soil{FT}

) where {FT<:AbstractFloat}
    par_base = deepcopy(soil.SoilPar);

end



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
function ModRunSL!(
    par::SoilPar,par_add::AddPar,par_der::DerPar,vG::vanGenuchtenPar,
    cpools::Pools,npools::Pools,rCN::Pools,mnpools::MNPools,
    cfluxes::Fluxes,enzymes_n::Enzyme_N,enzymes_c::Enzyme_N,
    input_c::DataFrame,output_pools::DataFrame,output_fluxes::DataFrame
)  
    par_base = deepcopy(par)
    for icycle = 1:ncycle
        for iday = 1:365*nyear 
            # println(iday)
            for ihour = 1:24
                input_c_time = input_c[iday,:]
                global GPP = gpp[iday] # neede for plant uptaking mineral N
                global SWC = swc[iday]
                global TMP = tmp[iday]
                global PH  = ph[Integer(trunc(iday/30))+1]
    
                biome, som = "MGC", "SOL"
                par = deepcopy(par_base)
                TMPdep!(par,TMP)
                SWCdep!(par_base,par,SWC,vG,biome,som)
                PHdep!(par,PH)

                inp_cpools, inp_npools = deepcopy(cpools), deepcopy(npools)
                inp_rCN, inp_mnpools   = deepcopy(rCN), deepcopy(mnpools) 
                inp_enzymes_c, inp_enzymes_n = deepcopy(enzymes_c), deepcopy(enzymes_n) # these are only enzyme for N processes
            
                CPools!(par, cpools, inp_cpools, cfluxes, input_c_time)
                NPools!(par, par_add, par_der, vG, cpools, npools, rCN, mnpools,
                    cfluxes, enzymes_n, enzymes_c, input_c_time,
                    inp_cpools, inp_npools, inp_rCN, inp_mnpools, inp_enzymes_c, inp_enzymes_n)
                rCN = Rcn(cpools, npools)
# # ========== testing ==================
#                 if iday<=3
#                     idd = (iday-1)*24+ihour 
#                     output_ly[(icycle-1)*365*nyear+idd,"Time"] = (icycle-1)*365*nyear+idd
#                     output_ly[(icycle-1)*365*nyear+idd,"POMh"] = npools.POMh
#                     output_ly[(icycle-1)*365*nyear+idd,"POMo"] = npools.POMo
#                     output_ly[(icycle-1)*365*nyear+idd,"MOM"]  = npools.MOM
#                     output_ly[(icycle-1)*365*nyear+idd,"DOM"]  = npools.DOM
#                     output_ly[(icycle-1)*365*nyear+idd,"QOM"]  = npools.QOM
#                     output_ly[(icycle-1)*365*nyear+idd,"MBA"]  = npools.MBA
#                     output_ly[(icycle-1)*365*nyear+idd,"MBD"]  = npools.MBD
#                     # output_ly[(icycle-1)*365*nyear+iday,"Time"] = (icycle-1)*365*nyear+iday
#                     # output_ly[(icycle-1)*365*nyear+iday,"POMh"] = cpools.POMh
#                     # output_ly[(icycle-1)*365*nyear+iday,"POMo"] = cpools.POMo
#                     # output_ly[(icycle-1)*365*nyear+iday,"MOM"]  = cpools.MOM
#                     # output_ly[(icycle-1)*365*nyear+iday,"DOM"]  = cpools.DOM
#                     # output_ly[(icycle-1)*365*nyear+iday,"QOM"]  = cpools.QOM
#                     # output_ly[(icycle-1)*365*nyear+iday,"MBA"]  = cpools.MBA
#                     # output_ly[(icycle-1)*365*nyear+iday,"MBD"]  = cpools.MBD

#                     # output_ly[(icycle-1)*365*nyear+iday,"Time"] = (icycle-1)*365*nyear+iday
#                     # output_ly[(icycle-1)*365*nyear+iday,"POMh"] = npools.POMh
#                     # output_ly[(icycle-1)*365*nyear+iday,"POMo"] = npools.POMo
#                     # output_ly[(icycle-1)*365*nyear+iday,"MOM"]  = npools.MOM
#                     # output_ly[(icycle-1)*365*nyear+iday,"DOM"]  = npools.DOM
#                     # output_ly[(icycle-1)*365*nyear+iday,"QOM"]  = npools.QOM
#                     # output_ly[(icycle-1)*365*nyear+iday,"MBA"]  = npools.MBA
#                     # output_ly[(icycle-1)*365*nyear+iday,"MBD"]  = npools.MBD
#                 end
# # ========== testing: end ===========

            end
            output_pools[(icycle-1)*365*nyear+iday,"Time"] = (icycle-1)*365*nyear+iday
            output_pools[(icycle-1)*365*nyear+iday,"cPOMh"] = cpools.POMh
            output_pools[(icycle-1)*365*nyear+iday,"cPOMo"] = cpools.POMo
            output_pools[(icycle-1)*365*nyear+iday,"cMOM"]  = cpools.MOM
            output_pools[(icycle-1)*365*nyear+iday,"cDOM"]  = cpools.DOM
            output_pools[(icycle-1)*365*nyear+iday,"cQOM"]  = cpools.QOM
            output_pools[(icycle-1)*365*nyear+iday,"cMBA"]  = cpools.MBA
            output_pools[(icycle-1)*365*nyear+iday,"cMBD"]  = cpools.MBD
            output_pools[(icycle-1)*365*nyear+iday,"cEM"]  = cpools.EM

            output_pools[(icycle-1)*365*nyear+iday,"nPOMh"] = npools.POMh
            output_pools[(icycle-1)*365*nyear+iday,"nPOMo"] = npools.POMo
            output_pools[(icycle-1)*365*nyear+iday,"nMOM"]  = npools.MOM
            output_pools[(icycle-1)*365*nyear+iday,"nDOM"]  = npools.DOM
            output_pools[(icycle-1)*365*nyear+iday,"nQOM"]  = npools.QOM
            output_pools[(icycle-1)*365*nyear+iday,"nMBA"]  = npools.MBA
            output_pools[(icycle-1)*365*nyear+iday,"nMBD"]  = npools.MBD
            output_pools[(icycle-1)*365*nyear+iday,"nEM"]  = npools.EM

            output_fluxes[(icycle-1)*365*nyear+iday,"Time"] = (icycle-1)*365*nyear+iday
            output_fluxes[(icycle-1)*365*nyear+iday,"co2_maintn_mba"] = cfluxes.co2_maintn_mba
            output_fluxes[(icycle-1)*365*nyear+iday,"co2_growth"] = cfluxes.co2_growth
            output_fluxes[(icycle-1)*365*nyear+iday,"co2_maintn_mbd"]  = cfluxes.co2_maintn_mbd
            output_fluxes[(icycle-1)*365*nyear+iday,"mom_dom"]  = cfluxes.mom_dom
            output_fluxes[(icycle-1)*365*nyear+iday,"pomo_mom"]  = cfluxes.pomo_mom
        end 
    end
    
end 

