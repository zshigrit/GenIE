function InitIP!(
ip::MPPools,ppar::PPar
)

    @unpack Smax,Ks = ppar
    
    ip.POx = 3.0 # gP/m2
    ip.Ps  = Smax*ip.POx/(Ks+ip.POx) #2.0
    ip.Pss = 40.0 # gP/m2
    ip.Ppm = 0.0 # flag 
    ip.Po  = 5.0

    return nothing 

end
