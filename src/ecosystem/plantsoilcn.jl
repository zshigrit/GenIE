"""
note for ` biome,som = "MGC","SOL" `
"""
const biome,som = "MGC","SOL"; 
const umol2mgC = 1.2*3.6*10^-3; #umolm-2s-1 to mgC/cm2/h
function plantsoilcn!(
	par_base::SoilPar,
	soil::Soil,
	plant::Plant,
	weather::Weather,
	lai::Vector,
	iday::Int
)
	leaf_temperature_dependence!(plant.leaf, weather.TaK)
	nitrogen_limitation!(plant.leaf, plant.canopy, soil.Nuptake, lai, iday)
    canopy_photosynthesis!(plant.leaf, plant.canopy, weather)
    
    plant.gpp = plant.canopy.Ac * umol2mgC; # converted to mgC/cm2/h
	gpp2soil!(plant,soil)

	# par_base = deepcopy(soil.par);
	inputC2Soil = plant.inputC2Soil;
	gpp = plant.gpp;
	swc = weather.swc;
	tmp = weather.Ts;
	pH = soil.pH; 

	soil.par = deepcopy(par_base);
	TMPdep!(soil.par,tmp)
	SWCdep!(par_base,soil.par,swc,soil.vG,biome,som)
	PHdep!(soil.par,pH)
	
	inp_cpools, inp_npools = deepcopy(soil.OC),deepcopy(soil.ON);
	inp_rCN, inp_mnpools = deepcopy(soil.rCN),deepcopy(soil.MN);
	inp_enzymes_c, inp_enzymes_n = deepcopy(soil.enzymes_c),deepcopy(soil.enzymes_n);

	CPools!(soil.par,soil.OC,inp_cpools,soil.CFlux,inputC2Soil)
	NPools!(soil,soil.par,soil.par_add,soil.par_der,soil.vG,soil.OC,soil.ON,soil.rCN,
		soil.MN,soil.CFlux,soil.enzymes_n,soil.enzymes_c,inputC2Soil,
		inp_cpools,inp_npools,inp_rCN,inp_mnpools,inp_enzymes_c,inp_enzymes_n,
		gpp,swc,tmp)
	soil.rCN=Rcn(soil.OC,soil.ON)

end
