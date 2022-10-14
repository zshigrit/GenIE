Base.@kwdef mutable struct Canopy{FT<:AbstractFloat} 
    "canopy conductance coefficient"
    g1::FT = 9
    "canopy conductance coefficient related to water vapor deficit "
    D0::FT = 2.74
    "Gs: canopy conductance"
    Gs::FT = 0 
    "nitrogen uptake rate"
    N_uptake::FT = 0
    "light extinction rate for computing lower level GPP"
    kn::FT = 0.8
    "baseline ecosystem respiration @25°"
    Reco0::FT = 2.5
    "temperature sensitivity for Reco"
    Q10::FT = 2.0
    "moisture coefficient at which respiratio is half the maximum "
    a1::FT = 0.1
    "leaf area index m2/m2"
    lai::FT = 0.0
    "canopy photosynthesis (μmol m⁻² s⁻¹)"
    Ac::FT = 0
    "top layer canopy photosynthesis (μmol m⁻² s⁻¹)"
    An::FT = 0
    "ecosystem respiration (μmol m⁻² s⁻¹)"
    Reco::FT = 0
    "net ecosystem carbon exchange (μmol m⁻² s⁻¹)"
    NEE::FT = 0
end