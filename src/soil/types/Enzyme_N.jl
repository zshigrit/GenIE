Base.@kwdef mutable struct Enzyme_N{FT<:AbstractFloat}
    ENZNmt::FT = 0.0 # ![mg C/g soil],Total ENZymes
    ENZNm::MVector{6,FT} = [0.0,0.0,0.0,0.0,0.0,0.0]
end
