Base.@kwdef mutable struct Weather{FT<:AbstractFloat}
    "I here as APAR ≈ PAR (simplified)"
    # I::Vector{FT}  = [0.0] # PAR
    # D::Vector{FT}  = [0.0] # water pressure deficit
    # swc::Vector{FT}  = [0.0] #  soil water content 
    # TaK::Vector{FT}  = [0.0] # air temperature in Kelvin
    # Ts::Vector{FT}  = [0.0] # soil temperature in ᵒC
    I::FT    = 0.0 # PAR
    D::FT    = 0.0 # water pressure deficit
    swc::FT  = 0.0 #  soil water content 
    TaK::FT  = 0.0 # air temperature in Kelvin
    Ts::FT   = 0.0 # soil temperature in ᵒC
end
