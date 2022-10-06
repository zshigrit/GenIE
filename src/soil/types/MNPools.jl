mutable struct MNPools{FT<:AbstractFloat}
    Nmine::FT   # [mg N/g soil]
    Nmine_Free::FT  # all mineral N except NH4ads
    Nmine_Solid ::FT
    NH4tot ::FT
    NH4ads ::FT
    NH4 ::FT 
    NOx ::FT
    NO32 ::FT 
    NO3 ::FT 
    NO2  ::FT 
    NO ::FT
    N2O ::FT 
    N2 ::FT 
    NGas ::FT
end

