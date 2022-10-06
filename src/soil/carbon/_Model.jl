##7: model run with depth

function ModRunDepth!(par::SoilPar,cpools::Pools,fluxes::Fluxes,ilayer::Integer,
    output_ly::DataFrame,input_c::DataFrame,::Type{depth_output})
# output for layers 

    for icycle = 1:ncycle
        for iday = 1:365*nyear
            for ihour = 1:24
                input_c_time = input_c[iday,:]
                CPools!(par,cpools,fluxes,input_c_time)  
            end
        end 
    end
    output_ly[ilayer,"Layer"] = ilayer
    output_ly[ilayer,"POMh"] = cpools.POMh
    output_ly[ilayer,"POMo"] = cpools.POMo
    output_ly[ilayer,"MOM"] = cpools.MOM
    output_ly[ilayer,"DOM"] = cpools.DOM
    output_ly[ilayer,"QOM"] = cpools.QOM
    output_ly[ilayer,"MBA"] = cpools.MBA
    output_ly[ilayer,"MBD"] = cpools.MBD
end 

function ModRunDepth!(par::SoilPar,cpools::Pools,fluxes::Fluxes,ilayer::Integer,output_ly::DataFrame,
    input_c::DataFrame,::Type{daily_output})
# function ModRunDepth!(par::SoilPar,cpools::CPools,ilayer::Integer)

    for icycle = 1:ncycle
        for iday = 1:365*nyear
            for ihour = 1:24
                # global litter_pomo = litter_pomo_array[iday]
                # global litter_pomh = litter_pomh_array[iday]
                # global litter_dom = litter_dom_array[iday]
                input_c_time = input_c[iday,:]
                CPools!(par,cpools,fluxes,input_c_time)
            end
            output_ly[(icycle-1)*365*nyear+iday,"Time"] = (icycle-1)*365*nyear+iday
            output_ly[(icycle-1)*365*nyear+iday,"POMh"] = cpools.POMh
            output_ly[(icycle-1)*365*nyear+iday,"POMo"] = cpools.POMo
            output_ly[(icycle-1)*365*nyear+iday,"MOM"] = cpools.MOM
            output_ly[(icycle-1)*365*nyear+iday,"DOM"] = cpools.DOM
            output_ly[(icycle-1)*365*nyear+iday,"QOM"] = cpools.QOM
            output_ly[(icycle-1)*365*nyear+iday,"MBA"] = cpools.MBA
            output_ly[(icycle-1)*365*nyear+iday,"MBD"] = cpools.MBD
        end 
    end

end 


"""
model run for single layer 
"""


function ModRunSL!(par::SoilPar,cpools::Pools,cfluxes::Fluxes,input_c::DataFrame,output_ly::DataFrame)
    # function ModRunDepth!(par::SoilPar,cpools::CPools,ilayer::Integer)
    
        for icycle = 1:ncycle
            for iday = 1:365*nyear
                for ihour = 1:24
                    # global litter_pomo = litter_pomo_array[iday]
                    # global litter_pomh = litter_pomh_array[iday]
                    # global litter_dom = litter_dom_array[iday]
                    input_c_time = input_c[iday,:]
                    CPools!(par,cpools,cfluxes,input_c_time)
                end
                # output_ly[(icycle-1)*365*nyear+iday,"Time"] = (icycle-1)*365*nyear+iday
                # output_ly[(icycle-1)*365*nyear+iday,"POMh"] = cpools.POMh
                # output_ly[(icycle-1)*365*nyear+iday,"POMo"] = cpools.POMo
                # output_ly[(icycle-1)*365*nyear+iday,"MOM"] = cpools.MOM
                # output_ly[(icycle-1)*365*nyear+iday,"DOM"] = cpools.DOM
                # output_ly[(icycle-1)*365*nyear+iday,"QOM"] = cpools.QOM
                # output_ly[(icycle-1)*365*nyear+iday,"MBA"] = cpools.MBA
                # output_ly[(icycle-1)*365*nyear+iday,"MBD"] = cpools.MBD
            end 
        end
    
end 
    
    
    

