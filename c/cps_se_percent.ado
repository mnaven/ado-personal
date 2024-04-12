version 18
cap program drop cps_se_percent
program define cps_se_percent, rclass
	args percentage denominator critical_value alpha beta
	tempname p y cv se_mata se_stata ll_mata ll_stata ul_mata ul_stata

	mata: `p' = st_matrix("`percentage'") // Create mata matrix with percentage estimate
	mata: `y' = st_matrix("`denominator'") // Create mata matrix with the number of persons in the percentage's base or denominator
	mata: `se_mata' = sqrt(((`alpha' :+ (`beta' :* `y')) :/ (`y')) :* `p' :* (100 :- `p')) // Apply CPS formula for standard errors of estimated rates, ratios, and percentages. Colon operators perform element-by-element operations.
	mata: st_matrix("`se_stata'", `se_mata') // Create stata matrix with standard errors
	mata: `cv' = st_matrix("`critical_value'") // Create mata matrix with the critical value
	mata: `ll_mata' = `p' - (`cv' :* `se_mata')
	mata: st_matrix("`ll_stata'", `ll_mata')
	mata: `ul_mata' = `p' + (`cv' :* `se_mata')
	mata: st_matrix("`ul_stata'", `ul_mata')

	return matrix se_cps `se_stata'
	return matrix ll_cps `ll_stata'
	return matrix ul_cps `ul_stata'
end
