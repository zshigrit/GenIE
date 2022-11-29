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
for iyearr in 1:9*1
    iyearr%9==0 ? iyear=9 : iyear=iyearr%9
    plant.gppsum = 0.0
    soil.Nuptakesum = 0.0 
    for iday in 1:365
        println(iday,": ",plant.gppsum)
        idayy = (iyear-1)*365+iday
	    for ihour in 1:24
               _tairK   = _weather.tair[(idayy-1)*24+ihour] + FT(273.15);
               _rh      = _weather.RH[(idayy-1)*24+ihour] / FT(100);
               _rad     = _weather.rad_h[(idayy-1)*24+ihour];
               _irrad   = _rad / FT(2) * FT(4.6); #convert radiation to irradiance
               _wpd     = exp(FT(21.382) - FT(5347.5) / _tairK) * FT(0.1) * (FT(1) -_rh);
               _swc     = swc[idayy]
               _ts      = ts[idayy] # daily soil temperature data
               _pH      = pH[div(idayy,31)+1]
               _lai     = lai[idayy]
               weather.I = _irrad;
               weather.D = _wpd;
               weather.swc = _swc;
               weather.TaK = _tairK;
               weather.Ts = _ts;
       	       plant.canopy.lai = _lai;
               soil.pH = _pH; 

               plantsoilcn!(par_base,soil,plant,weather)
        
                output_plant[(idayy-1)*24+ihour,"Cs"] = plant.leaf.Cs; # soil.Nuptake; #plant.leaf.Cs;
                output_plant[(idayy-1)*24+ihour,"bm_c"] = plant.leaf.bm_c;
                output_plant[(idayy-1)*24+ihour,"bm_n"] = plant.leaf.bm_n;
                output_plant[(idayy-1)*24+ihour,"rCN"] = plant.leaf.rCN;
                output_plant[(idayy-1)*24+ihour,"Vm25"] = plant.leaf.Vm25; 
                output_plant[(idayy-1)*24+ihour,"apar"] = weather.I;
                output_plant[(idayy-1)*24+ihour,"D_air"] = weather.D; 
                output_plant[(idayy-1)*24+ihour,"LAI"] = plant.canopy.lai;
                output_plant[(idayy-1)*24+ihour,"Ac"] = plant.canopy.Ac; 
                output_plant[(idayy-1)*24+ihour,"An"] = plant.canopy.An;
                output_plant[(idayy-1)*24+ihour,"Reco"] = plant.canopy.Reco; 
                output_plant[(idayy-1)*24+ihour,"NEE"] = plant.canopy.NEE;

                
	    end

        output_pools[idayy,"Time"]  = iday
        output_pools[idayy,"cPOMh"] = soil.OC.POMh
        output_pools[idayy,"cPOMo"] = soil.OC.POMo
        output_pools[idayy,"cMOM"]  = soil.OC.MOM
        output_pools[idayy,"cDOM"]  = soil.OC.DOM
        output_pools[idayy,"cQOM"]  = soil.OC.QOM
        output_pools[iday,"cMBA"]   = soil.OC.MBA
        output_pools[idayy,"cMBD"]  = soil.OC.MBD
        output_pools[idayy,"cEM"]   = soil.OC.EM

    end
end
   
    return nothing 

end 
