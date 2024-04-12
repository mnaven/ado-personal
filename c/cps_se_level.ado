version 18
cap program drop cps_se_level
program define cps_se_level, rclass
	args level population_tot_civ_noninst critical_value alpha beta
	tempname x N cv se_mata se_stata ll_mata ll_stata ul_mata ul_stata

	mata: `x' = st_matrix("`level'") // Create mata matrix with level estimate
	mata: `N' = st_matrix("`population_tot_civ_noninst'") // Create mata matrix with the total civilian noninstitutional population 16 years and over
	mata: `se_mata' = sqrt((`alpha' :+ (`beta' :* `N')) :* (`x' :- ((`x':^2) :/ (`N')))) // Apply CPS formula for standard errors of estimated levels. Colon operators perform element-by-element operations.
	mata: st_matrix("`se_stata'", `se_mata') // Create stata matrix with standard errors
	mata: `cv' = st_matrix("`critical_value'") // Create mata matrix with the critical value
	mata: `ll_mata' = `x' - (`cv' :* `se_mata')
	mata: st_matrix("`ll_stata'", `ll_mata')
	mata: `ul_mata' = `x' + (`cv' :* `se_mata')
	mata: st_matrix("`ul_stata'", `ul_mata')

	return matrix se_cps `se_stata'
	return matrix ll_cps `ll_stata'
	return matrix ul_cps `ul_stata'
end
