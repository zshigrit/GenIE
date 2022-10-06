abstract type abs_pools end
mutable struct Pools{FT<:AbstractFloat}
    POMo::FT
    POMh::FT
    MOM ::FT
    DOM ::FT
    QOM ::FT
    MBA ::FT 
    MBD ::FT
    EPO ::FT 
    EPH ::FT 
    EM  ::FT 
    # PTT ::FT # protist 
    # VIR ::FT # virus
end