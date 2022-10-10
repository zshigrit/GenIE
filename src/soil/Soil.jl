module SoilMod
    using Plots
    using UnPack
    using DataFrames
    using StatsPlots
    using StaticArrays
    using UnPack
    using CSV 
    using DelimitedFiles

    # export public types 
    export SoilPar, Fluxes, Pools, vanGenuchtenPar
    export Flux_POMo, Flux_POMh, Flux_MOM, Flux_DOM, Flux_MBA, Flux_MBD
    export abs_pools, abs_fluxes    
    export AddPar, DerPar, Enzyme_N, MNPools, Soil  


    # export public functions 
    export InitCPools, InitCFluxes, InitCInputs, inp_gpp, inp_swc, inp_stp, inp_ph 
    export MM, Flux!, CPools!, EnzymeProduction, EnzymeTurnover, create_dataframe
    export fSWP2SWC, fSWC2SWP
    export TMPdep!, SWCdep!, PHdep!
    # export ModRunSL!
    
    export ENZNm,fNLimit_MB,NFixNitDen,fGasEfflux,NH4sorption!,NImmob,NO3NO2Leaching!,NPools!,fO2_scalar
    export Overflow!,Rcn,InitNPools,InitCN

    include("types/SoilPar.jl")
    include("types/Fluxes.jl")
    include("types/Pools.jl")
    include("types/EmptyStruct.jl")
    include("types/vanGenuchtenPar.jl")

    include("types/AddPar.jl")
    include("types/DerPar.jl")
    include("types/DiffusivityPar.jl")
    include("types/Enzyme_N.jl")
    include("types/MNPools.jl")
    include("types/soil.jl")

    include("carbon/WaterDependency.jl")
    include("carbon/MM.jl")
    include("carbon/Enzyme.jl")
    include("carbon/Flux.jl")
    include("carbon/Pool.jl")
    include("carbon/InitModel.jl")
    include("carbon/Outputs.jl")
    include("carbon/TemDependency.jl")
    include("carbon/WaterDependency.jl")
    include("carbon/PhDependency.jl")

    include("nitrogen/ENZNm.jl")
    include("nitrogen/fNLimit_MB.jl")
    include("nitrogen/InitModel.jl")
    include("nitrogen/NFixNitDen.jl")
    include("nitrogen/NGas.jl")
    include("nitrogen/NH4sorption.jl")
    include("nitrogen/NImmob.jl")
    include("nitrogen/NO3NO2Leaching.jl")
    include("nitrogen/NPool.jl")
    include("nitrogen/O2scalar.jl")
    include("nitrogen/Overflow.jl")
    include("nitrogen/Rcn.jl")

end 
