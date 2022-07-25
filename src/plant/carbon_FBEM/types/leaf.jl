Base.@kwdef mutable struct Leaf{FT<:AbstractFloat}

    "vcmax@25° μmol m⁻² s⁻¹"
    Vm25::FT = 100 
    """
    where N_{cb} is nitrogen for carboxylation (g N m-2 leaf, Table 2.10.1), 
    and NUE_{V_{c\max 25}} = 47.3 x 6.25 and is the nitrogen use efficiency for V_{c\max 25}. 
    The constant 47.3 is the specific Rubisco activity ( \mu mol CO2 g-1 Rubisco s-1) measured at 25oC, 
    and the constant 6.25 is the nitrogen binding factor for Rubisco (g Rubisco g-1 N; Rogers 2014).
    """
    # Vm25 = Ncb*NUEᵥₘ₂₅ 
    "vcmax: μmol m⁻² s⁻¹ (initially zero)"
    Vm::FT = 0
    "fraction of Ca to derive Ci"
    fCi::FT = 0.87
    "leaf surface CO2 (initially zero)"
    Cs::FT = 0
    "inner leaf CO₂ concentration μmol/mol (ppm)"
    Ci::FT = fCi * Cs 
    "CO₂ compensation point@25°"
    Γ_star25::FT = 42.5
    "CO₂ compensation point"
    Γ_star::FT = 0
    "half saturation constant for CO₂"
    Kc25::FT = 460
    Kc::FT = 0
    "half saturation constant for O₂"
    Ko25::FT = 0.33 
    Ko::FT = 0 
    "inner leaf O₂"
    Oi::FT = 0.21
    "quantum yield efficiency"
    α_q::FT = 0.28
    "maximal electron transport rate"
    r_JmVm::FT = 1.79
    Jm::FT = 0 # r_JmVm * Vm

    "activation energy Ea for above parameters"
    Ea_Vm::FT = 58520
    Ea_Γ::FT = 60000
    Ea_Kc::FT = 100000
    Ea_Ko::FT = 35948
    
end 