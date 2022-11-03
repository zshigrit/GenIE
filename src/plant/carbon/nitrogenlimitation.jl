###############################################################################
#
# nitrogen limitation on Vcmax25 
#
###############################################################################
function nitrogen_allocation!(
    leaf::Leaf{FT},
    can::Canopy{FT},
    nitrogen_uptake::FT,
    lai::Vector,
    iday::Int
) where {FT<:AbstractFloat}
    @unpack sla, rCN0 = leaf; 
    _gpp = can.Ac*(10^-6*12*3600);# convert umol m-2 s-1 to g m-2 h-1 

    iday>1 ? ΔLAI = lai[iday] - lai[iday-1] : ΔLAI = FT(0);
    if ΔLAI ≥ FT(0)
        nitrogen_demand = ΔLAI/sla * FT(0.45)/FT(24)/rCN0;

        (ΔLAI/sla * FT(0.45)/FT(24))/(_gpp*FT(0.5)) < FT(1) ? 
        nitrogen_supply = nitrogen_uptake*((ΔLAI/sla * 0.45/FT(24))/(_gpp*0.5)) :  # 0.45: convert biomass to carbon; 0.5: convert gpp to NPP; 
        nitrogen_supply = nitrogen_uptake;

        nitrogen_demand < nitrogen_supply ?
        Δnitrogen = nitrogen_demand :
        Δnitrogen = nitrogen_supply;

        leaf.bm_n = leaf.bm_n + Δnitrogen;
    else
        Δnitrogen = ΔLAI/sla * FT(0.45)/FT(24)/leaf.rCN;
        leaf.bm_n = leaf.bm_n + Δnitrogen;
    end

    # _lai.LAI[iday]>FT(0) ? leaf.bm_c = _lai.LAI[iday]/sla * FT(0.45) : leaf.bm_c = FT(0) ;
    leaf.bm_c = leaf.bm_c + ΔLAI/sla * FT(0.45)/FT(24);
    return nothing 

end

function nitrogen_limitation!(
    leaf::Leaf{FT}
) where {FT<:AbstractFloat}
    @unpack Ncb0, rCN0, NUEᵥₘ₂₅ = leaf;
    leaf.Ncb = Ncb0 * (rCN0/leaf.rCN);
    leaf.Vm25 = leaf.Ncb * NUEᵥₘ₂₅;
    return nothing 
end


# function nitrogen_limitation!(
#     leaf::Leaf{FT},
#     can::Canopy{FT},
#     nitrogen_uptake::FT,
#     lai::Vector,
#     iday::Int
# ) where {FT<:AbstractFloat}
#     @unpack Ncb0, rCN0, NUEᵥₘ₂₅ = leaf;
#     # nitrogen_uptake = nitrogen_uptake *1.0e3; # converting mgN/cm3/h to gN/m3/h
#     # nitrogen_allocation!(leaf,can,nitrogen_uptake,lai,iday)
#     if leaf.bm_n >0  
#         leaf.rCN = leaf.bm_c/leaf.bm_n 
#     else
#          leaf.rCN=leaf.rCN0; 
#     end
# #    if leaf.rCN > leaf.rCNmax 
# #        leaf.rCN = leaf.rCNmax
# #    end
# #    if leaf.rCN < leaf.rCNmin 
# #        leaf.rCN = leaf.rCNmin 
# #    end

#     leaf.Ncb = Ncb0 * (rCN0/leaf.rCN);
#     leaf.Vm25 = leaf.Ncb * NUEᵥₘ₂₅;
#     return nothing 
# end