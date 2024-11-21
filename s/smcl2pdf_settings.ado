cap program drop smcl2pdf_settings
program define smcl2pdf_settings
	version 17.0
	
	syntax [, HEADer LOGO noCMDnumber FONTSize(integer -1) PAGESize(string) ORIENTation(string) PAGEWidth(real -1) PAGEHeight(real -1) Margins(real -1) LMargin(real -1) RMargin(real -1) TMargin(real -1) BMargin(real -1) LINESize(integer -1) SCHEME(string) Query]
	
	
	**** Error Checks ****
	* Error Checks for Page Size and Page Width/Height
	if "`pagesize'"!="" { // If pagesize option is specified
		capture assert inlist(strupper("`pagesize'"), "LETTER", "LEGAL", "A3", "A4", "A5", "B4", "B5")
		if _rc!=0 { // If pagesize is not letter, legal, A3, A4, A5, B4, or B5
			local rc = _rc
			di as error `"The option "pagesize" must be either letter, legal, A3, A4, A5, B4, or B5."'
			error `rc'
			exit
		}
		else if `pagewidth'!=-1 | `pageheight'!=-1 { // If pagewidth or pageheight options are specified
			di as error `"The option "pagesize" cannot be combined with the options "pagewidth" and "pageheight"."'
			error 184
			exit
		}
		else translator set smcl2pdf pagesize `pagesize'
	}
	
	
	* Error Check for Orientation
	if "`orientation'"!="" { // If orientation option is specified
		capture assert inlist("`orientation'", "portrait", "landscape")
		if _rc!=0 { // If orientation is not portrait or landscape
			local rc = _rc
			di as error `"The option "orientation" must be either portrait or landscape."'
			error `rc'
			exit
		}
	}
	
	
	* Error Checks for Orientation and Page Width/Height
	if `pagewidth'!=-1 & `pageheight'!=-1 { // If pagewidth and pageheight options are specified
		if "`orientation'"=="portrait" capture assert `pagewidth'<`pageheight'
			if _rc!=0 { // If pagewidth is not less than pageheight
				local rc = _rc
				di as error `"Page width must be less than page height for portrait orientation."'
				error `rc'
				exit
			}
		else if "`orientation'"=="landscape" capture assert `pageheight'<`pagewidth'
			if _rc!=0 { // If pageheight is not less than pagewidth
				local rc = _rc
				di as error `"Page height must be less than page width for landscape orientation."'
				error `rc'
				exit
			}
		
		if `pagewidth'<`pageheight' local orientation "portrait"
		else if `pageheight'<`pagewidth' local orientation "landscape"
		
		translator set smcl2pdf pagesize custom
		translator set smcl2pdf pagewidth `pagewidth'
		translator set smcl2pdf pageheight `pageheight'
	}
	
	
	* Error Check for Margins
	if `margins'!=-1 { // If margins option is specified
		capture assert `lmargin'==-1 & `rmargin'==-1 & `tmargin'==-1 & `bmargin'==-1
		if _rc!=0 { // If one of the margin options is specified
			local rc = _rc
			di as error `"The option "margins" cannot be combined with the options "lmargin", "rmargin", "tmargin", or "bmargin"."'
			error `rc'
			exit
		}
		else { // If none of the margin options are specified
			local lmargin `margins'
			local rmargin `margins'
			local tmargin `margins'
			local bmargin `margins'
		}
	}
	
	
	
	
	**** Set Orientation via Page Width and Page Height
	if `pagewidth'==-1 & `pageheight'==-1 { // If pagewidth and pageheight options are not specified
		quiet: translator query smcl2pdf
		if r(pagewidth)<r(pageheight) { // If current settings are portrait orientation
			local short_side = r(pagewidth)
			local long_side = r(pageheight)
			local orientation_query "portrait"
		}
		else if r(pageheight)<r(pagewidth) { // If current settings are landscape orientation
			local short_side = r(pageheight)
			local long_side = r(pagewidth)
			local orientation_query "landscape"
		}
		
		if "`orientation'"=="portrait" { // If portrait option is specified
			translator set smcl2pdf pagesize custom
			translator set smcl2pdf pagewidth `short_side'
			translator set smcl2pdf pageheight `long_side'
		}
		else if "`orientation'"=="landscape" { // If landscape option is specified
			translator set smcl2pdf pagesize custom
			translator set smcl2pdf pagewidth `long_side'
			translator set smcl2pdf pageheight `short_side'
		}
		else if "`orientation'"=="" local orientation "`orientation_query'"
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
	if `fontsize'!=-1 translator set smcl2pdf fontsize `fontsize'
	
	* Margins
	if `lmargin'!=-1 translator set smcl2pdf lmargin `lmargin'
	if `rmargin'!=-1 translator set smcl2pdf rmargin `rmargin'
	if `tmargin'!=-1 translator set smcl2pdf tmargin `tmargin'
	if `bmargin'!=-1 translator set smcl2pdf bmargin `bmargin'
	
	* Scheme
	translator set smcl2pdf scheme `scheme'
	
	* Line Size
	if `linesize'==-1 { // If linesize option not specified
		if "`orientation'"=="portrait" local linesize 120
		else if "`orientation'"=="landscape" local linesize 200
	}
	else set linesize `linesize'
	
	
	
	
	**** Translator Query
	if "`query'"=="query" { // If query option is specified
		translator query smcl2pdf
		di "The log file is in {bf:`orientation'} orientation with a line size of {bf:`linesize'}."
	}
end
