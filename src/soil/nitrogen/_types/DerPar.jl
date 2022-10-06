Base.@kwdef mutable struct DerPar{FT<:AbstractFloat}
    YgN ::FT = 0.0 # Initially zero
    CN_LITT_POMo ::FT = 0.0
    CN_LITT_DOM ::FT = 0.0
    SWCFC ::FT = 0.0
    fNO3_Leaching ::FT = 0.0
end