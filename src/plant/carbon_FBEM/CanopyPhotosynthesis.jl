module CanopyPhotosynthesis 
    using UnPack: @unpack 
    using CSV, DataFrames
    #
    include("types/leaf.jl")
    include("types/canopy.jl")
    include("types/weather.jl")
    
    include("functions/photosynthesis.jl")
    include("functions/dependence.jl")
    include("functions/annualsimulation.jl")
    include("functions/create_dataframe.jl")

    begin # model simulation 
    FT = Float64;
    _weather = DataFrame(CSV.File("./tair_rh_rad_hourly.in"));
    _lai = DataFrame(CSV.File("./df_lai_daily.in"));
    output = create_dataframe(FT, _weather::DataFrame);
    #
    leaf = Leaf{FT}(Cs=400);
    canopy = Canopy{FT}();
    weather = Weather{FT}();
    #
    annual_simulation!(leaf, canopy, _lai, _weather, weather, output);
    end # model simulation

    CSV.write("output.csv", output);

end 