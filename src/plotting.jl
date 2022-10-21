using CSV
using DataFrames
using Plots

df = CSV.read("output_plant.csv",DataFrame);

h = plot(df.An)

display(h)
