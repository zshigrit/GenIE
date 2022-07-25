Base.@kwdef mutable struct Canopy{FT<:AbstractFloat} 
    "canopy conductance coefficient"
    g1::FT = 9
    "canopy conductance coefficient related to water vapor deficit "
    D0::FT = 2.74
    "Gs: canopy conductance"
    Gs::FT = 0 
    "light extinction rate for computing lower level GPP"
    kn::FT = 0.8
    "baseline ecosystem respiration @25°"
    Reco0::FT = 2.5
    "temperature sensitivity for Reco"
    Q10::FT = 2.0
    "moisture coefficient at which respiratio is half the maximum "
    a1::FT = 0.1
    lai::FT = 0 
    Ac::FT = 0
    An::FT = 0
    Reco::FT = 0
    NEE::FT = 0
end