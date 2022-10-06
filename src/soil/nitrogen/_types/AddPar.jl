Base.@kwdef mutable struct AddPar{FT}
    CN_MB_min ::FT = 2.0
    CN_MB_max ::FT = 14.0
    CN_ENZP ::FT = 3.0
    CN_ENZM ::FT = 3.0
    GPPref ::FT = 0.3911 
    CN_LITT_POMh ::FT = 500.0 # const_CN_Cellulose in MEND 
    f_l_pomo ::FT = 0.07
    f_l_pomh ::FT = 0.37
    f_l_dom ::FT  = 0.56
    rCN_LIG2LAB ::FT = 2.0
    CN_LITT_avg ::FT = 30.0
    porosity ::FT = 0.37 # vg_SWCsat in MEND_namelist
    SoilDepth ::FT = 100.0 # cm 
    altitude ::FT = 282.0
    Ksat ::FT      = 15.0
    Lambda ::FT    = 0.298
    CN_SOM ::FT    = 9.0
    CN_POM ::FT	   = 26.0
    CN_MOM ::FT	   = 8.0
    CN_DOM ::FT	   = 8.0
    CN_MB  ::FT    = 6.6
    const_CN_Cellulose ::FT = 500.0
    biome ::String = "MGC" # MESIC GRASSLAND AND CROPLAND
    som ::String = "SOL" # intact soil
end 
