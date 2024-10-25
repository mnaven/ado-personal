cap program drop smcl2pdf_settings
program define smcl2pdf_settings
	version 18.0
	
	syntax , [orientation(string) pagewidth(real) pageheight(real) lmargin(real 0.4) rmargin(real 0.4) tmargin(real 0.4) bmargin(real 0.4) linesize(real) fontsize(real 8) scheme(string)]
	
	if "`orientation'"=="" local orientation "portrait" // Default orientation option
	if "`scheme'"=="" local scheme "color" // Default scheme option
	
	assert inlist("`orientation'", "portrait", "landscape")
	if "`orientation'"=="portrait" { // If portrait orientation
		if "`pagewidth'"=="" local pagewidth 8.5 // Default portrait page width (legal paper size)
		if "`pageheight'"=="" local pageheight 14.0 // Default portrait page height (legal paper size)
		if "`lmargin'"=="" local lmargin 0.4 // Default portrait left margin
		if "`rmargin'"=="" local rmargin 0.4 // Default portrait right margin
		if "`tmargin'"=="" local tmargin 0.4 // Default portrait top margin
		if "`bmargin'"=="" local bmargin 0.4 // Default portrait bottom margin
		if "`linesize'"=="" local linesize 120 // Default portrait line size
	}
	else if "`orientation'"=="landscape" { // If landscape orientation
		if "`pagewidth'"=="" local pagewidth 14.0 // Default landscape page width (legal paper size)
		if "`pageheight'"=="" local pageheight 8.5 // Default landscape page height (legal paper size)
		if "`lmargin'"=="" local lmargin 0.4 // Default landscape left margin
		if "`rmargin'"=="" local rmargin 0.4 // Default landscape right margin
		if "`tmargin'"=="" local tmargin 0.4 // Default landscape top margin
		if "`bmargin'"=="" local bmargin 0.4 // Default landscape bottom margin
		if "`linesize'"=="" local linesize 200 // Default landscape line size
	}
	
	translator set smcl2pdf pagesize custom
	translator set smcl2pdf pagewidth `pagewidth'
	translator set smcl2pdf pageheight `pageheight'
	translator set smcl2pdf lmargin `lmargin'
	translator set smcl2pdf rmargin `rmargin'
	translator set smcl2pdf tmargin `tmargin'
	translator set smcl2pdf bmargin `bmargin'
	translator set smcl2pdf fontsize `fontsize'
	translator set smcl2pdf scheme `scheme'
	set linesize `linesize'
end
