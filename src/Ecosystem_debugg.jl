module Ecosystem 
#    const rad2photon = FT(4.6);
FT = Float64;
    include("plant/Plant.jl")
    using .PlantMod
#plant   = Plant(0.0,[0.0,0.0,0.0],Canopy{FT}(),Leaf{FT}(),0.0);
    include("soil/Soil.jl")
end
