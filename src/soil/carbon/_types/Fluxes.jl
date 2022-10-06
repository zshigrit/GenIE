struct Flux_POMo end 
struct Flux_POMh end 
struct Flux_MOM end
struct Flux_DOM end
struct Flux_MBA end
struct Flux_MBD end

abstract type abs_fluxes end 
    

Base.@kwdef mutable struct Fluxes{FT<:AbstractFloat}
    pomo_dom ::FT = 0.0
    pomo_mom ::FT = 0.0
    pomh_dom ::FT = 0.0
    pomh_mom ::FT = 0.0
    mom_dom ::FT  = 0.0
    dom_mba ::FT  = 0.0
    dom_qom ::FT  = 0.0
    qom_dom ::FT  = 0.0
    co2_maintn_mba ::FT = 0.0
    co2_growth     ::FT = 0.0
    mba_pomh ::FT = 0.0
    mba_pomo ::FT = 0.0
    mba_dom  ::FT = 0.0
    mba_mbd  ::FT = 0.0
    mba_eph  ::FT = 0.0
    mba_epo  ::FT = 0.0
    mba_em   ::FT = 0.0
    mbd_mba  ::FT = 0.0
    co2_maintn_mbd ::FT = 0.0
end