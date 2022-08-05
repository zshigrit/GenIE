## create dataframe to store output 

function create_dataframe(FT,ncycle,nyear,::Type{abs_pools})#(FT,weather::DataFrame)
    
    df    = DataFrame();
   
    df[!, "Time"  ] = zeros(ncycle*nyear*365);
    df[!, "cPOMh" ] .= FT(0);
    df[!, "cPOMo" ] .= FT(0);
    df[!, "cMOM"  ] .= FT(0);
    df[!, "cDOM"  ] .= FT(0);
    df[!, "cQOM"    ] .= FT(0);
    df[!, "cMBA"   ] .= FT(0);
    df[!, "cMBD"] .= FT(0);
    df[!, "cEM"] .= FT(0);

    df[!, "nPOMh" ] .= FT(0);
    df[!, "nPOMo" ] .= FT(0);
    df[!, "nMOM"  ] .= FT(0);
    df[!, "nDOM"  ] .= FT(0);
    df[!, "nQOM"    ] .= FT(0);
    df[!, "nMBA"   ] .= FT(0);
    df[!, "nMBD"] .= FT(0);
    df[!, "nEM"] .= FT(0);

    return df
end

function create_dataframe(FT,ncycle,nyear,::Type{abs_fluxes})#(FT,weather::DataFrame)
    
    df    = DataFrame();
   
    df[!, "Time"  ] = zeros(ncycle*nyear*365);
    df[!, "co2_maintn_mba" ] .= FT(0);
    df[!, "co2_growth" ] .= FT(0);
    df[!, "co2_maintn_mbd"  ] .= FT(0);
    df[!, "mom_dom"  ] .= FT(0);
    df[!, "pomo_mom"  ] .= FT(0);

    return df
end




# function create_dataframe(FT,nlayer)#(FT,weather::DataFrame)
    
#     df    = DataFrame();
   
#     df[!, "Layer"  ] = zeros(nlayer+1);
#     df[!, "POMh" ] .= FT(0);
#     df[!, "POMo" ] .= FT(0);
#     df[!, "MOM"  ] .= FT(0);
#     df[!, "DOM"  ] .= FT(0);
#     df[!, "QOM"  ] .= FT(0);
#     df[!, "MBA"] .= FT(0);
#     df[!, "MBD"] .= FT(0);

#     return df
# end