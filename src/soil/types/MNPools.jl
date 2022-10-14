Base.@kwdef mutable struct MNPools{FT<:AbstractFloat}
    Nmine::FT = 0.0   # [mg N/g soil]
    Nmine_Free::FT = 0.0  # all mineral N except NH4ads
    Nmine_Solid ::FT = 0.0
    NH4tot ::FT = 0.0
    NH4ads ::FT = 0.0
    NH4 ::FT = 0.0
    NOx ::FT = 0.0
    NO32 ::FT = 0.0
    NO3 ::FT = 0.0
    NO2  ::FT = 0.0
    NO ::FT = 0.0
    N2O ::FT = 0.0
    N2 ::FT = 0.0
    NGas ::FT = 0.0
end

