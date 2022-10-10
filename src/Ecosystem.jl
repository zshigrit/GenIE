# The main model to run coupled plant and soil bgc
module Ecosystem 
#    FT = Float64;
#    const rad2photon = FT(4.6);

    include("plant/Plant.jl")
    include("soil/Soil.jl")


# ============ annual simulation begin =====================
    using UnPack
    using CSV
    using DataFrames
    using Plots
    using .PlantMod
    using .SoilMod

    include("ecosystem/annualsimulation.jl") # directly include a function

# model timespan
    nyear=10;
    ncycle=10;

# environmental inputs
    FT = Float64;
    _weather = DataFrame(CSV.File("./tair_rh_rad_hourly.in"));
    _lai = DataFrame(CSV.File("./df_lai_daily.in"));

# initial parameters/initial conditions 
    soil = 
    plant = 
    weather =
#    par     = SoilPar();
#    par_add = AddPar();


    ## initial condition
    cpools  = InitCPools();
    cfluxes = InitCFluxes();
    npools, mnpools, enzymes_c, enzymes_n = InitNPools(cpools, par_add);
    rCN = InitCN(par_add)


# input (gpp, temperature, water, ph ...) (ARRAYS)
    input_c = InitCInputs(par);
    gpp = inp_gpp() # in InitModel.jl
    swc = inp_swc()/100.0 # daily data
    tmp = inp_stp() # daily data
    ph  = inp_ph() # monthly data

# derived parameters
    vG = vanGenuchtenPar()
    par_der = DerPar() # Initialized with 0s
    @unpack vg_SWCres,vg_SWCsat,vg_alpha,vg_n = vG
    par_der.SWCFC = fSWP2SWC(vg_SWCres,vg_SWCsat,vg_alpha,vg_n)
    # par_der.fNO3_Leaching = fracNO3_Leaching(TMP, SWC,par_add.porosity,par_der.SWCFC,
    #                             par_add.Ksat,par_add.Lambda,par.rNleach,par_add.SoilDepth,1.0) # 
    #  did not update here; updated in N pool
    @unpack f_l_pomo,f_l_pomh,f_l_dom,rCN_LIG2LAB,CN_LITT_avg = par_add
    par_der.CN_LITT_DOM = (f_l_pomo/rCN_LIG2LAB+f_l_dom)/(1.0/CN_LITT_avg-f_l_pomh/par_add.CN_LITT_POMh)
    par_der.CN_LITT_POMo = par_der.CN_LITT_DOM*rCN_LIG2LAB
#

# store output
    output_pools = create_dataframe(AbstractFloat,ncycle,nyear,abs_pools); 
    output_fluxes = create_dataframe(AbstractFloat,ncycle,nyear,abs_fluxes);
    # model run
    ModRunSL!(
    par::SoilPar,par_add::AddPar,par_der::DerPar,vG::vanGenuchtenPar,
    cpools::Pools,npools::Pools,rCN::Pools,mnpools::MNPools,
    cfluxes::Fluxes,enzymes_n::Enzyme_N,enzymes_c::Enzyme_N,
    input_c::DataFrame,output_pools::DataFrame,output_fluxes::DataFrame
    )   

    # model output 

    CSV.write("output_pools.csv", output_pools)
    CSV.write("output_fluxes.csv", output_fluxes)

# plotting
    soc_total = output_pools.cPOMo + output_pools.cPOMh + output_pools.cMOM + output_pools.cDOM 
    x=1:length(soc_total); y = soc_total[1:end] 
    plot(x[1:end], y,label=false)
    savefig("soc_test1212.png")
# ============ annual simulation end  =====================






# ======== debugging begin =========
 println(ModRunSL!)
# ======== debugging end ===========


end #module
