function VaryTraitsDepth!(par::SoilPar,sl::SoilLayersX,ilayer::Integer,::Type{par_dec})
    @unpack vd_pomh,vd_pomo,vd_mom = par 
    @unpack Yg, Vg, Vm, Q10 = par
    @unpack layer1,layer2,layer3,layer4,layer5 = sl
    nlayers = 5
    if ilayer==1
        par.vd_pomh = vd_pomh * (100.0-layer1[1])/100.0  # assume a linear decrease with depth  
        par.vd_pomo = par.vd_pomh
        par.vd_mom = 0.01 * par.vd_pomh

        par.Yg = Yg * (100.0-layer1[1])/100.0
    elseif ilayer==2
        par.vd_pomh = vd_pomh * (100.0-layer2[1])/100.0
        par.vd_pomo = par.vd_pomh
        par.vd_mom = 0.01 * par.vd_pomh

        par.Yg = Yg * (100.0-layer2[1])/100.0
    elseif ilayer==3
        par.vd_pomh = vd_pomh * (100.0-layer3[1])/100.0
        par.vd_pomo = par.vd_pomh
        par.vd_mom = 0.01 * par.vd_pomh

        par.Yg = Yg * (100.0-layer3[1])/100.0
    elseif ilayer==4
        par.vd_pomh = vd_pomh * (100.0-layer4[1])/100.0
        par.vd_pomo = par.vd_pomh
        par.vd_mom = 0.01 * par.vd_pomh

        par.Yg = Yg * (100.0-layer4[1])/100.0
    elseif ilayer==5
        par.vd_pomh = vd_pomh * (100.0-layer5[1])/100.0
        par.vd_pomo = par.vd_pomh
        par.vd_mom = 0.01 * par.vd_pomh

        par.Yg = Yg * (100.0-layer5[1])/100.0
    else
        par.vd_pomh = vd_pomh
        par.vd_pomo = vd_pomo
        par.vd_mom  = vd_mom
        par.Yg      = Yg
    end
    return nothing
end

function VaryTraitsDepth!(par::SoilPar,sl::SoilLayersX,ilayer::Integer,::Type{par_con})
    @unpack vd_pomh,vd_pomo,vd_mom = par 
    @unpack Yg, Vg, Vm, Q10 = par
    @unpack layer1,layer2,layer3,layer4,layer5 = sl
    nlayers = 5
    par.vd_pomh = vd_pomh
    par.vd_pomo = vd_pomo
    par.vd_mom  = vd_mom
    par.Yg      = Yg
    
    return nothing
end

function VaryTraitsDepth!(par::SoilPar,sl::SoilLayersX,ilayer::Integer,::Type{par_inc})
    @unpack vd_pomh,vd_pomo,vd_mom = par 
    @unpack Yg, Vg, Vm, Q10 = par
    @unpack layer1,layer2,layer3,layer4,layer5 = sl
    nlayers = 5
    if ilayer==1
        par.vd_pomh = vd_pomh * (100.0+layer1[1])/100.0  # assume a linear decrease with depth  
        par.vd_pomo = par.vd_pomh
        par.vd_mom = 0.01 * par.vd_pomh

        par.Yg = Yg * (100.0+layer1[1])/100.0
    elseif ilayer==2
        par.vd_pomh = vd_pomh * (100.0+layer2[1])/100.0
        par.vd_pomo = par.vd_pomh
        par.vd_mom = 0.01 * par.vd_pomh

        par.Yg = Yg * (100.0+layer2[1])/100.0
    elseif ilayer==3
        par.vd_pomh = vd_pomh * (100.0+layer3[1])/100.0
        par.vd_pomo = par.vd_pomh
        par.vd_mom = 0.01 * par.vd_pomh

        par.Yg = Yg * (100.0+layer3[1])/100.0
    elseif ilayer==4
        par.vd_pomh = vd_pomh * (100.0+layer4[1])/100.0
        par.vd_pomo = par.vd_pomh
        par.vd_mom = 0.01 * par.vd_pomh

        par.Yg = Yg * (100.0+layer4[1])/100.0
    elseif ilayer==5
        par.vd_pomh = vd_pomh * (100.0+layer5[1])/100.0
        par.vd_pomo = par.vd_pomh
        par.vd_mom = 0.01 * par.vd_pomh

        par.Yg = Yg * (100.0+layer5[1])/100.0
    else
        par.vd_pomh = vd_pomh
        par.vd_pomo = vd_pomo
        par.vd_mom  = vd_mom
        par.Yg      = Yg
    end
    return nothing
end