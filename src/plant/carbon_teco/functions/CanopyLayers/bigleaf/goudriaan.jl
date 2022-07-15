"""
big leaf radiative transfer (per unit leaf area)

absorbed vis by sunlit (q1) and shaded leaves (q2)
Ib0, Id0: beam and diffuse radiation above the canopy
"""
function goudriann!(
    leaf::BigLeaf{FT}
)
    vis = leaf.vis;
    @unpack q1, q2, Ib0, Id0 = vis;  
    @unpack kb,kb_star,kd_star,ρtd, ξ, ρtb, ωf = leaf; 

    q2 = (Id0*kd_star*(FT(1.0)-ρtd)*exp(-kd_star*ξ)
    + Ib0*(
    kb_star*(FT(1.0)-ρtb)*exp(-kb_star*ξ)
    - kb*(FT(1.0)-ωf)*exp(-kb*ξ)
    )
    );

    q1 = q2 + Ib0*kb*(FT(1.0)-ωf);

    leaf.vis.q1apar = q1 * FT(4.6); # Convert W/m2 to umol (leafm-2) s-1 
    leaf.vis.q2apar = q2 * FT(4.6); # Convert W/m2 to umol (leafm-2) s-1 

    return nothing 

end