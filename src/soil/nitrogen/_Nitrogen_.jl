## main program

module Nitrogen

    using Plots
    using UnPack
    using DataFrames
    using StatsPlots
    using StaticArrays
    using UnPack
    using CSV 
    using DelimitedFiles

    # export public types 
    # export public functions
    include("../carbon/CarbonSL.jl")
    using .Carbon 
    # import .Carbon:ModRunSL! # there is another ModRunSL in Nitrogen; this is the way to do multiple dispatch

    include("types/AddPar.jl")
    include("types/DerPar.jl")
    include("types/DiffusivityPar.jl")
    include("types/Enzyme_N.jl")
    include("types/MNPools.jl")

    include("functions/ENZNm.jl")
    include("functions/fNLimit_MB.jl")
    include("functions/InitModel.jl")
    include("functions/Model.jl")
    include("functions/NFixNitDen.jl")
    include("functions/NGas.jl")
    include("functions/NH4sorption.jl")
    include("functions/NImmob.jl")
    include("functions/NO3NO2Leaching.jl")
    include("functions/NPool.jl")
    include("functions/O2scalar.jl")
    include("functions/Overflow.jl")
    # include("functions/SoilWaterScalar.jl")
    include("functions/Rcn.jl")
# ========== test area: start ================
    # par     = SoilPar();
    # println(par.VNup_MB)

# ========== test area: end ================


    # model timespan
    nyear=10;
    ncycle=1;

    ## initial parameters 
    par     = SoilPar();
    par_add = AddPar();

    ## initial condition
    cpools  = InitCPools();
    cfluxes = InitCFluxes();
    npools, mnpools, enzymes_c, enzymes_n = InitNPools(cpools, par_add);
    rCN = InitCN()

    ## input (gpp, temperature, water, ph ...) (ARRAYS)
    input_c = InitCInputs(par);
    gpp = inp_gpp() # in InitModel.jl
    swc = inp_swc()/100.0 # daily data
    tmp = inp_stp() # daily data
    ph  = inp_ph() # monthly data

    ## derived parameters
    vG = vanGenuchtenPar()
    par_der = DerPar() # Initialized with 0s
    @unpack vg_SWCres,vg_SWCsat,vg_alpha,vg_n = vG
    par_der.SWCFC = fSWP2SWC(vg_SWCres,vg_SWCsat,vg_alpha,vg_n)
    # par_der.fNO3_Leaching = fracNO3_Leaching(TMP, SWC,par_add.porosity,par_der.SWCFC,
    #                             par_add.Ksat,par_add.Lambda,par.rNleach,par_add.SoilDepth,1.0)
    @unpack f_l_pomo,f_l_pomh,f_l_dom,rCN_LIG2LAB,CN_LITT_avg = par_add
    par_der.CN_LITT_DOM = (f_l_pomo/rCN_LIG2LAB+f_l_dom)/(1.0/CN_LITT_avg-f_l_pomh/par_add.CN_LITT_POMh)
    par_der.CN_LITT_POMo = par_der.CN_LITT_DOM*rCN_LIG2LAB
 
    ## store output
    output_pools = create_dataframe(AbstractFloat,ncycle,nyear,abs_pools); 
    output_fluxes = create_dataframe(AbstractFloat,ncycle,nyear,abs_fluxes);
    ## model run
    ModRunSL!(
    par::SoilPar,par_add::AddPar,par_der::DerPar,vG::vanGenuchtenPar,
    cpools::Pools,npools::Pools,rCN::Pools,mnpools::MNPools,
    cfluxes::Fluxes,enzymes_n::Enzyme_N,enzymes_c::Enzyme_N,
    input_c::DataFrame,output_pools::DataFrame,output_fluxes::DataFrame
    )   

    ## model output 

    CSV.write("output_pools.csv", output_pools)
    CSV.write("output_fluxes.csv", output_fluxes)

    ## plots
    # output[:,"cSOM"] = output[:,"cPOMh"] + output[:,"cPOMo"] + output[:,"cMOM"];
    soc_total = output_pools.cPOMo + output_pools.cPOMh + output_pools.cMOM + output_pools.cDOM 
    x=1:length(soc_total); y = soc_total[1:end] 
    plot(x[1:end], y,label=false)
    savefig("soc_test1212.png")

    # output[:,"nSOM"] = output[:,"nPOMh"] + output[:,"nPOMo"] + output[:,"nMOM"];
    soc_total = output_pools.nPOMo + output_pools.nPOMh + output_pools.nMOM + output_pools.nDOM 
    x=1:length(soc_total); y = soc_total[1:end] 
    plot(x[1:end], y,label=false)
    savefig("son_test1212.png")
    
    soc_total = output_pools.cPOMo + output_pools.cPOMh + output_pools.cMOM + output_pools.cDOM 
    x=1:length(soc_total); y = soc_total[1:end] 
    plot(x[1:end], y,label=false)
    savefig("soc_test1212.png")

    co2_flux = output_fluxes.co2_maintn_mba + output_fluxes.co2_growth + output_fluxes.co2_maintn_mbd
    x=1:length(co2_flux); y = co2_flux[1:end] 
    plot(x[1:end], y,label=false)
    savefig("flux_test1212.png")

    x=1:length(output_fluxes.pomo_mom); y = output_fluxes.pomo_mom[1:end] 
    plot(x[1:end], y,label=false)
    savefig("flux_pomo_mom1212.png")
end # module