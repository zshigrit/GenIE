function readin_weather!(
    _weather::DataFrame,
    _swc::Vector,
    _ts::Vector,
    weather::Weather
    # iday::Int,
    # ihour::Int
)

    _tairK   = _weather.tair .+ FT(273.15);
    _rh      = _weather.RH ./ FT(100);
    _rad     = _weather.rad_h;
    _irrad    = _rad ./ FT(2) .* FT(4.6); #convert radiation to irradiance
    _wpd     = exp.(FT(21.382) .- FT(5347.5) ./ _tairK) * FT(0.1) .* (FT(1) .-_rh);

    # _tairK   = _weather.tair[(iday-1)*24+ihour] + FT(273.15);
    # _rh      = _weather.RH[(iday-1)*24+ihour] / FT(100);
    # _rad     = _weather.rad_h[(iday-1)*24+ihour];
    # _irrad    = _rad / FT(2) * FT(4.6); #convert radiation to irradiance
    # _wpd     = exp(FT(21.382) - FT(5347.5) / _tairK) * FT(0.1) * (FT(1) -_rh);
    # _swc     = inp_swc()/100.0 # daily data
    # _ts      = inp_stp() # daily soil temperature data
    
    weather.I = _irrad;
    weather.D = _wpd;
    weather.swc = _swc;
    weather.Tak = _tairK;
    weather.Ts = _ts;
    
    # = Weather(_irrad,_wpd,_swc,_tairK,_ts)


end
