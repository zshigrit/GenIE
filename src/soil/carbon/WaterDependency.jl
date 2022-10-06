function fSWP2SWC(SWCres,SWCsat,alpha,n)
    SWP = -0.033
    const_cm2MPa = 98e-6 # 1cm water column 
    SWP_cm = SWP/const_cm2MPa # SWP unit: MPa
    m = 1.0 - 1.0/n 
    eff_sat = (1.0/(1.0+(alpha*abs(SWP_cm))^n))^m 
    fSWP2SWC = SWCres + (SWCsat - SWCres)*eff_sat
    return fSWP2SWC
end

function fSWC2SWP(SWC0,SWCres,SWCsat,alpha,n)
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

function SWscalar(SWC,vG::vanGenuchtenPar)
    @unpack vg_SWCres,vg_SWCsat,vg_alpha,vg_n = vG
    SWP = fSWC2SWP(SWC,vg_SWCres,vg_SWCsat,vg_alpha,vg_n)
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

function SWscalar(SWC,vG::vanGenuchtenPar,biome::String,som::String)
    @unpack vg_SWCres,vg_SWCsat,vg_alpha,vg_n = vG
    SWP = fSWC2SWP(SWC,vg_SWCres,vg_SWCsat,vg_alpha,vg_n)
    # som=="SOD" ? (SWPmin, w) = (-1.71, 1.43) :
    # som=="SOL" ? (SWPmin, w) = (-13.86, 1.20) :
    # som=="LIT" ? (SWPmin, w) = (-36.49, 1.04) :
    # error("no such case")

    if biome=="ASM"
        som=="SOD" ? (SWPmin, w) = (-1.71, 1.43) :
        som=="SOL" ? (SWPmin, w) = (-10.95, 1.26) :
        som=="LIT" ? (SWPmin, w) = (-36.49, 1.04) :
        error("no such case")
    elseif biome=="MGC"
        som=="SOD" ? (SWPmin, w) = (-1.71, 1.43) :
        som=="SOL" ? (SWPmin, w) = (-22.61, 1.11) :
        som=="LIT" ? (SWPmin, w) = (-39.73, 0.89) :
        error("no such case")
    elseif biome=="MDF"
        som=="SOD" ? (SWPmin, w) = (-1.71, 1.43) :
        som=="SOL" ? (SWPmin, w) = (-4.97, 1.07) :
        som=="LIT" ? (SWPmin, w) = (-29.0, 1.27) :
        error("no such case")
    elseif biome=="MCF"
        som=="SOD" ? (SWPmin, w) = (-1.71, 1.43) :
        som=="SOL" ? (SWPmin, w) = (-8.24, 1.40) :
        som=="LIT" ? (SWPmin, w) = (-39.85, 1.06) :
        error("no such case")
    else
        som=="SOD" ? (SWPmin, w) = (-1.71, 1.43) :
        som=="SOL" ? (SWPmin, w) = (-13.86, 1.2) :
        som=="LIT" ? (SWPmin, w) = (-36.49, 1.04) :
        error("no such case")
    end

    SWP_FC = -0.033 # field capacity SWP
    if SWP < SWPmin
        fSWP0 = 0.0
    elseif SWP < SWP_FC
        fSWP0 = 1-(log(SWP/SWP_FC)/log(SWPmin/SWP_FC))^w
    else
        fSWP0 = 1.0
    end
    return fSWP0
end 

function SWscalar(SWC,vG::vanGenuchtenPar,SWP_A2D,w) 
    """Soil Water Scalar for Microbial Dormancy"""
    @unpack vg_SWCres,vg_SWCsat,vg_alpha,vg_n = vG
    SWP = fSWC2SWP(SWC,vg_SWCres,vg_SWCsat,vg_alpha,vg_n)
    fSWP_A2D = abs(SWP)^w/(abs(SWP)^w + abs(SWP_A2D)^w)
    return fSWP_A2D
end 

function SWscalar_D2A(SWC, vG::vanGenuchtenPar, SWP_D2A, w)
    """Soil Water Scalar for Microbial reactivation"""
    @unpack vg_SWCres,vg_SWCsat,vg_alpha,vg_n = vG
    SWP = fSWC2SWP(SWC,vg_SWCres,vg_SWCsat,vg_alpha,vg_n)
    fSWP_D2A = abs(SWP_D2A)^w/(abs(SWP)^w + abs(SWP_D2A)^w)
    return fSWP_D2A
end

function SWscalar(case, SWC, vG::vanGenuchtenPar)
    """SWP Scalar for Nitrification/Denitrification Muller (1999)"""
    case == "NITRIF" ? (WFPcr, Slope, Intercept) = ([0.09, 0.54, 0.69, 1.0], [2.2,-3.23],[-0.19,3.23]) : 
    case == "DENITRIF_NO3" ? (WFPcr, Slope, Intercept) = ([0.36, 1.0, 1.0, 1.01], [1.56,0.0],[-0.56,1.0]) :
    case == "DENITRIF_NO2" ? (WFPcr, Slope, Intercept) = ([0.4, 0.6, 0.66, 0.7], [5.0,-20.0],[-2.0,14.0]) :
    case == "DENITRIF_NO" ? (WFPcr, Slope, Intercept) = ([0.1, 0.8, 0.9, 1.0], [1.43,-10.0],[-0.14,10.0]) :
    case == "DENITRIF_N2O" ? (WFPcr, Slope, Intercept) = ([0.4, 0.85, 1.0, 1.01], [2.22,0.0],[-0.89,1.0]) :
    (WFPcr, Slope, Intercept) = ([0.029, 0.54, 0.69, 1.0], [2.2,-3.23],[-0.19,3.23])
    # error("no such case")

    @unpack vg_SWCsat = vG
    WFP = min(1.0,SWC/vg_SWCsat)
    if WFP <= WFPcr[1]
        fWFP_PieceWise0 = 0.0   
    elseif WFP <= WFPcr[2]
        fWFP_PieceWise0 = Intercept[1] + Slope[1]*WFP
    elseif WFP <= WFPcr[3] 
        fWFP_PieceWise0 = 1.0
    elseif WFP <= WFPcr[4] 
        fWFP_PieceWise0 = Intercept[2] + Slope[2]*WFP
    else
        fWFP_PieceWise0 = 0.0 
    end

    fWFP_PieceWise0 = max(0.0, min(1.0, fWFP_PieceWise0))
    return fWFP_PieceWise0

end

function SWscalar(SWC, vG::vanGenuchtenPar,SWPsat)
    @unpack vg_SWCres,vg_SWCsat,vg_alpha,vg_n = vG
    SWP = fSWC2SWP(SWC,vg_SWCres,vg_SWCsat,vg_alpha,vg_n)
    SWPmin = -10.0
    if (SWP <= SWPmin) 
        fSWP_CLM = 0.0
    elseif (SWP <= SWPsat) 
        fSWP_CLM = log(SWPmin/SWP)/log(SWPmin/SWPsat)
    else
        fSWP_CLM = 1.0
    end 
    return fSWP_CLM
end

function SWCdep!(_par::SoilPar,par::SoilPar,SWC,vG::vanGenuchtenPar,biome,som) 
    par.vd_pomo = par.vd_pomo * SWscalar(SWC,vG)
    par.vd_pomh = par.vd_pomh * SWscalar(SWC,vG,biome,som)
    par.vd_mom  = par.vd_mom * SWscalar(SWC,vG,biome,som)
    par.rMORT = par.rMORT * SWscalar(SWC,vG,par.SWP_A2D,_par.wdorm)
    par.VmA2D = _par.VmA2D * SWscalar(SWC, vG, par.SWP_A2D, par.wdorm)
    par.VmD2A = _par.VmD2A * SWscalar_D2A(SWC, vG, par.SWP_D2A, par.wdorm)
    par.VNit = par.VNit * SWscalar("NITRIF",SWC, vG)
    par.VDenit[1] = par.VDenit[1] * SWscalar("DENITRIF_NO3", SWC, vG)
    par.VDenit[2] = par.VDenit[2] * SWscalar("DENITRIF_NO2", SWC, vG)
    par.VDenit[3] = par.VDenit[3] * SWscalar("DENITRIF_NO", SWC, vG)
    par.VDenit[4] = par.VDenit[4] * SWscalar("DENITRIF_N2O", SWC, vG)
    par.VNup_VG = par.VNup_VG * SWscalar(SWC, vG, -0.033)
end

