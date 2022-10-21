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

function fT_CUE(T,Tref,slope,CUEref)
    CUEmax = 0.9
    CUEmin = 0.1e-1
    
    fT_CUE = slope * (T - Tref) + CUEref

    if fT_CUE > CUEmax
        fT_CUE = CUEmax
    elseif fT_CUE < CUEmin
        fT_CUE = CUEmin
    end

    return fT_CUE
end

function TMPdep!(soil::Soil,TMP) 
    # par.fINP = par.fINP
    # par.Q10 = par.Q10
    # par.rNleach  = par.rNleach
    # par.bNup_VG = par.bNup_VG
    # par.fRa        = par.fRa
    # par.fpENZN   = par.fpENZN
    par = soil.par;
    par_base = soil.par_base;
    par.vd_pomo = par_base.vd_pomo * TMPscalar("LIG", TMP)
    par.vd_pomh = par_base.vd_pomh * TMPscalar("CEL", TMP)
    par.ks_pomh = par_base.ks_pomh * TMPscalar("Km",TMP)
    par.ks_pomo = par_base.ks_pomo * TMPscalar("Km",TMP)
    par.vd_mom = par_base.vd_mom * TMPscalar("ENZ", TMP)
    par.ks_mom = par_base.ks_mom * TMPscalar("Km",TMP)
    par.Kp2u   = par_base.Kp2u * TMPscalar("Km", TMP)
    par.Ku2p   = par_base.Ku2p * TMPscalar("Km", TMP)
    par.Kdes   = par_base.Kdes * TMPscalar("Kdes", TMP)
    par.Kads   = par_base.Kads * TMPscalar("Kads", TMP)
    par.Vg     = par_base.Vg * TMPscalar("DOM", TMP)
    par.Vm     = par_base.Vm * TMPscalar("MR", TMP)
    par.KsDOM  = par_base.KsDOM * TMPscalar("Km", TMP)

    CUE_ref    = par_base.Yg 
    CUE_slope  = par_base.CUE_slope
    const_Tref = 20.0
    par.Yg = fT_CUE(TMP, const_Tref, CUE_slope, CUE_ref)
    par.VmA2D = par_base.VmA2D * TMPscalar("MR", TMP)
    par.VmD2A = par_base.VmD2A * TMPscalar("MR", TMP)
    par.VNup_MB = par_base.VNup_MB * TMPscalar("NH4", TMP)
    par.KsNH4_MB = par_base.KsNH4_MB * TMPscalar("Km", TMP)
    par.KsNO3_MB = par_base.KsNO3_MB * TMPscalar("Km", TMP)

    par.VNif = par_base.VNif * TMPscalar("NFIX", TMP)
    par.KsNif = par_base.KsNif * TMPscalar("Km", TMP)

    par.VNit = par_base.VNit * TMPscalar("NITRIF", TMP)
    par.KsNit = par_base.KsNit * TMPscalar("Km", TMP)

    par.VDenit[1]  = par_base.VDenit[1] * TMPscalar("DENITRIF_NO3", TMP)
    par.KsDenit[1] = par_base.KsDenit[1] * TMPscalar("Km", TMP)
    par.VDenit[2]  = par_base.VDenit[2] * TMPscalar("DENITRIF_NO2", TMP)
    par.KsDenit[2] = par_base.KsDenit[2] * TMPscalar("Km", TMP)
    par.VDenit[3]  = par_base.VDenit[3] * TMPscalar("DENITRIF_NO", TMP)
    par.KsDenit[3] = par_base.KsDenit[3] * TMPscalar("Km", TMP)
    par.VDenit[4]  = par_base.VDenit[4] * TMPscalar("DENITRIF_N2O", TMP)
    par.KsDenit[4] = par_base.KsDenit[4] * TMPscalar("Km", TMP)

    par.VNup_VG  = par_base.VNup_VG * TMPscalar("Nup_PLANT", TMP)
    par.KsNH4_VG = par_base.KsNH4_VG * TMPscalar("Nup_PLANT", TMP)
    par.KsNO3_VG = par_base.KsNO3_VG * TMPscalar("Nup_PLANT", TMP)

end
