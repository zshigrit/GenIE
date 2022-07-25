Base.@kwdef mutable struct Weather{FT<:AbstractFloat}
    "I here as APAR ≈ PAR (simplified)"
    I::FT = 1200 # PAR
    D::FT = 1.750 # water pressure deficit
    swc::FT = 0.3 #  soil water content 
    TaK::FT = 300 # air temperature in Kelvin
end