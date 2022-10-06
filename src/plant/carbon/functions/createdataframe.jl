function create_dataframe(
    FT,
    weather::DataFrame 
)

df = DataFrame();

df[!, "tair"] = weather.tair;
df[!, "rh"]    .= FT(0);
df[!, "D_air"] .= FT(0);
df[!, "irradiance"] .= FT(0);
df[!, "apar"] .= FT(0);
df[!, "Cs"] .= FT(0);

df[!, "bm_c"] .= FT(0);
df[!, "bm_n"] .= FT(0);
df[!, "rCN"]  .= FT(0);

df[!,"Vm25"] .= FT(0);
df[!, "LAI"] .= FT(0);
df[!, "Ac"] .= FT(0);
df[!, "An"] .= FT(0);
df[!, "Reco"] .= FT(0);
df[!, "NEE"] .= FT(0);

return df 

end 