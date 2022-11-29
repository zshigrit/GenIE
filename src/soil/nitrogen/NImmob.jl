function NImmob(par::SoilPar,mnpools::MNPools,npools::Pools,phi) # microbes
    #!!IMMOBILIZATION: FIRST TIME
    @unpack NH4,NO3 = mnpools 
    @unpack KsNH4_MB,KsNO3_MB,KsNH4_VG,KsNO3_VG,VNup_MB = par 
    @unpack MBA = npools 
    rtp1 = 1.0 + NH4/KsNH4_MB + NO3/KsNO3_MB + NH4/KsNH4_VG + NO3/KsNO3_VG    
    rtp2 = NH4/(NH4 + NO3)
    Nim_NH4 = VNup_MB * rtp2 * phi * NH4 * MBA/(KsNH4_MB*(rtp1 + MBA/KsNH4_MB))
    Nim_NO3 = VNup_MB *(1.0 - rtp2) * phi * NO3 * MBA/(KsNO3_MB*(rtp1 + MBA/KsNO3_MB))
    Nim     = Nim_NH4 + Nim_NO3
    return Nim_NH4,Nim_NO3,Nim
end


function NImmob(par::SoilPar,par_add::AddPar,
                mnpools::MNPools,GPP) # plants
    @unpack NH4,NO3 = mnpools
    @unpack VNup_VG,KsNH4_VG,bNup_VG,KsNH4_MB,KsNO3_MB,KsNH4_VG,KsNO3_VG = par 
    @unpack GPPref = par_add 
    VNup_VG_GPPscaler = exp((GPP/GPPref - 1.0) * bNup_VG)
    rtp1 = 1.0 + NH4/KsNH4_MB + NO3/KsNO3_MB + NH4/KsNH4_VG + NO3/KsNO3_VG 
    Nim_NH4_VG = (VNup_VG * VNup_VG_GPPscaler) * NH4 / (KsNH4_VG*rtp1)
    Nim_NO3_VG = (VNup_VG * VNup_VG_GPPscaler) * NO3 / (KsNO3_VG*rtp1)
    Nim_VG     = Nim_NH4_VG + Nim_NO3_VG
    return Nim_NH4_VG,Nim_NO3_VG,Nim_VG
end


function NImmobAlt(par::SoilPar,par_add::AddPar,
    mnpools::MNPools,GPP,leaf::Leaf) # plants

    @unpack rCN,rCNmax,rCNmin = leaf 
    scalar_conversion = 1e-3*1e6  # mg N/cm3/ to g N/m3
    Ndemand = GPP*(1e-3*1e4)*0.5/rCNmin # gpp : mg/cm2/h to g/m2/h; 0.5: gpp to npp 
    if Ndemand > (mnpools.NH4 + mnpools.NO3)*scalar_conversion
        Nuptake = (mnpools.NH4 + mnpools.NO3)*scalar_conversion
        # if GPP*(1e-3*1e4)/Nuptake > rCNmax 
        #     GPP = (Nuptake * rCNmax)/(1e-3*1e4)
        # end
    else
        Nuptake=Ndemand
    end

    # if Nuptake > (mnpools.NH4 + mnpools.NO3)*scalar_conversion 
    #     Nuptake = GPP/rCNmax 
    #     if Nuptake > (mnpools.NH4 + mnpools.NO3)*scalar_conversion 
    #         Nuptake = (mnpools.NH4 + mnpools.NO3)*scalar_conversion 
    #     end
    # else
    #     Nuptake = GPP/rCNmin 
    #     if Nuptake > (mnpools.NH4 + mnpools.NO3)*scalar_conversion 
    #         Nuptake = (mnpools.NH4 + mnpools.NO3)*scalar_conversion 
    #     end
    # end

Nim_NH4_VG = Nuptake * mnpools.NH4 / (mnpools.NH4+mnpools.NO3) / scalar_conversion
Nim_NO3_VG = Nuptake * mnpools.NO3 / (mnpools.NH4+mnpools.NO3) / scalar_conversion
Nim_VG     = Nuptake / scalar_conversion
return Nim_NH4_VG,Nim_NO3_VG,Nim_VG, Nuptake
end