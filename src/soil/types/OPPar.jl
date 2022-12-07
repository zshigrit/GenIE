Base.@kwdef mutable struct OPPar
    # CP_LITT_POMo
    # CP_LITT_POMh
    # CP_LITT_DOM
    rNPmic0 ::Float64 = 7.0 # used for P immobilization based on nitrogen from C:N:P stoichiometry in soil: is there a “Redfield ratio” for the microbial biomass?
    rNPplant0 ::Float64 = 20.0
    kbc::Float64 = 0.0005/(30*24)  # biochemical P mineralization rate 
    CP_ENZM ::Float64 = 3.0 # SAME AS CN_ENZM
    CP_ENZP ::Float64 = 3.0 # SAME AS CN_ENZM
end