function InitIP(
ip::MPPools,ippar::IPPar
)

    @unpack Smax,Ks = ippar
    converter = 1000.0/1e6 # g/m2 to mg/cm3
    ip.POx = 30.0  # gP/m2
    ip.Ps  = Smax*ip.POx/(Ks+ip.POx) #2.0
    ip.Pss = 40.0 # gP/m2
    ip.Ppm = 0.0 # flag 
    ip.Po  = 5.0

    return ip 

end
