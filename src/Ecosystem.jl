# ecosystem model
module Ecosystem 
    # using Plots
    # using UnPack
    using DataFrames
    # using StatsPlots
    # using StaticArrays
    # using UnPack
    # using CSV 
    # using DelimitedFiles

    FT = Float64;
    const rad2photon = FT(4.6);

    include("plant/Plant.jl")
    include("soil/Soil.jl")
    using .Plant 
    using .Soil
    
    include("./annualsimulation.jl")
end #module