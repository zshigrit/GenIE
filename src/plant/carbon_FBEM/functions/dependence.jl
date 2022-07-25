FT = Float64;
const Rgas = FT(8.314)

function Arrhenius(
    Ea::FT,
    Rgas::FT,
    Tk::FT
) where {FT<:AbstractFloat}
    return exp((Ea/(Rgas*Tk)*(Tk/FT(298.15)-FT(1.))))
end

#
function leaf_temperature_dependence!(
    leaf::Leaf{FT},
    Tk::FT   
) where {FT<:AbstractFloat}
leaf.Vm = leaf.Vm25 * Arrhenius(leaf.Ea_Vm, Rgas, Tk);
leaf.Γ_star = leaf.Γ_star25 * Arrhenius(leaf.Ea_Γ, Rgas, Tk);
leaf.Kc = leaf.Kc25 * Arrhenius(leaf.Ea_Kc, Rgas, Tk);
leaf.Ko = leaf.Ko25 * Arrhenius(leaf.Ea_Ko, Rgas, Tk);
leaf.Jm = leaf.r_JmVm * leaf.Vm
return nothing

end