using Plots 
using CSV,DataFrames 
df = DataFrame(CSV.File("../output0804.csv"));
plot(
    df.LAI[1:365*24],#[2833:2900],
    seriestype = :scatter,
    label="LAI"
    )

ΔNitrogen = [df.bm_n[i+1]-df.bm_n[i] for i in 1:(length(df.bm_n)-1)]

plot(
    ΔNitrogen[1:365*24-1],#[2833:2900],
    seriestype = :scatter,
    label="ΔNitrogen"
    )