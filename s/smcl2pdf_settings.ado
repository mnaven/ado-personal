cap program drop smcl2pdf_settings
program define smcl2pdf_settings
	version 17.0
	
	syntax [, fontsize(real 8) orientation(string) pagewidth(real 8.5) pageheight(real 14.0) lmargin(real 0.4) rmargin(real 0.4) tmargin(real 0.4) bmargin(real 0.4) linesize(real 120) scheme(string)]
	
	if "`scheme'"=="" local scheme "color" // Default scheme option
	
	if "`orientation'"!="" { // If user specified orientation option
		capture assert inlist("`orientation'", "portrait", "landscape")
		if _rc!=0 { // If orientation is not portrait or landscape
			local rc = _rc
			di as error `"The option "orientation" must be either portrait or landscape"'
			error `rc'
			exit
		}
		else if "`orientation'"=="portrait" { // If portrait orientation
			local pagewidth 8.5 // Default portrait page width (legal paper size)
			local pageheight 14.0 // Default portrait page height (legal paper size)
			local linesize 120 // Default portrait line size
		}
		else if "`orientation'"=="landscape" { // If landscape orientation
			local pagewidth 14.0 // Default landscape page width (legal paper size)
			local pageheight 8.5 // Default landscape page height (legal paper size)
			local linesize 200 // Default landscape line size
		}
	}
	
	translator set smcl2pdf fontsize `fontsize'
	translator set smcl2pdf pagesize custom
	translator set smcl2pdf pagewidth `pagewidth'
	translator set smcl2pdf pageheight `pageheight'
	translator set smcl2pdf lmargin `lmargin'
	translator set smcl2pdf rmargin `rmargin'
	translator set smcl2pdf tmargin `tmargin'
	translator set smcl2pdf bmargin `bmargin'
	translator set smcl2pdf scheme `scheme'
	set linesize `linesize'
end
