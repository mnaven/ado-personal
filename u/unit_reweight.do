cap program drop unit_reweight

program define unit_reweight
	version 15.1
	
	set prefix bootstrap
	
	_on_colon_parse `0'
	local unit_varlist = "`s(before)'"
	local command = "`s(after)'"
	
	tempvar unit
	local num_unit_vars : word count `unit_varlist'
	if `num_unit_vars' > 1 {
		egen `unit' = group(`unit_varlist')
	}
	else if `num_unit_vars'==1 {
		gen `unit' = `unit_varlist'
	}
	
	_prefix_command unit_reweight, norest checkcluster checkvce : `command'
	local command_version = "`s(version)'"
	local command_cmdname = "`s(cmdname)'"
	local command_anything = "`s(anything)'"
	local command_wtype = "`s(wtype)'"
	local command_wexp = "`s(wexp)'"
	local command_wgt = "`s(wgt)'"
	local command_if = "`s(if)'"
	local command_in = "`s(in)'"
	local command_rest = "`s(rest)'"
	local command_efopt = "`s(efopt)'"
	local command_eform = "`s(eform)'"
	local command_level = "`s(level)'"
	local command_cluster = "`s(cluster)'"
	local command_options = "`s(options)'"
	local command_vce = "`s(vce)'"
	local command_command = "`s(command)'"
	tempvar touse
	mark `touse' `command_if' `command_in'
	markout `touse' `command_anything' `command_cluster'
	
	tempvar unit_obs
	egen `unit_obs' = total(`touse'), by(`unit')
	
	if "`command_options'"!="" {
		`command_cmdname' `command_anything' `command_if' `command_in' [aw = 1 / `unit_obs'], `command_options'
	}
	else {
		`command_cmdname' `command_anything' `command_if' `command_in' [aw = 1 / `unit_obs']
	}
end
