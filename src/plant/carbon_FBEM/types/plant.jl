mutable struct Plant{FT}
	gpp::FT
	inputC2Soil::Vector{FT}
	canopy::Canopy
	leaf::Leaf
end
