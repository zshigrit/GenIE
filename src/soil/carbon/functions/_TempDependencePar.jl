# parameters for temperature dependence 
function ParTemp!(par::SoilPar,T::Float64)
    @unpack vd_pomh,vd_pomo,vd_mom = par 
    @unpack Yg, Vg, Vm, Q10 = par
    Tref = 20.0
    fTQ10 = Q10^((T-Tref)/10.0)

    par.vd_pomh = vd_pomh*fTQ10
    par.vd_pomo = vd_pomo*fTQ10
    par.vd_mom  = vd_mom*fTQ10
    par.Yg      = Yg*fTQ10
    
    return nothing
end
# function fTQ10(T, Q10, Tref=20.0)
#     fTQ10 = Q10^((T-Tref)/10.0)
# end
