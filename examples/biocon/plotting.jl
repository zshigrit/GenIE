using CSV
using DataFrames
using Plots

#plotlyjs()
#CSV.read("rad_hourly.csv",DataFrame;header=11,ntasks=1);
#df1 = CSV.read("output_plant.csv",DataFrame); 
#df2 = CSV.read("output_pools.csv",DataFrame); 
plotlyjs() # Set the backend to Plotly
# This plots into the web browser via Plotly
Plots.plot(x, y, title = "Hourly radiation (2001-2009)",
       xlabel="Year",xlims = (2001,2010.3),xticks = 2001:2:2010,
       ylabel="Hourly radiation(W/m²)",legend=false)

plot(x, y, title = "Hourly radiation",xlabel="Year")

# plot(dailygpp,ylabel="GPP (gC m⁻² d⁻¹)", title="Daily GPP Genie")
# plot(dailygpp,ylabel="GPP (gC/m2/day)", title="Daily GPP Genie")

#h = plot(df.Vm25,title="Vm25");

#display(h)

#h2 = plot(df.Ac,reuse=false)

#display(h2)

#h3 = plot(df.rCN, reuse=false)

#display(h3)
#csv.read("file.csv",header=9,DataFrame)
#df1 = CSV.read("POWER_Point_Hourly_20210101_20210331_047d0000N_095d0000W_LST.csv",DataFrame;header=11,skipto=18,limit=100,ntasks=1);

#plotlyjs()
#savefig("test.png")

begin
       layout = Layout(;title="Radiation", 
       xaxis_range=[2001,2002],xaxis=attr(title="Year"),
       yaxis_range=[0, 1000],yaxis=attr(title="Radiation (W/m2)"))
       plot(df1.TIME[1:1*365*24],df1.ALLSKY_SFC_SW_DWN[1:1*365*24],layout)
end

## plotting weather data
#using CSV,DataFrames
#using PlotlyJS

df1 = CSV.read("rad_hourly.csv",DataFrame;header=10,skipto=17,ntasks=1);
df1.TIME = collect(range(2001,2010,size(df1)[1]));
layout = Layout(;title="Radiation", 
xaxis_range=[2001,2002],xaxis=attr(title="Year"),
yaxis_range=[0, 1000],yaxis=attr(title="Radiation (W/m2)"))
plot(df1.TIME,df1.ALLSKY_SFC_SW_DWN,layout)

