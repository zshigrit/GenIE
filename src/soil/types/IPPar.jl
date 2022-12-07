Base.@kwdef mutable struct IPPar
    Smax:: Float64 = 100.0 # 10,100.0 and 112.0 g P m−2 for three sites (Wang 2006)
    Ks  :: Float64 = 0.45 # 1.35 and 0.45 g P m−2
    rad :: Float64 = 0.001/(30.0*24.0) # from Table 3 (Yang 2014 BG); converted month-1 to hour-1
    rdes:: Float64 = 0.00022/(30.0*24.0) 
    rocl:: Float64 = 1.0e-6/(30.0*24.0)
    rwea:: Float64 = 0.001/(30.0*24.0)
"rl: leaching constant"
    rl::   Float64 = 0.04/(365.0*24.0) # Wang 2010 equation D14; converted year-1 to hour-1
end
