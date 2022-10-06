## adding layers 
Base.@kwdef struct SoilLayersX{FT<:AbstractFloat}
    layer1::Array{FT,1} = [0.0,20.0] # in centimeter
    layer2::Array{FT,1} = [20.0,40.0]
    layer3::Array{FT,1} = [40.0,60.0]
    layer4::Array{FT,1} = [60.0,80.0]
    layer5::Array{FT,1} = [80.0,100.0]
end