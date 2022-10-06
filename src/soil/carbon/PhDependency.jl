function PHscalar(case,pH)
    case=="BG" ? (pHopt, pHsen) = (5.6, 1.7) :
    case=="CBH" ? (pHopt, pHsen) = (5.1, 2.1) :
    case=="EG" ? (pHopt, pHsen) = (5.1, 1.6) :
    case=="PER" ? (pHopt, pHsen) = (4.5, 1.5) :
    case=="POX" ? (pHopt, pHsen) = (4.1, 1.4) :
    case=="LIG" ? (pHopt, pHsen) = (4.2, 1.4) :
    case=="CEL" ? (pHopt, pHsen) = (5.3, 1.7) :
    case=="PAC" ? (pHopt, pHsen) = (5.2, 1.8) :
    case=="PHO" ? (pHopt, pHsen) = (6.0, 2.0) :
    case=="ENZ" ? (pHopt, pHsen) = (4.8, 1.6) :
    (pHopt, pHsen) = (6.0, 2.0)
    return exp(-1.0 * ((pH - pHopt)/pHsen)^2.0)
end

function PHdep!(par::SoilPar,pH)
    par.vd_pomo = par.vd_pomo * PHscalar("LIG",pH)
    par.vd_pomh = par.vd_pomh * PHscalar("CEL",pH)
    par.vd_mom = par.vd_mom * PHscalar("ENZ", pH)
end