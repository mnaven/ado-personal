version 18
cap program drop cps_se_percent
program define cps_se_percent, rclass
	args percentage percent_or_proportion denominator alpha beta critical_value

	mata: cps_se_percent(st_matrix("`percentage'"), "`percent_or_proportion'", st_matrix("`denominator'"), `alpha', `beta', st_matrix("`critical_value'")) // Apply CPS formula for standard errors of estimated rates, ratios, and percentages
	
	return add
end

mata:
	void cps_se_percent(real vector p, string scalar percent_or_proportion, real vector y, real scalar alpha, real scalar beta, real vector cv)
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
		st_matrix("r(se_cps)", se)
		
		real vector ll
		ll = p - (cv :* se)
		st_matrix("r(ll_cps)", ll)
		
		real vector ul
		ul = p + (cv :* se)
		st_matrix("r(ul_cps)", ul)
	}
end
