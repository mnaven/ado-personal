cap program drop smcl2pdf_settings
program define smcl2pdf_settings
	version 17.0
	
	syntax [, header logo nocmdnumber fontsize(real 8) pagesize(string) orientation(string) pagewidth(real -1) pageheight(real -1) lmargin(real 0.4) rmargin(real 0.4) tmargin(real 0.4) bmargin(real 0.4) linesize(real -1) scheme(string)]
	
	
	**** Set Defaults ****
	* Default Page Size: legal
	if "`pagesize'"=="" & `pagewidth'==-1 & `pageheight'==-1 { // If pagesize, pagewidth, and pageheight options are not specified
		local pagesize "legal"
		translator set smcl2pdf pagesize legal
	}
	
	
	* Default Scheme: color
	if "`scheme'"=="" local scheme "color"
	
	
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
	
	
	**** Set smcl2pdf Settings
	* Header
	if "`header'"=="header" translator set smcl2pdf header on
	else translator set smcl2pdf header off
	
	* Logo
	if "`logo'"=="logo" translator set smcl2pdf logo on
	else translator set smcl2pdf logo off
	
	* Command Number
	if "`cmdnumber'"=="nocmdnumber" translator set smcl2pdf cmdnumber off
	else translator set smcl2pdf cmdnumber on
	
	* Font Size
	translator set smcl2pdf fontsize `fontsize'
	
	* Page Size
	if "`pagesize'"!="" translator set smcl2pdf pagesize `pagesize'
	else { // If pagesize not specified
		translator set smcl2pdf pagesize custom
		translator set smcl2pdf pagewidth `pagewidth'
		translator set smcl2pdf pageheight `pageheight'
	}
	
	* Margins
	translator set smcl2pdf lmargin `lmargin'
	translator set smcl2pdf rmargin `rmargin'
	translator set smcl2pdf tmargin `tmargin'
	translator set smcl2pdf bmargin `bmargin'
	
	* Scheme
	translator set smcl2pdf scheme `scheme'
	
	* Line Size
	set linesize `linesize'
end
