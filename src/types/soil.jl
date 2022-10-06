mutable struct Soil{FT}
	par::SoilPar
	par_add::AddPar
	par_der::DerPar
	pH::FT
	vG::vanGenuchtenPar
	OC::Pools
	ON::Pools
	rCN::Pools
	MN::MNPools
	enzymes_c::Enzyme_N
	enzymes_n::Enzyme_N
	CFlux::Fluxes
	NFlux::Fluxes
end
