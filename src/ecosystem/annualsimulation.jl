function annual_simulation!(
    soil::Soil,
    plant::Plant,
    weather::Weather,
    _weather::DataFrame,
    swc::Vector,
    ts::Vector,
    lai::Vector,
    pH::Vector,
    output_plant::DataFrame,
    output_pools::DataFrame,
    output_fluxes::DataFrame
)
    par_base = deepcopy(soil.par)
    for iday in 1:365*1
        println(iday,": ",plant.gppsum)
	    for ihour in 1:24
               _tairK   = _weather.tair[(iday-1)*24+ihour] + FT(273.15);
               _rh      = _weather.RH[(iday-1)*24+ihour] / FT(100);
               _rad     = _weather.rad_h[(iday-1)*24+ihour];
               _irrad   = _rad / FT(2) * FT(4.6); #convert radiation to irradiance
               _wpd     = exp(FT(21.382) - FT(5347.5) / _tairK) * FT(0.1) * (FT(1) -_rh);
               _swc     = swc[iday]
               _ts      = ts[iday] # daily soil temperature data
               _pH      = pH[div(iday,30)+1]
               _lai     = lai[iday]
               weather.I = _irrad;
               weather.D = _wpd;
               weather.swc = _swc;
               weather.TaK = _tairK;
               weather.Ts = _ts;
       	       plant.canopy.lai = _lai;
               soil.pH = _pH; 

               plantsoilcn!(par_base,soil,plant,weather,lai,iday)
        
                output_plant[(iday-1)*24+ihour,"Cs"] = plant.leaf.Cs; # soil.Nuptake; #plant.leaf.Cs;
                output_plant[(iday-1)*24+ihour,"bm_c"] = plant.leaf.bm_c;
                output_plant[(iday-1)*24+ihour,"bm_n"] = plant.leaf.bm_n;
                output_plant[(iday-1)*24+ihour,"rCN"] = plant.leaf.rCN;
                output_plant[(iday-1)*24+ihour,"Vm25"] = plant.leaf.Vm25; 
                output_plant[(iday-1)*24+ihour,"apar"] = weather.I;
                output_plant[(iday-1)*24+ihour,"D_air"] = weather.D; 
                output_plant[(iday-1)*24+ihour,"LAI"] = plant.canopy.lai;
                output_plant[(iday-1)*24+ihour,"Ac"] = plant.canopy.Ac; 
                output_plant[(iday-1)*24+ihour,"An"] = plant.canopy.An;
                output_plant[(iday-1)*24+ihour,"Reco"] = plant.canopy.Reco; 
                output_plant[(iday-1)*24+ihour,"NEE"] = plant.canopy.NEE;

                
	    end

        output_pools[iday,"Time"]  = soil.MN.NH4 # iday
        output_pools[iday,"cPOMh"] = soil.MN.NO3 # soil.OC.POMh
        output_pools[iday,"cPOMo"] = soil.OC.POMo
        output_pools[iday,"cMOM"]  = soil.ON.MOM
        output_pools[iday,"cDOM"]  = soil.OC.DOM
        output_pools[iday,"cQOM"]  = soil.OC.QOM
        output_pools[iday,"cMBA"]  = soil.OC.MBA
        output_pools[iday,"cMBD"]  = soil.OC.MBD
        output_pools[iday,"cEM"]   = soil.OC.EM
    end
   
    return nothing 

end 
