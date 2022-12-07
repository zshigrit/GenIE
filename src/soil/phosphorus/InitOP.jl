const rNPsoil,rNPmic,rNPenz = 10.0,2.0,2.0 # flag: treat these NP ratios constant for now

function InitPPools(ini_cpools::Pools,par::AddPar)
    @unpack POMo,POMh,MOM,DOM,QOM,MBA,MBD,EPO,EPH,EM = ini_cpools
    poc_o,poc_h,moc,doc,qoc,mbc_a,mbc_d,epo,eph,em = POMo,POMh,MOM,DOM,QOM,MBA,MBD,EPO,EPH,EM

    frac = [poc_o/(poc_o+poc_h+moc),poc_h/(poc_o+poc_h+moc),moc/(poc_o+poc_h+moc)]
    rRead = frac[1]/(1.0/par.CN_SOM - frac[3]/par.CN_MOM - frac[2]/par.const_CN_Cellulose)

    pop_o = poc_o/rRead/rNPsoil 
    pop_h = poc_h/par.const_CN_Cellulose/rNPsoil
    mop   = moc/par.CN_MOM/rNPsoil
    qop   = qoc/par.CN_MOM/rNPsoil 
    dop   = doc/par.CN_DOM/rNPsoil
    mbp_a = mbc_a/par.CN_MB/rNPmic
    mbp_d = mbc_d/par.CN_MB/rNPmic
    epo_p = epo/par.CN_ENZP/rNPenz
    eph_p = eph/par.CN_ENZP/rNPenz
    em_p = em/par.CN_ENZM/rNPenz

    # NH4    = 0.5 * 5.5e-4 # in SOIL_INI.dat 
    # NH4ads = 0.5 * 5.5e-4 
    # NO3    = 1.5e-4
    # NO2    = 0.1 * NO3 
    # NO     = 0.05 * NO3 
    # N2O    = NO 
    # N2     = 1.0e-2

    # rRead  = NH4 + NO3 + NO2 + NO + N2O + N2 
    # rRead  = rRead/(pon_o + pon_h + mon)
    # ENZNmt = rRead * (epo + eph + em)
    # # ENZNm  = Array{Float64}(undef, 6)
    # ENZNm  = MVector{6,Float64}(undef) # 
    # ENZNm .= ENZNmt/Float64(length(ENZNm))
    # ENZNm_N= ENZNm/par.CN_ENZM 

    ppools  = Pools(pop_o,pop_h,mop,dop,qop,mbp_a,mbp_d,epo_p,eph_p,em_p)
    # mnpools = MNPools(0.0,0.0,0.0,0.0,NH4ads,NH4,0.0,0.0,NO3,NO2,NO,N2O,N2,0.0)
    # enzyme_c= Enzyme_N(ENZNmt,ENZNm)
    # enzyme_n= Enzyme_N(ENZNmt/par.CN_ENZM, ENZNm_N)
    return ppools
end

function InitCP(par_add::AddPar)
    cpools  = InitCPools();
    @unpack POMo,POMh,MOM,DOM,QOM,MBA,MBD,EPO,EPH,EM = cpools
    poc_o,poc_h,moc,doc,qoc,mbc_a,mbc_d,epo,eph,em = POMo,POMh,MOM,DOM,QOM,MBA,MBD,EPO,EPH,EM

    ppools = InitPPools(cpools, par_add);
    @unpack POMo,POMh,MOM,DOM,QOM,MBA,MBD,EPO,EPH,EM = ppools
    pon_o,pon_h,mon,don,qon,mbn_a,mbn_d,epo_n,eph_n,em_n = POMo,POMh,MOM,DOM,QOM,MBA,MBD,EPO,EPH,EM
    rCP = Pools(poc_o/pon_o,poc_h/pon_h,moc/mon,doc/don,qoc/qon,mbc_a/mbn_a,mbc_d/mbn_d,
    epo/epo_n,eph/eph_n,em/em_n)
    return rCP
end 
