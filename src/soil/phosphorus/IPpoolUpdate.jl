function solvequadratic(a, b, c)
    d = sqrt(b^2 - 4a*c)
    return (-b + d) / 2a
end
"""
phosphorus in soil solution 
unit is gP/m2 
Ps: sorbed Phosphorus or labile pool in Yang et al. 2014
POx: mineral P in soil solution
Smax: maximal amount of sorbed P
Ks: MM empirical constant
"""
function POxPs2(
    ppar::IPPar,ip::MPPools,
)
    @unpack rwea,rl,Smax,Ks,rad = ppar
    @unpack Ppm,POx,Ps = ip    
    
    scalar1 = 1.0/(1.0+ Smax*Ks/((POx+Ks)^2))
    scalar2 = Smax*Ks/((POx+Ks)^2+Smax*Ks)
    Fw = rwea * Ppm
    Fl = rl*POx
    ΔPOx = scalar1*(Fw-Fl-rad*Ps) # Yang 2014 equ15
    ΔPs  = scalar2*(Fw-Fl-rad*Ps) # Yang 2014 equ16
    # ΔPOx = scalar1*(Fw+Fd+Fbiochem-Fl-rad*Ps) # Yang 2014 equ15
    # ΔPs  = scalar2*(Fw+Fd+Fbiochem-Fl-rad*Ps) # Yang 2014 equ16

    POx = POx + ΔPOx
    Ps  = Ps  + ΔPs

    if POx <= 0.0; println("POx<=0");end
    if Ps <= 0.0; println("Ps<=0");end
    return ΔPOx,ΔPs
end


function POxPs!(
    ppar::IPPar,ip::MPPools
)
    @unpack rwea,rl,Smax,Ks,rad = ppar
    @unpack Ppm,POx,Ps = ip    
    
    Fw = rwea * Ppm
    Fl = rl*POx
    ΔPOx = Fw-Fl # Yang 2014 equ15
    ΔPs  = -rad*Ps # Yang 2014 equ16
    # ΔPOx = scalar1*(Fw+Fd+Fbiochem-Fl-rad*Ps) # Yang 2014 equ15
    # ΔPs  = scalar2*(Fw+Fd+Fbiochem-Fl-rad*Ps) # Yang 2014 equ16
    ip.POx = POx + ΔPOx
    ip.Ps  = Ps + ΔPs
    return nothing
end

""" solution phosphorus sorbed by minerals equilibrium with solution P; 
unit is gP/m2 
Ps: sorbed Phosphorus or labile pool in Yang et al. 2014
POx: mineral P in soil solution
Smax: maximal amount of sorbed P
Ks: MM empirical constant
"""
function EquilPOxPs!(
   ppar::IPPar,ip::MPPools
)
   @unpack Smax,Ks = ppar
   @unpack POx,Ps = ip
   
   total = Ps + POx
   a,b,c = 1.0,Smax+Ks-total,-total*Ks
   ip.POx = solvequadratic(a,b,c)
   ip.Ps  = total - ip.POx
   if ip.POx <= 0.0; println("POx<=0");end
   if ip.Ps <= 0.0; println("Ps<=0");end

   return nothing

end 


"""
strongly-sorbed or secondary mineral phosphorus changes
"""
function secondaryIP(
    ppar::IPPar,ip::MPPools
)
    @unpack Pss,Ps = ip
    @unpack rad,rdes,rocl = ppar

    ΔPss = rad*Ps - rdes*Pss - rocl*Pss
#    ip.Pss = Pss + ΔPss
    
    if Pss+ΔPss <= 0.0; println("Pss<=0");end

    return ΔPss
end


"""
occlusion of phosphorus
"""
function occludedIP(
    ppar::IPPar,ip::MPPools
)
    @unpack Pss,Po = ip
    @unpack rocl = ppar

    ΔPo = rocl*Pss
#    ip.Po = Po+ΔPo

    return ΔPo
end


"""
weathering of phosphorus
"""
function weatherIP(
    ppar::IPPar,ip::MPPools
)
    @unpack Ppm = ip
    @unpack rwea = ppar

    ΔPpm = rwea*Ppm
    #ip.Ppm = Ppm - ΔPpm

    return ΔPpm
end

"""
IP pool uptake
"""
function IPpoolUpdate2!(
    ip::MPPools,ppar::IPPar
    #Fd,Fm,Fbiochem,Fuptake # Fm (mineralization) and Fuptake (immobilization by vegetation) have been added in organic P processes
    )

    ΔPo  = occludedIP(ppar,ip)
    ΔPpm =  weatherIP(ppar,ip)
    ΔPss = secondaryIP(ppar,ip)
    ΔPOx,ΔPs = POxPs2(ppar,ip)
    ip.Po = ip.Po + ΔPo
    ip.Pss = ip.Pss + ΔPss
    ip.Ppm = ip.Ppm + ΔPpm
    ip.POx = ip.POx + ΔPOx
    ip.Ps  = ip.Ps + ΔPs
end

function IPpoolUpdate!(
    ip::MPPools,ppar::IPPar
    #Fd,Fm,Fbiochem,Fuptake # Fm (mineralization) and Fuptake (immobilization by vegetation) have been added in organic P processes
    )
    EquilPOxPs!(ppar,ip)
    ΔPo  = occludedIP(ppar,ip)
    ΔPpm =  weatherIP(ppar,ip)
    ΔPss = secondaryIP(ppar,ip)
    POxPs!(ppar,ip)
    ip.Po = ip.Po + ΔPo
    ip.Pss = ip.Pss + ΔPss
    ip.Ppm = ip.Ppm + ΔPpm
end