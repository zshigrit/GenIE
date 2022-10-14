mutable struct Soil
	par::SoilPar
	par_add::AddPar
	par_der::DerPar
	pH::Float64 
	vG::vanGenuchtenPar
	OC::Pools
	ON::Pools
	rCN::Pools
	MN::MNPools
	enzymes_c::Enzyme_N
	enzymes_n::Enzyme_N
	CFlux::Fluxes
	NFlux::Fluxes
	Nuptake::Float64
end
