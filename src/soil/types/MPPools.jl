Base.@kwdef mutable struct MPPools{FT<:AbstractFloat}
    "Inorganic P: PO4, HXPO4"
	POx::FT = 0.0
	"Occluded P"
    Po::FT = 0.0
	"Sorbed P"
    Ps::FT = 0.0
    "Secondary mineral or strongly sorbed P"
    Pss::FT = 0.0
	"Parent Material P"
    Ppm::FT = 0.0
end
