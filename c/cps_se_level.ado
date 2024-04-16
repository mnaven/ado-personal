version 18
cap program drop cps_se_level
program define cps_se_level, rclass
	args level population_tot_civ_noninst alpha beta critical_value

	mata: cps_se_level(st_matrix("`level'"), st_matrix("`population_tot_civ_noninst'"), `alpha', `beta', st_matrix("`critical_value'")) // Apply CPS formula for standard errors of estimated levels
	
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
