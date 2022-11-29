##5 Initialize the model
"""
parameters altered with depth
"""

# parameterization
function InitParDepth!(par::SoilPar,ilayer,par_vary)
    sl = SoilLayersX()
    # par_vary = par_dec
    VaryTraitsDepth!(par,sl,ilayer,par_vary)
    # VaryTraitsClima!(par,sl,ilayer)
    return nothing
end

function InitCPools(ilayer)
    # initial carbon pool
    sl = SoilLayersX()
    sl_dif = [(sl.layer1[2]-sl.layer1[1]),
                (sl.layer2[2]-sl.layer2[1]),
                (sl.layer3[2]-sl.layer3[1]),
                (sl.layer4[2]-sl.layer4[1]),
                (sl.layer5[2]-sl.layer5[1]),
                100.0]

    allocationcoeff = [0.35,0.3,0.2,0.1,0.05,1.0]
    scalar = 100.0/sl_dif[ilayer]
    soc = 1.578 * allocationcoeff[ilayer] * scalar # mg/cm3 
    poc = 0.377 * allocationcoeff[ilayer] * scalar
    poc_o = poc * LF0; poc_h = poc * (1.0 - LF0); 

    moc = 1.064 * allocationcoeff[ilayer] * scalar ;
    qoc = moc * fQOM; 

    doc = 0.137 * allocationcoeff[ilayer] * scalar;

    mbc = 0.033 * allocationcoeff[ilayer] * scalar; 
    mbc_a = mbc * r0; mbc_d = mbc * (1.0 - r0);

    epo = 6.0e-5 * allocationcoeff[ilayer] * scalar
    eph = 6.0e-5 * allocationcoeff[ilayer] * scalar
    em  = 6.0e-5 * allocationcoeff[ilayer] * scalar

    # _CPools = CPools(10000.,10000.,2000.,200.,120.,100.,150.,0.1,0.1,0.1)
    cpools = CPools(poc_o,poc_h,moc,doc,qoc,mbc_a,mbc_d,epo,eph,em)
    return cpools
end

function InitCFluxes(ilayer)
    cfluxes = CFluxes()
    return cfluxes
end

function InitCInputs(ilayer,par)
    ## carbon input
    # litter_pomo = 100000.0/365.0/24.0 * 0.5
    # litter_pomh = 100000.0/365.0/24.0 * 0.25
    # litter_dom = 100000.0/365.0/24.0 * 0.25
    allocationcoeff = [0.35,0.3,0.2,0.1,0.05,1.0]

    # SIN_day_str = readlines("../../../test/SIN_day.dat") # unit: mgC-cm2-d
    abs_path = "../test/"
    SIN_day_str = readlines(abs_path*"SIN_day.dat") 

    SIN_day = parse.(Float64, SIN_day_str) # string to numeric

    SIN_day = SIN_day[3:end]

    SIN_hour = SIN_day ./24

    SIN_input = SIN_hour .* par.fINP;
    
    sl = SoilLayersX()
    sl_dif = [(sl.layer1[2]-sl.layer1[1]),
                (sl.layer2[2]-sl.layer2[1]),
                (sl.layer3[2]-sl.layer3[1]),
                (sl.layer4[2]-sl.layer4[1]),
                (sl.layer5[2]-sl.layer5[1]),
                100.0]

    # 0.07, 0.37, 0.56 # fraction type I
    f_l_pomo = 0.07 # to be added to parameter list 
    f_l_pomh = 0.37 # to be added to parameter list
    f_l_dom = 0.56 # to be added to parameter list
    litter_pomo_array = SIN_input .* f_l_pomo/sl_dif[ilayer] * allocationcoeff[ilayer];
    litter_pomh_array = SIN_input .* f_l_pomh/sl_dif[ilayer] * allocationcoeff[ilayer];
    litter_dom_array  = SIN_input .* f_l_dom/sl_dif[ilayer] * allocationcoeff[ilayer]; 
    input_c = DataFrame()
    input_c[!,"litter_pomo_array"] = litter_pomo_array
    input_c[!,"litter_pomh_array"] = litter_pomh_array
    input_c[!,"litter_dom_array"]  = litter_dom_array
    return input_c
end


"""
init for single layer
"""

##5 Initialize the model

function InitCPools()
    # parameters to be added 
    LF0 = 0.1
    r0 = 0.01
    fQOM = 0.05

    soc = 1.578  
    poc = 0.377 
    poc_o = poc * LF0; poc_h = poc * (1.0 - LF0); 

    moc = 1.064
    qoc = moc * fQOM; 

    doc = 0.137 

    mbc = 0.033 
    mbc_a = mbc * r0; mbc_d = mbc * (1.0 - r0);

    epo = 6.0e-5 
    eph = 6.0e-5 
    em  = 6.0e-5 

    cpools = Pools(poc_o,poc_h,moc,doc,qoc,mbc_a,mbc_d,epo,eph,em)
    return cpools
end

function InitCFluxes()
    cfluxes = Fluxes()
    return cfluxes
end

function InitCInputs(par::SoilPar)


    # SIN_day_str = readlines("../../../test/SIN_day.dat") # unit: mgC-cm2-d
    abs_path = "../test/"
    SIN_day_str = readlines(abs_path*"SIN_day.dat") 

    SIN_day = parse.(Float64, SIN_day_str) # string to numeric

    SIN_day = SIN_day[3:end]

    SIN_hour = SIN_day ./24

    SIN_input = SIN_hour .* par.fINP;
    

    # 0.07, 0.37, 0.56 # fraction type I
    f_l_pomo = 0.07 # to be added to parameter list 
    f_l_pomh = 0.37 # to be added to parameter list
    f_l_dom = 0.56 # to be added to parameter list
    depth = 100.0
    litter_pomo_array = SIN_input .* (f_l_pomo/depth)
    litter_pomh_array = SIN_input .* (f_l_pomh/depth)
    litter_dom_array  = SIN_input .* (f_l_dom/depth)
    input_c = DataFrame()
    input_c[!,"litter_pomo_array"] = litter_pomo_array
    input_c[!,"litter_pomh_array"] = litter_pomh_array
    input_c[!,"litter_dom_array"]  = litter_dom_array
    return input_c
end

function inp_gpp()

    # SIN_day_str = readlines("../../../test/SIN_day.dat") # unit: mgC-cm2-d
    abs_path = "../test/"
    SIN_day_str = readlines(abs_path*"SIN_day.dat") 

    SIN_day = parse.(Float64, SIN_day_str) # string to numeric

    SIN_day = SIN_day[3:end]

    SIN_hour = SIN_day ./24

    return SIN_hour

end

function inp_swc()
    abs_path = "../test/"
    SIN_day_str = readlines(abs_path*"SWC_day.dat") 
    # SIN_day_str = readlines("./test/SWC_day.dat") 

    SIN_day = parse.(Float64, SIN_day_str) # string to numeric

    SIN_day = SIN_day[3:end]

    SIN_hour = SIN_day

    return SIN_hour
end

function inp_stp()
    # SIN_day_str = readlines("../../../test/STP_day.dat") 
    abs_path = "../test/"
    SIN_day_str = readlines(abs_path*"STP_day.dat") 

    SIN_day = parse.(Float64, SIN_day_str) # string to numeric

    SIN_day = SIN_day[3:end]

    SIN_hour = SIN_day

    return SIN_hour
end

function inp_ph()
    abs_path = "../test/"
    SIN_month = readdlm(abs_path*"SPH_mon.dat", ',', skipstart=1)
    SIN_hour = SIN_month[1:end,3]
    return SIN_hour
end
