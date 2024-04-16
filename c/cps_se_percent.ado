version 18
cap program drop cps_se_percent
program define cps_se_percent, rclass
	args percentage percent_or_proportion denominator alpha beta critical_value
	tempname p y cv se_mata se_stata ll_mata ll_stata ul_mata ul_stata

	mata: `p' = st_matrix("`percentage'") // Create mata matrix with percentage estimate
	mata: `y' = st_matrix("`denominator'") // Create mata matrix with the number of persons in the percentage's base or denominator
	mata: `se_mata' = cps_se_percent(`p', "`percent_or_proportion'", `y', `alpha', `beta') // Apply CPS formula for standard errors of estimated rates, ratios, and percentages
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

mata:
	real vector cps_se_percent(real vector p, string scalar percent_or_proportion, real vector y, real scalar alpha, real scalar beta)
	{
		if (percent_or_proportion=="proportion") { // If the percentage is a proportion instead of a percent
			p = p :* 100 // Multiply proportion by 100 to obtain percent
		}
		else {
			assert(percent_or_proportion=="percent")
		}
		assert(all(p:>=0) & all(p:<=100))
		
		real vector se
		se = sqrt(((alpha :+ (beta :* y)) :/ (y)) :* p :* (100 :- p)) // Apply CPS formula for standard errors of estimated rates, ratios, and percentages. Colon operators perform element-by-element operations.
		
		if (percent_or_proportion=="proportion") { // If the percentage is a proportion instead of a percent
			p = p :/ 100 // Divide percent by 100 to obtain proportion
			se = se :/ 100 // Divide percent by 100 to obtain proportion
		}
		
		return(se)
	}
end
