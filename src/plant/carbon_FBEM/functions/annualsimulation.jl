function annual_simulation!(
    leaf::Leaf{FT},
    can::Canopy{FT},
    _lai::DataFrame,
    _weather::DataFrame,
    weather::Weather,
    output::DataFrame
) where {FT<:AbstractFloat}

for i in eachindex(_weather.tair)
    _tairK ::FT = _weather.tair[i] + FT(273.15); 
    _rh   ::FT = _weather.RH[i]/FT(100); 
    _rad  ::FT = _weather.rad_h[i];
    # I, D, swc, Ta = weather; 
    weather.I = _rad/FT(2)*FT(4.6);
    weather.TaK = _tairK;
    """
    es = exp(21.382-5347.5/Tk)
    D = 0.1*es*(1-RH)
    """
    weather.D = exp(FT(21.382)-FT(5347.5)/_tairK) * FT(0.1) * (FT(1)-_rh);
    weather.swc = FT(0.3); 
    _lai.LAI[div((i+24),24)] > FT(0) ? can.lai = _lai.LAI[div((i+24),24)] : can.lai = FT(0)
    
    leaf_temperature_dependence!(leaf, weather.TaK)
    canopy_photosynthesis!(leaf, can, weather)

    output[i,"Ac"] = can.Ac 
    output[i,"Reco"] = can.Reco 
    output[i,"NEE"] = can.NEE
end
return nothing 
end 