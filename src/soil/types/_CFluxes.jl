Base.@kwdef mutable struct Flux_POMo
    pomo_dom::Float64 = 0.0
    pomo_mom::Float64 = 0.0
end

Base.@kwdef mutable struct Flux_POMh
    pomh_dom::Float64 = 0.0
    pomh_mom::Float64 = 0.0
end

Base.@kwdef mutable struct Flux_MOM 
    mom_dom::Float64 = 0.0
end

Base.@kwdef mutable struct Flux_DOM 
    dom_mba::Float64 = 0.0
    dom_qom::Float64 = 0.0
    qom_dom::Float64 = 0.0
end


Base.@kwdef mutable struct Flux_MBA 
    co2_maintn::Float64 = 0.0
    co2_growth::Float64 = 0.0
    mba_pomh::Float64 = 0.0
    mba_pomo::Float64 = 0.0
    mba_dom::Float64 = 0.0
    mba_mbd::Float64 = 0.0
    mba_eph::Float64 = 0.0
    mba_epo::Float64 = 0.0
    mba_em::Float64 = 0.0
end

Base.@kwdef mutable struct Flux_MBD
    mbd_mba::Float64 = 0.0
    co2_maintn::Float64 = 0.0
end
