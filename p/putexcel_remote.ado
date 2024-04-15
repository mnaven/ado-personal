program define putexcel_remote
	*** Try the putexcel statement, capturing the results if there is an error
	capture putexcel `0'
	
	*** If the error was because putexcel was unable to save the file, then wait 1000ms and try again
	if _rc==603 {
		sleep 1000
		putexcel `0'
	}
	
	*** If there was a different error, then run the putexcel file again immediately and display the error message
	else if _rc!=0 {
		putexcel `0'
	}
end