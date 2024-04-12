version 18
cap program drop cps_se_percent
program define cps_se_percent, rclass
	args p y alpha beta
	tempname se
	scalar `se' = sqrt(((`alpha' + (`beta' * `y')) / (`y')) * `p' * (100 - `p'))
	return scalar `se'
end
