"""
C3 photosynthesis coupled with Leuning stomatal conductance
will add C4 photosynthesis 
note1: g1 will be modified by fwsoil 
"""

function rubisco_limited_rate!(
    leaf::Leaf{FT}
    ) where {FT<:AbstractFloat}
    @unpack g0, g1, Γ_star, D0, Vcmax, J = leaf;
    @unpack Kc, Oi, Ko, Rd, Ci, Cs, Ds = leaf; 

    _a, _b = Vcmax, Kc*(FT(1.0)+Oi/Ko); 
    v = g1 / (FT(1.6)*(Cs-Γ_star)*(FT(1.0)+Ds/D0)); # g1 * fwsoil

    a = g0/FT(1.6) + v * (_a - Rd);
    b = (
        (FT(1.0)-v*Cs) * (_a-Rd) + g0/FT(1.6)*(_b-Cs) 
        - v*(_a*Γ_star+_b*Rd)
        );
    c = (v*Cs-FT(1.0)) * (_a*Γ_star+_b*Rd) - _b*Cs*g0/FT(1.6);

    if b^FT(2.0)-FT(4.0)*a*c > FT(0)
        leaf.Ci = (-b+sqrt(b^FT(2.0)-FT(4.0)*a*c))/(FT(2.0)*a)
    end
    if leaf.Ci<FT(0) || b^FT(2.0)-FT(4.0)*a*c < FT(0)
        leaf.Ac = FT(0)
        leaf.Ci = FT(0.7)*Cs 
    else
        leaf.Ac = _a*(leaf.Ci-Γ_star)/(leaf.Ci+_b) )
    end

    return nothing
end



function light_limited_rate!(
    leaf::Leaf{FT}
    ) where {FT<:AbstractFloat}
    @unpack g0, g1, Γ_star, D0, Vcmax, J = leaf;
    @unpack Kc, Oi, Ko, Rd, Cs, Ds = leaf; 

    _a, _b = J/FT(4.0), 2*Γ_star;
    v = g1 / (FT(1.6)*(Cs-Γ_star)*(FT(1.0)+Ds/D0));

    a = g0/FT(1.6) + v * (_a - Rd);
    b = (
        (FT(1.0)-v*Cs) * (_a-Rd) + g0/FT(1.6)*(_b-Cs) 
        - v*(_a*Γ_star+_b*Rd)
        );
    c = (v*Cs-FT(1.0)) * (_a*Γ_star+_b*Rd) - _b*Cs*g0/FT(1.6);

    if b^FT(2.0)-FT(4.0)*a*c > FT(0)
        leaf.Ci = (-b+sqrt(b^FT(2.0)-FT(4.0)*a*c))/(FT(2.0)*a)
    end
    if leaf.Ci<FT(0) || b^FT(2.0)-FT(4.0)*a*c < FT(0)
        leaf.Aj = FT(0)
        leaf.Ci = FT(0.7)*Cs 
    else
        leaf.Aj = _a*(leaf.Ci-Γ_star)/(leaf.Ci+_b) )
    end

    return nothing
end

function leaf_photosynthesis(
    leaf::Leaf{FT}
    ) where {FT<:AbstractFloat}

    rubisco_limited_rate!(leaf);
    light_limited_rate!(leaf);
    leaf.Ag = min(leaf.Ac, leaf.Aj);
    leaf.An = leaf.Ag - leaf.Rd;
    return nothing
end