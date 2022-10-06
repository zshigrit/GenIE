function fSWP2SWC(SWCres,SWCsat,alpha,n)
    SWP = -0.033
    const_cm2MPa = 98e-6 # 1cm water column 
    SWP_cm = SWP/const_cm2MPa # SWP unit: MPa
    m = 1.0 - 1.0/n 
    eff_sat = (1.0/(1.0+(alpha*abs(SWP_cm))^n))^m 
    fSWP2SWC = SWCres + (SWCsat - SWCres)*eff_sat
    return fSWP2SWC
end

function fSWC2SWP(SWC0,SWCres,SWCsat,alpha,n,SWPmin)
    const_cm2MPa = 98e-6 # 1cm water column 
    rlim = 1.01 
    m = 1.0 - 1.0/n 

    if SWC0<=SWCres*rlim 
        SWC = SWCres*rlim 
    else
        SWC = SWC0
    end

    if SWC<SWCsat 
        eff_sat = (SWC - SWCres)/(SWCsat - SWCres)
        fSWC2SWP = (1.0/(eff_sat^(1.0/m)) - 1.0)^(1.0/n)/alpha
        fSWC2SWP = -1.0*fSWC2SWP*const_cm2MPa
    else
        fSWC2SWP = 0.0
    end
    return fSWC2SWP
end 

