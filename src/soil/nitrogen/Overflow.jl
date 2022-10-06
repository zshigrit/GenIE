function Overflow!(
            par::SoilPar,par_add::AddPar,par_der::DerPar,
            cpools::Pools,npools::Pools,rCN::Pools,mnpools::MNPools,
            inp_cpools, inp_npools, inp_rCN, inp_mnpools,
            Nmn_MBA, Nim_NH4, Nim_NH4_VG, Nim_NO3, Nim_NO3_VG
)


# (1) MBD 
    CO2_ovflow_MBD = 0.0
    Nmn_MBD = 0.0
    rtp1 = cpools.MBD / npools.MBD 
    # Note: MEND used rtp1 = sOUT % CPOOL % MBD/sOUT % NPOOL % MBD (INSTEAD OF sINP)
    if rtp1 < par_add.CN_MB_min 
        rtp2 = cpools.MBD/par_add.CN_MB_min
        Nmn_MBD = npools.MBD - rtp2 
        npools.MBD = rtp2 
    elseif rtp1 > par_add.CN_MB_max
        rtp2 = npools.MBD * par_add.CN_MB_max
        CO2_ovflow_MBD = cpools.MBD - rtp2 
        cpools.MBD = rtp2 
    end

# (2) MBA: step1
    CO2_ovflow_MBA = 0.0
    rtp1 = cpools.MBA/npools.MBA 
    if rtp1<par_add.CN_MB_min 
        rtp2 = cpools.MBA/par_add.CN_MB_min 
        Nmn_MBA = Nmn_MBA + npools.MBA - rtp2 
        npools.MBA = rtp2 
    elseif rtp1>par_add.CN_MB_max
        rtp2 = cpools.MBA/par_add.CN_MB_max
        rtp3 = rtp2 - npools.MBA 
        # step2
        mnpools.NH4 = inp_mnpools.NH4 - Nim_NH4 - Nim_NH4_VG + Nmn_MBA + Nmn_MBD
        mnpools.NO3 = inp_mnpools.NO3 - Nim_NO3 - Nim_NO3_VG
        rtp4 = mnpools.NH4 + mnpools.NO3 
        ## IMMOBILIZATION for the second time 
        if rtp3<=rtp4
            Nim_NH4 = Nim_NH4 + rtp3*mnpools.NH4/rtp4 
            Nim_NO3 = Nim_NO3 + rtp3*mnpools.NO3/rtp4 
            Nim = Nim_NH4 + Nim_NO3
            npools.MBA = rtp2 
        else
            Nim_NH4 = Nim_NH4 + mnpools.NH4 
            Nim_NO3 = Nim_NO3 + mnpools.NO3 
            Nim = Nim_NH4 + Nim_NO3
            npools.MBA = npools.MBA + rtp4 
            CO2_ovflow_MBA = cpools.MBA - npools.MBA*par_add.CN_MB_max
            cpools.MBA = npools.MBA*par_add.CN_MB_max
        end
    end

    return Nmn_MBD, Nmn_MBA, Nim_NH4, Nim_NO3  
end