function Rcn(cpools::Pools, npools::Pools)
    @unpack POMo,POMh,MOM,DOM,QOM,MBA,MBD,EPO,EPH,EM = cpools
    poc_o,poc_h,moc,doc,qoc,mbc_a,mbc_d,epo,eph,em = POMo,POMh,MOM,DOM,QOM,MBA,MBD,EPO,EPH,EM
    @unpack POMo,POMh,MOM,DOM,QOM,MBA,MBD,EPO,EPH,EM = npools
    pon_o,pon_h,mon,don,qon,mbn_a,mbn_d,epo_n,eph_n,em_n = POMo,POMh,MOM,DOM,QOM,MBA,MBD,EPO,EPH,EM
    rCN = Pools(poc_o/pon_o,poc_h/pon_h,moc/mon,doc/don,qoc/qon,mbc_a/mbn_a,mbc_d/mbn_d,
    epo/epo_n,eph/eph_n,em/em_n)
    return rCN
end 