module PlantMod
    using UnPack: @unpack 
    using CSV, DataFrames
    
    export Canopy, Leaf, Weather, Plant
    export canopy_photosynthesis!,leaf_temperature_dependence!,nitrogen_limitation!

    include("types/leaf.jl")
    include("types/canopy.jl")
    include("types/weather.jl")
    include("types/plant.jl"
)

    include("carbon/photosynthesis.jl")
    include("carbon/dependence.jl")
    include("carbon/nitrogenlimitation.jl")
   # include("carbon/annualsimulation.jl")
    include("carbon/createdataframe.jl")



end
