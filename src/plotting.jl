#using CSV
#using DataFrames
#using Plots

#plotly()

df1 = CSV.read("output_plant.csv",DataFrame); 
df2 = CSV.read("output_pools.csv",DataFrame); 

# plot(dailygpp,ylabel="GPP (gC m⁻² d⁻¹)", title="Daily GPP Genie")
# plot(dailygpp,ylabel="GPP (gC/m2/day)", title="Daily GPP Genie")

#h = plot(df.Vm25,title="Vm25");

#display(h)

#h2 = plot(df.Ac,reuse=false)

#display(h2)

#h3 = plot(df.rCN, reuse=false)

#display(h3)
csv.read("file.csv",header=9,DataFrame)
df1 = CSV.read("POWER_Point_Hourly_20210101_20210331_047d0000N_095d0000W_LST.csv",DataFrame;header=11,skipto=18,limit=100,ntasks=1);
