mutable struct Plant
	gpp::Float64  # its unit is mg/cm2/h converted from umol m-2 s-1 from canopy.Ac 
	gppsum::Float64 # for calculate leaf CN ratio = gppsum/Nuptakesum # unit already converted to gC/m2 
	inputC2Soil::Vector
	canopy::Canopy
	leaf::Leaf
	Nuptake::Float64
end
