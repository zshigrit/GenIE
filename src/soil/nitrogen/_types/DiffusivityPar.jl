mutable struct sDIFFUSIVITY_PAR 
    Poro::Float64 
    SWCFC::Float64 
    DCa::Float64  
end

mutable struct sDIFFUSIVITY_OUT
    DCratio::Float64
    DCs::Float64
    AFP::Float64
    PoroIn::Float64
    PoroEx::Float64
    AFPIn::Float64
    AFPEx::Float64
    x::MVector{3, Float64}
    y::MVector{3, Float64}
end

