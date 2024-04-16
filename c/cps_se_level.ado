version 18
cap program drop cps_se_level
program define cps_se_level, rclass
	args level population_tot_civ_noninst alpha beta critical_value
	tempname x N cv

	mata: `x' = st_matrix("`level'") // Create mata matrix with level estimate
	mata: `N' = st_matrix("`population_tot_civ_noninst'") // Create mata matrix with the total civilian noninstitutional population 16 years and over
	mata: `cv' = st_matrix("`critical_value'") // Create mata matrix with the critical value
	mata: cps_se_level(`x', `N', `alpha', `beta', `cv') // Apply CPS formula for standard errors of estimated levels
	
	return add
end

mata:
	void cps_se_level(real vector x, real vector N, real scalar alpha, real scalar beta, real vector cv)
	{
		real vector se
		se = sqrt((alpha :+ (beta :* N)) :* (x :- ((x:^2) :/ (N)))) // Apply CPS formula for standard errors of estimated levels. Colon operators perform element-by-element operations.
		st_matrix("r(se_cps)", se)
		
		real vector ll
		ll = x - (cv :* se)
		st_matrix("r(ll_cps)", ll)
		
		real vector ul
		ul = x + (cv :* se)
		st_matrix("r(ul_cps)", ul)
	}
end
