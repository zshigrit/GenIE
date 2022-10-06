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
    # export public functions 
    export InitCPools, InitCFluxes, InitCInputs, inp_gpp, inp_swc, inp_stp, inp_ph 
    export MM, Flux!, CPools!, EnzymeProduction, EnzymeTurnover, create_dataframe
    export fSWP2SWC, fSWC2SWP
    export TMPdep!, SWCdep!, PHdep!
    # export ModRunSL!
    
    export AddPar, DerPar, Enzyme_N, MNPools  
    export ENZNm,fNLimit_MB,NFixNitDen,fGasEfflux,NH4sorption!,NImmob,NO3NO2Leaching!,NPools!,fO2_scalar
    export Overflow!,Rcn

    include("carbon/types/SoilPar.jl")
    include("carbon/types/Fluxes.jl")
    include("carbon/types/Pools.jl")
    include("carbon/types/EmptyStruct.jl")
    include("carbon/types/vanGenuchtenPar.jl")

    include("carbon/functions/WaterDependency.jl")
    include("carbon/functions/MM.jl")
    include("carbon/functions/Enzyme.jl")
    include("carbon/functions/Flux.jl")
    include("carbon/functions/Pool.jl")
    include("carbon/functions/InitModel.jl")
    # include("functions/Model.jl")
    include("carbon/functions/Outputs.jl")
    # include("functions/Plot.jl")
    include("carbon/functions/TemDependency.jl")
    include("carbon/functions/WaterDependency.jl")
    include("carbon/functions/PhDependency.jl")

    include("nitrogen/types/AddPar.jl")
    include("nitrogen/types/DerPar.jl")
    include("nitrogen/types/DiffusivityPar.jl")
    include("nitrogen/types/Enzyme_N.jl")
    include("nitrogen/types/MNPools.jl")

    include("nitrogen/functions/ENZNm.jl")
    include("nitrogen/functions/fNLimit_MB.jl")
    include("nitrogen/functions/InitModel.jl")
    include("nitrogen/functions/NFixNitDen.jl")
    include("nitrogen/functions/NGas.jl")
    include("nitrogen/functions/NH4sorption.jl")
    include("nitrogen/functions/NImmob.jl")
    include("nitrogen/functions/NO3NO2Leaching.jl")
    include("nitrogen/functions/NPool.jl")
    include("nitrogen/functions/O2scalar.jl")
    include("nitrogen/functions/Overflow.jl")
    include("nitrogen/functions/Rcn.jl")

end 
