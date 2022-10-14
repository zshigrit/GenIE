module Ecosystem
#    const rad2photon = FT(4.6);

    include("plant/Plant.jl")
    include("soil/Soil.jl")

# ============ annual simulation begin =====================
    using UnPack
    using CSV
    using DataFrames
    using Plots
    using DelimitedFiles
    using .PlantMod
    using .SoilMod

#    include("ecosystem/readinweather.jl")
    include("ecosystem/gpp2soil.jl")
    include("ecosystem/plantsoilcn.jl")
    include("ecosystem/annualsimulation.jl") # directly include a function

# some constants
    const umol2mgC = 1.2*3.6*10^-3; #umolm-2s-1 to mgC/cm2/h
    FT = Float64;

# model timespan
    nyear=10;
    ncycle=1;

# instantialize and intialize parameters/ conditions
    # instantialize
 plant   = Plant(0.0,[0.0,0.0,0.0],Canopy{FT}(),Leaf{FT}());
    soil    = Soil(SoilPar(),AddPar(),DerPar(),0.0,vanGenuchtenPar(),Pools{FT}(), 
            Pools{FT}(), Pools{FT}(),MNPools{FT}(),Enzyme_N{FT}(),Enzyme_N{FT}(),
            Fluxes{FT}(),Fluxes{FT}())
    weather = Weather{FT}();

# initial condition
    plant.leaf.Cs = 400.0;
    soil.OC  = InitCPools();
    soil.CFlux = InitCFluxes();
    soil.ON,soil.MN,soil.enzymes_c, soil.enzymes_n = InitNPools(soil.OC, soil.par_add);
    soil.rCN = InitCN(soil.par_add)
# environmental inputs
    _weather = DataFrame(CSV.File("../test/tair_rh_rad_hourly.in")); # hourly
    swc     = inp_swc()/100.0 # daily data
    ts      = inp_stp() # daily soil temperature data
#    readin_weather!(_weather,_swc,_ts,weather);

# other inputs 
    _lai_df = DataFrame(CSV.File("../test/df_lai_daily.in"));
    _lai_df.LAI[_lai_df.LAI.<0] .= FT(0);
    lai = _lai_df.LAI;
#    plant.canopy.lai = _lai.LAI;
    pH  = inp_ph() # monthly data
    #input_c = InitCInputs(par);
    #gpp = inp_gpp() # in InitModel.jl

# derived parameters
 @unpack vg_SWCres,vg_SWCsat,vg_alpha,vg_n = soil.vG
    par_der = soil.par_der;
    par_der.SWCFC = fSWP2SWC(vg_SWCres,vg_SWCsat,vg_alpha,vg_n)
    # par_der.fNO3_Leaching = fracNO3_Leaching(TMP, SWC,par_add.porosity,par_der.SWCFC,
    #                             par_add.Ksat,par_add.Lambda,par.rNleach,par_add.SoilDepth,1.0) #
    #  did not update here; updated in N pool
    @unpack f_l_pomo,f_l_pomh,f_l_dom,rCN_LIG2LAB,CN_LITT_avg,CN_LITT_POMh = soil.par_add
par_der.CN_LITT_DOM = (f_l_pomo/rCN_LIG2LAB+f_l_dom)/(1.0/CN_LITT_avg-f_l_pomh/CN_LITT_POMh)
    par_der.CN_LITT_POMo = par_der.CN_LITT_DOM*rCN_LIG2LAB
# dataframes for output
    output_pools = create_dataframe(AbstractFloat,ncycle,nyear,abs_pools);
    output_fluxes = create_dataframe(AbstractFloat,ncycle,nyear,abs_fluxes);
    output_plant = create_dataframe(FT, _weather::DataFrame);

end 
