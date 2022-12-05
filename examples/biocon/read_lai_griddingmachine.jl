using DataFrames
using GriddingMachine.Requestor

lai_2001_2009 = Float32[]
year_2001_2009 = Float32[]

for year in 2001:2009
	dat,std = request_LUT("LAI_MODIS_2X_8D_"*"$year"*"_V1", 45.4, -93.2);
	lai_2001_2009 = vcat(lai_2001_2009,dat)
	_year = Array{Float32}(undef,size(dat))
	_year .= year
	year_2001_2009 = vcat(year_2001_2009,_year)
end

df_lai = DataFrame(year=year_2001_2009,lai=lai_2001_2009)

