abstract type abs_pools end
Base.@kwdef mutable struct Pools{FT<:AbstractFloat}
    POMo::FT = 0
    POMh::FT = 0
    MOM ::FT = 0
    DOM ::FT = 0
    QOM ::FT = 0
    MBA ::FT = 0
    MBD ::FT = 0
    EPO ::FT = 0
    EPH ::FT = 0
    EM  ::FT = 0
end
