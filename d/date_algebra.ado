cap program drop date_algebra

program define date_algebra, nclass
	args date_old days months years round
	
	confirm variable `date_old'
	confirm integer number `days'
	confirm integer number `months'
	confirm integer number `years'
	
	tempvar date_new
	gen `date_new' = `date_old'
	
	* Add days
	replace `date_new' = `date_new' + `days'
	
	* Add months
	replace `date_new' = mdy( ///
		cond(mod(month(`date_new') + `months', 12)==0, 12, mod(month(`date_new') + `months', 12), .), ///
		day(`date_new'), ///
		year(`date_new') + cond(mod(month(`date_new') + `months', 12)==0, floor((month(`date_new') + `months') / 12) - 1, floor((month(`date_new') + `months') / 12), .) ///
		)
	
	if "`round'"=="back" {
		* Subtract days until a valid date
		forvalues subtract_days = 1 (1) 3 {
			replace `date_new' = mdy( ///
				cond(mod(month(`date_old' + `days' - `subtract_days') + `months', 12)==0, 12, mod(month(`date_old' + `days' - `subtract_days') + `months', 12), .), ///
				day(`date_old' + `days' - `subtract_days'), ///
				year(`date_old' + `days' - `subtract_days') + cond(mod(month(`date_old' + `days' - `subtract_days') + `months', 12)==0, floor((month(`date_old' + `days' - `subtract_days') + `months') / 12) - 1, floor((month(`date_old' + `days' - `subtract_days') + `months') / 12), .) ///
				) ///
				if mi(`date_new') & !mi(`date_old')
		}
	}
	
	if "`round'"=="forward" {
		* Add days until a valid date
		forvalues add_days = 1 (1) 3 {
			replace `date_new' = mdy( ///
				cond(mod(month(`date_old' + `days' + `add_days') + `months', 12)==0, 12, mod(month(`date_old' + `days' + `add_days') + `months', 12), .), ///
				day(`date_old' + `days' + `add_days'), ///
				year(`date_old' + `days' + `add_days') + cond(mod(month(`date_old' + `days' + `add_days') + `months', 12)==0, floor((month(`date_old' + `days' + `add_days') + `months') / 12) - 1, floor((month(`date_old' + `days' + `add_days') + `months') / 12), .) ///
				) ///
				if mi(`date_new') & !mi(`date_old')
		}
	}
	
	* Add years
	replace `date_new' = mdy(month(`date_new'), day(`date_new'), year(`date_new') + `years')
end
