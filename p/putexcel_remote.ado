program define putexcel_remote
	*** Try the putexcel statement, capturing the results if there is an error
	capture putexcel `0'
	
	*** If the error was because putexcel was unable to save the file, then wait 1000ms and try again
	if _rc==603 {
		local i = 1
		while _rc==603 & `++i'<=10 {
			di "Attempt #" `i'
			sleep 1000
			capture putexcel `0'
		}
		if _rc==603 {
			di "Maximum number of attempts reached."
		}
	}
	
	*** If there was a different error, then run the putexcel file again immediately and display the error message
	else if _rc!=0 {
		putexcel `0'
	}
end