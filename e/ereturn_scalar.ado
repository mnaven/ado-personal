cap program drop ereturn_scalar

program def ereturn_scalar, eclass
	syntax name = exp
	ereturn scalar `namelist' `exp'
end
