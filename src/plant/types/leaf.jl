Base.@kwdef mutable struct Leaf{FT<:AbstractFloat}

    "vcmax@25° μmol m⁻² s⁻¹"
    # Vm25::FT = 100 

    # """
    # where N_{cb} is nitrogen for carboxylation (g N m-2 leaf, Table 2.10.1), 
    # and NUE_{V_{c\max 25}} = 47.3 x 6.25 and is the nitrogen use efficiency for V_{c\max 25}. 
    # The constant 47.3 is the specific Rubisco activity ( \mu mol CO2 g-1 Rubisco s-1) measured at 25oC, 
    # and the constant 6.25 is the nitrogen binding factor for Rubisco (g Rubisco g-1 N; Rogers 2014).
    # Ncb = 0.13; 
    # The photosynthetic nitrogen, N_{\text{psn}}, is further divided into nitrogen for light capture ( N_{\text{lc}}; gN/m 2 leaf), 
    # nitrogen for electron transport ( N_{\text{et}}; gN/m 2 leaf), and nitrogen for carboxylation ( N_{\text{cb}}; gN/m 2 leaf). Namely,
    # """
    
    Ncb0::FT = 0.13
    Ncb::FT = 0 # Ncb = Ncb0 * (rCN0/rCN)
    NUEᵥₘ₂₅::FT = 47.3 * 6.25 # 47.3 * 6.25
    Vm25::FT = Ncb0*NUEᵥₘ₂₅ # will be modified by Ncb 
    "leaf biomass (g); * 0.45 for carbon"
    bm::FT = 0 # lai / sla
    bm_c::FT = 0 # bm*0.45 leaf carbon 
    bm_n::FT = 0 # leaf nitrogen
    "initial leaf CN ratio"
    rCN0::FT = 30
    rCN::FT  = 30
    rCNmax::FT = 45
    rCNmin::FT = 10
    "specific leaf area m²/g"
    sla::FT = 0.0085 # from TECO 
    "vcmax: μmol m⁻² s⁻¹ (initially zero)"
    Vm::FT = 0
    "fraction of Ca to derive Ci"
    fCi::FT = 0.87
    "leaf surface CO2 (initially zero)"
    Cs::FT = 0 # initialized in initparameters.jl
    "inner leaf CO₂ concentration μmol/mol (ppm)"
    Ci::FT = 0.0 # fCi * Cs # initialized in initparameters.jl
    "CO₂ compensation point@25°"
    Γ_star25::FT = 42.5
    "CO₂ compensation point"
    Γ_star::FT = 0 # updated in dependence.jl
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