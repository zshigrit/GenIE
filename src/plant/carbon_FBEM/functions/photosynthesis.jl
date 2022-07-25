function canopy_photosynthesis!(
    leaf::Leaf{FT},
    can::Canopy{FT},
    weather::Weather    
) where {FT<:AbstractFloat}

@unpack Vm, Ci, Cs, Γ_star, Kc, Oi, Ko, α_q, Jm = leaf; 
@unpack g1, D0, Gs, kn, lai, Reco0, Q10, a1 = can;
@unpack I, D, swc, TaK = weather;  

# leaf photosynthesis
Jc = Vm*(Ci-Γ_star)/(Ci+Kc*(FT(1)+Oi/Ko));
Je = (α_q*I*Jm/(sqrt(Jm^FT(2)+α_q^FT(2)*I^FT(2)))) * 
    ((Ci-Γ_star)/(FT(4)*(Ci+FT(2)*Γ_star))); # Li (qianyu) 2016 equation 8
Al = min(Jc,Je); # leaf photosynthesis

Gs = g1*Al/((Cs-Γ_star)*(FT(1)+D/D0)); # canopy stomatal conductance
An = Gs*(Cs-Ci); # top layer canopy photosynthesis 
Ac = An * (FT(1)-exp(-kn*lai))/kn; # canopy photosynthesis 

_Ta = TaK - FT(273.15);
Reco = Reco0*Q10^(_Ta/FT(10))*(swc/(swc+a1));
NEE = Reco - Ac; 

can.Ac = Ac; 
can.Reco = Reco;
can.NEE = NEE;

return nothing 

end