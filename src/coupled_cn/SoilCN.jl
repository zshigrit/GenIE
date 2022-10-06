"""
couple carbon and nitrogen and then exported in Soil.jl for ecosystem process use
note for ` biome,som = "MGC","SOL" `
"""
const biome,som = "MGC","SOL"; 
function soilcn!(
	soil::Soil,
	plant::Plant,
	weather::Weather
)
	par_base = deepcopy(soil.par);
	inputC2Soil = plant.inputC2Soil;
	gpp = plant.gpp;
	swc = weather.swc;
	tmp = weather.tmp;
	pH = soil.pH;

	TMPdep!(soil.par,tmp)
	SWCdep!(par_base,soil.par,swc,soil.vG,biome,som)
	PHdep!(soil.par,pH)
	
	inp_cpools, inp_npools = deepcopy(soil.OC),deepcopy(soil.ON);
	inp_rCN, inp_mnpools = deepcopy(soil.rCN),deepcopy(soil.MN);
	inp_enzymes_c, inp_enzymes_n = deepcopy(soil.enzymes_c),deepcopy(soil.enzymes_n);

	CPools!(soil.par,soil.OC,inp_cpools,soil.CFlux,inputC2Soil)
	NPools!(soil.par,soil.par_add,soil_par.der,soil.vG,soil.OC,soil.ON,soil.rCN,
		soil.MN,soil.CFlux,soil.enzymes_n,soil.enzymes_c,inputC2Soil,
		inp_cpools,inp_npools,inp_rCN,inp_mnpools,inp_enzymes_c,inp_enzyme_n)
	rCN=Rcn(soil.OC,soi.ON)

end
