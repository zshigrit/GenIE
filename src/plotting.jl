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
