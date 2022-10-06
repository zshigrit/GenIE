function fO2_CONC(SWC,Porosity) 
    Dgas = 1.67
    frac_O2_in_air = 0.209
    AFP = max(0,Porosity-SWC) # air-filled porosity
    fO2_CONC = Dgas*frac_O2_in_air*AFP^(4.0/3.0)
    return fO2_CONC
end

function fO2_scalar(SWC,Porosity)
    Ks_O2   = fO2_CONC(0.5*Porosity,Porosity)
    O2_CONC = fO2_CONC(SWC,Porosity)
    fO2_scalar = O2_CONC/(O2_CONC + Ks_O2)
    return fO2_scalar
end