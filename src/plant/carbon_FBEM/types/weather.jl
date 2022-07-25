Base.@kwdef mutable struct Weather{FT<:AbstractFloat}
    "I here as APAR ≈ PAR (simplified)"
    I::FT = 0 # PAR
    D::FT = 0 # water pressure deficit
    swc::FT = 0 #  soil water content 
    TaK::FT = 0 # air temperature in Kelvin
end