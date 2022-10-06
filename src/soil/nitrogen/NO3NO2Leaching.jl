function fracNO3_Leaching(
    STP,SWC,SWCsat,SWCfc,Ksat,Lambda,rNleach,soil_depth,dt
)

    KSWC0 = Ksat*((SWC/SWCsat)^(3.0+2.0/Lambda)) # unused
    KSWC0 = max(KSWC0,1.0e-10) # unused
    
    frac_NO3_dissolved = max((SWC/SWCsat)^3.0,1.0e-6)
    SWCexcess = max(0.0,SWC-SWCfc)
    
    time_perc = (SWCsat - SWCfc)*soil_depth/Ksat 
    
    SWCperc = SWCexcess*(1.0 - exp(-dt/max(1.0e-10,time_perc)))
    
    fracNO3_Leaching = rNleach * frac_NO3_dissolved * (SWCperc/max(SWC,1.0e-4)) 

    return fracNO3_Leaching
end


function NO3NO2Leaching!(mnpools::MNPools,par_der::DerPar)
    rtp1 = par_der.fNO3_Leaching
    NO3_Leaching = mnpools.NO3 * rtp1 
    NO2_Leaching = mnpools.NO2 * rtp1 
    NO32_Leaching = NO3_Leaching + NO2_Leaching 
    mnpools.NO3 = mnpools.NO3 - NO3_Leaching
    mnpools.NO2 = mnpools.NO2 - NO2_Leaching
end