function nitrogen_allocation!(
    leaf::Leaf{FT},
    can::Canopy{FT},
    _lai::DataFrame,
    iday::Int
) where {FT<:AbstractFloat}
    @unpack sla, rCN0 = leaf; 
    gpp = can.An; 
    ΔLAI = _lai[iday] - _lai[iday-1]
    if ΔLAI > FT(0)
        nitrogen_demand = ΔLAI/sla * 0.45 /rCN0;

        (ΔLAI/sla * 0.45)/(gpp*0.5) < FT(1) ? 
        nitrogen_supply = nitrogen_uptake*((ΔLAI/sla * 0.45)/(gpp*0.5)) :  # 0.45: convert biomass to carbon; 0.5: convert gpp to NPP; 
        nitrogen_supply = nitrogen_uptake;

        nitrogen_demand < nitrogen_supply ?
        Δnitrogen = nitrogen_demand :
        Δnitrogen = nitrogen_supply;

        leaf.bm_n = leaf.bm_n + Δnitrogen;
    else
        Δnitrogen = ΔLAI/sla * 0.45/leaf.rCN;
        leaf.bm_n = leaf.bm_n + Δnitrogen;

    return nothing 

end