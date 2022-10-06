function TMPscalar(case, T)
    case=="BG" ? Ea = 42.2 :
    case=="CBH" ? Ea = 32.2 :
    case=="EG" ? Ea = 34.4 :

    case=="PER" ? Ea = 52.9 :
    case=="POX" ? Ea = 53.1 :
    case=="LIG" ? Ea = 53.0 :

    case=="CEL" ? Ea = 36.3 :
    case=="NAG" ? Ea = 52.9 :
    case=="PAC" ? Ea = 36.3 :

    case=="PAL" ? Ea = 23.6 :
    case=="PHO" ? Ea = 34.4 :
    case=="Km" ? Ea = 30.0 :

    case=="MR" ? Ea = 20.0 :
    case=="Kads" ? Ea = 5.0 :
    case=="Kdes" ? Ea = 20.0 :

    case=="DOM" ? Ea = 47.0 :

    Ea = 47.0

    Tref = 20.0
    TKref = Tref + 273.15
    TK = T + 273.15
    const_R = 8.314
    return exp(Ea*1.0e3/const_R * (1.0/TKref - 1.0/TK))
end

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

function SWscalar(SWP)
    SWPmin = -exp(2.5*log(10.0))
    SWPlow = -exp(-1.5*log(10.0))
    SWPhigh = -exp(-2.5*log(10.0))
    SWPmax = -exp(-4.0*log(10.0))

    SWP <= SWPmin ? fSWP_OPT = 0.0 :
    SWP <= SWPlow ? fSWP_OPT = 0.625-0.25*log10(abs(SWP)) :
    SWP <= SWPhigh ? fSWP_OPT = 1.0 :
    SWP <= SWPmax ? fSWP_OPT = (2.5+0.4*log10(abs(SWP)))/1.5 :
    fSWP_OPT = 0.6
    return fSWP_OPT
end



function TMPdep!(par::SoilPar,TMP,...) 
    # par.fINP = par.fINP
    # par.Q10 = par.Q10
    # par.rNleach  = par.rNleach
    # par.bNup_VG = par.bNup_VG
    # par.fRa        = par.fRa
    # par.fpENZN   = par.fpENZN
    par.vd_pomo = par.vd_pomo * TMPscalar("LIG", TMP)

end

function SWCdep!(wp,) 
    par.vd_pomo = par.vd_pomo * SWscalar(wp)
end

function PHdep!()
end





function ttestt(b)
    b==2 ? kk = b^3 :
    b==3 ? kk=b^2 :
    error("Illegal imode value")
    # return kk
end