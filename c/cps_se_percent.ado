version 18
cap program drop cps_se_percent
program define cps_se_percent, rclass
	args percentage denominator alpha beta
	tempname p y se_mata se_stata

	mata: `p' = st_matrix("`percentage'") // Create mata matrix with percentage estimate
	mata: `y' = st_matrix("`denominator'") // Create mata matrix with the number of persons in the percentage's base or denominator
	mata: `se_mata' = sqrt(((`alpha' :+ (`beta' :* `y')) :/ (`y')) :* `p' :* (100 :- `p')) // Apply CPS formula for standard errors of estimated rates, ratios, and percentages. Colon operators perform element-by-element operations.
	mata: st_matrix("`se_stata'", `se_mata') // Create stata matrix with standard errors

	return matrix se_cps `se_stata'
end
