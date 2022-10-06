function ENZNm(par::SoilPar,mnpools::MNPools,enzymes_c::Enzyme_N,rtp1)
    frENZNm = Array{Float64}(undef, 6) 
    frENZNm[1] = mnpools.N2/par.KsNif
    frENZNm[2] = mnpools.NH4/par.KsNit
    frENZNm[3] = mnpools.NO3/par.KsDenit[1]
    frENZNm[4] = mnpools.NO2/par.KsDenit[2]
    frENZNm[5] = mnpools.NO/par.KsDenit[3]
    frENZNm[6] = mnpools.N2O/par.KsDenit[4]

    frENZNm[1] = frENZNm[1]/sum(frENZNm)
    frENZNm[2] = frENZNm[2]/sum(frENZNm)
    frENZNm[3] = frENZNm[3]/sum(frENZNm)
    frENZNm[4] = frENZNm[4]/sum(frENZNm)
    frENZNm[5] = frENZNm[5]/sum(frENZNm)
    frENZNm[6] = frENZNm[6]/sum(frENZNm)

    MBA_ENZNm = frENZNm * rtp1
    ENZNm_DOM = par.rENZM * enzymes_c.ENZNm

    return MBA_ENZNm, ENZNm_DOM
    
end 