function NH4sorption!(mnpools::MNPools,par::SoilPar)
    mnpools.NH4tot = mnpools.NH4 + mnpools.NH4ads 
    rtp2 = par.Kba_NH4 * (mnpools.NH4tot - par.Qmax_NH4) - 1.0
    mnpools.NH4 = (rtp2 + sqrt(rtp2*rtp2+4.0*par.Kba_NH4*mnpools.NH4tot))/(2.0*par.Kba_NH4)
    mnpools.NH4ads = mnpools.NH4tot - mnpools.NH4
    return nothing 
end 