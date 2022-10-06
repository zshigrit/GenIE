function fPa(altitude)
    AltMax = 8200.0
    const_Pa0 = 101.3 # kpa
    fPa = const_Pa0 * exp(-altitude/AltMax)
    return fPa 
end

function fNOxAir(Ngas, Altitude, Temperature)
    const_R = 8.314
    const_tmp_C2K = 273.15

    Pressure = fPa(Altitude)*1000.0
    VolAir = 1.0 
    if Ngas == "NO"
        NOxAir_ppb = 0.1
        nN=1.0
        MolMass = 14.0
    elseif Ngas == "N2O"
        NOxAir_ppb = 310.0
        nN=2.0
        MolMass = 14.0
    elseif Ngas == "N2"
        NOxAir_ppb = 78.09e7  #!!78.09%
        nN=2.0
        MolMass = 14.0
    else  #CO2
        NOxAir_ppb = 4e5  #!!400 ppm = 0.04%
        nN=1.0
        MolMass = 12.0
    end
    
    fNOxAir = (NOxAir_ppb * 1e-9 * Pressure * VolAir / 
            (const_R * (Temperature + const_tmp_C2K)) * MolMass * nN)

    return fNOxAir
end

function fDCair(DCa0, altitude, temp)
    const_Pa0 = 101.3 # kpa
    const_tmp_C2K = 273.15
    Pa = fPa(altitude)
    fDCair = DCa0 * const_Pa0 / Pa *(((const_tmp_C2K+temp)/const_tmp_C2K)^1.75)
    return fDCair 
end

function fTort(x)
    dTort = -0.599 + 1.442 * x - 5.93 * x * x + 14.08 * (x^3.0) - 15.34 * (x^4.0) + 6.248 * (x^5.0)
    fTort = exp(dTort)
    return fTort 
end

function subDiffusivity(sPAR::sDIFFUSIVITY_PAR, SWC)
    @unpack Poro, SWCFC, DCa = sPAR 

    x = Vector{Float64}(undef,3)
    y = Vector{Float64}(undef,3)

    PoroIn =  SWCFC 
    PoroEx = Poro - PoroIn 

    SWC = min(SWC, Poro)

    if SWC<SWCFC
        AFPIn = SWCFC -SWC 
        AFPEx = PoroEx 
    else
        AFPIn = 0.0
        AFPEx = PoroEx - (SWC - SWCFC)
    end

    AFP = AFPIn + AFPEx
    x[2] = PoroEx

    if SWC<PoroIn 
        x[1] = (PoroIn - SWC)/(1.0 - PoroEx)
        x[3] = PoroEx 
    else
        x[1] = 0.0
        x[3] = Poro - SWC 
    end

    for i = 1:3
        y[i] = fTort(x[i])
    end

    AFPPoroIn = AFPIn/PoroIn 
    AFPPoroEx = AFPEx/PoroEx 

    dtmp1 = ((AFPPoroIn^2.0) * (abs(AFPPoroIn-PoroEx)^(2.0*y[1])) 
            * (1.0-(PoroEx^(2.0*y[2]))) * (AFPEx-(AFPEx^(2.0*y[3])))
            )
    dtmp2 = ((AFPPoroIn^2.0) * ((AFPPoroIn-PoroEx)^2.0) 
            * (1.0-(PoroEx^(2.0*y[2]))) * (AFPEx-(AFPEx^(2.0*y[3])))
            )
    dtmp3 = (AFPPoroEx^2.0) * (AFPEx^(2.0*y[3]))

    DCratio = dtmp1/max(dtmp2,1.0e-20) + dtmp3
    DCs = DCratio * DCa

    sOUT = sDIFFUSIVITY_OUT(DCratio,DCs,AFP,PoroIn,PoroEx,AFPIn,AFPEx,x,y)

    return sOUT 
end 

function fGasEfflux(
    Ngas, Gas_Conc_Soil, Porosity, Diff_Dist, Altitude, SWCFC, SWC, Temperature
    )
    DiffAir0 = 0.05148
    Gas_Conc_Air = fNOxAir(Ngas, Altitude, Temperature) * 0.001
    DiffAir = fDCair(DiffAir0, Altitude, Temperature)
    ParDiffu = sDIFFUSIVITY_PAR(Porosity,SWCFC,DiffAir)
    OutDiffu = subDiffusivity(ParDiffu, SWC)
    DiffSoil = OutDiffu.DCs 
    fGasEfflux_unit_area = DiffSoil * (Gas_Conc_Soil - Gas_Conc_Air) / Diff_Dist * 1.0e4
    fGasEfflux = fGasEfflux_unit_area/(2.0*Diff_Dist) 

    if fGasEfflux>0.0
        fGasEfflux = min(fGasEfflux, Gas_Conc_Soil)
    end

    return fGasEfflux

end 