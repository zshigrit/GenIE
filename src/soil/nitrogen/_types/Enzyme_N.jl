mutable struct Enzyme_N{FT<:AbstractFloat}
    ENZNmt::FT # ![mg C/g soil],Total ENZymes
    ENZNm::MVector{6,FT}
end
