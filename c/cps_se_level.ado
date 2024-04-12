version 18
cap program drop cps_se_level
program define cps_se_level, rclass
	args level population_tot_civ_noninst alpha beta
	tempname x N se_mata se_stata

	mata: `x' = st_matrix("`level'") // Create mata matrix with level estimate
	mata: `N' = st_matrix("`population_tot_civ_noninst'") // Create mata matrix with the total civilian noninstitutional population 16 years and over
	mata: `se_mata' = sqrt((`alpha' :+ (`beta' :* `N')) :* (`x' :- ((`x':^2) :/ (`N')))) // Apply CPS formula for standard errors of estimated levels. Colon operators perform element-by-element operations.
	mata: st_matrix("`se_stata'", `se_mata') // Create stata matrix with standard errors

	return matrix se_cps `se_stata'
end
