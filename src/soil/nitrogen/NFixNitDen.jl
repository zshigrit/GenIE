function NFixNitDen(
    par::SoilPar, enzymes::Enzyme_N,mnpools::MNPools,
    inp_enzymes::Enzyme_N, inp_mnpools::MNPools
)
    Denit = Array{Float64}(undef, 4)    

    # inp_enzymes = deepcopy(enzymes) 
    # inp_mnpools = deepcopy(mnpools) 

    @unpack VNif,KsNit,VNit,VDenit,KsDenit, KsNif = par 
    @unpack ENZNmt,ENZNm = inp_enzymes 
    @unpack N2,NH4 = inp_mnpools

    NFix = VNif * ENZNm[1]* N2/(KsNif+N2)*(1.0-NH4/(KsNit+NH4))
    Nitrif = VNit * ENZNm[2] * mnpools.NH4/(KsNit+mnpools.NH4)

    Denit[1] = VDenit[1]*ENZNm[3]*mnpools.NO3/(KsDenit[1]+mnpools.NO3)
    Denit[2] = VDenit[2]*ENZNm[4]*mnpools.NO2/(KsDenit[2]+mnpools.NO2)
    Denit[3] = VDenit[3]*ENZNm[5]*mnpools.NO/(KsDenit[3]+mnpools.NO)
    Denit[4] = VDenit[4]*ENZNm[6]*mnpools.N2O/(KsDenit[4]+mnpools.N2O)

    return NFix,Nitrif,Denit

end