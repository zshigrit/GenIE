function gpp2soil!(
    plant::Plant,
    soil::Soil
)

# SIN_day_str = readlines("../../../test/SIN_day.dat") # unit: mgC-cm2-d
    par = soil.par;
    SIN_input = plant.gpp * par.fINP;
    
    # 0.07, 0.37, 0.56 # fraction type I
    f_l_pomo = 0.07 # to be added to parameter list 
    f_l_pomh = 0.37 # to be added to parameter list
    f_l_dom = 0.56 # to be added to parameter list
    depth = 100.0
    litter_pomo = SIN_input * (f_l_pomo/depth);
    litter_pomh = SIN_input * (f_l_pomh/depth);
    litter_dom  = SIN_input * (f_l_dom/depth);

    plant.inputC2Soil = [litter_pomo,litter_pomh,litter_dom]
end
