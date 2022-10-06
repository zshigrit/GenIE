using PyPlot 
using CSV,DataFrames 
df = DataFrame(CSV.File("../output0804.csv"));
figure(1)
x=1:365*24;
y=df.LAI[1:365*24];
h=scatter(
    x,y#[2833:2900],
    #seriestype = :scatter,
    #label="LAI"
    )
PyPlot.title("LAI")
display(h)
ΔNitrogen = [df.bm_n[i+1]-df.bm_n[i] for i in 1:(length(df.bm_n)-1)]

figure(2)
x=1:365*24-1;
y=ΔNitrogen[1:365*24-1]
hh=scatter(
   x,y
    )
display(hh)
