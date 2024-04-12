version 18
cap program drop cps_se_level
program define cps_se_level, rclass
	args x N alpha beta
	tempname se
	scalar `se' = sqrt((`alpha' + (`beta' * `N')) * (`x' - ((`x'^2) / (`N'))))
	return scalar `se'
end
