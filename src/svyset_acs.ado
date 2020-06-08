
/***
Title
====== 

__svyset_acs__ {hline 2} Declare the survey design for ACS PUMS.


Description
-----------

__svyset_acs__ is a shortcut program to declare the survey design for ACS PUMS.

In person-level data with the _rep_weights_ option, it is the equivalent to typing "svyset [iw=pwgtp], vce(sdr) sdrweight(pwgtp1 - pwgtp80) mse".
	
That command can be hard to remember and repeatedly copy-pasting can be troublesome; __svyset_acs__ provides a more convenient way.  


Syntax
------ 

> __svyset_acs__, __{cmdab:rec:ord_type}(_string_)__ [_{cmdab:rep:_weights}_]

Users must pass the record type of the data in memory (person or household) to __record_type__. Abbreviations _h, hhld, hous, p,_ and _pers_ are also accepted.

To specify that replicate weights be used in the survey design, use the __rep_weights__ option. 


Example(s)
----------

    Survey set household-level ACS PUMS data using replicate weights.
        {bf:. svyset_acs, record_type(hhld) rep_weights}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -
This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/


* capture program drop svyset_acs
* capture program drop declare_acs_svy_design

program svyset_acs

	syntax , RECord_type(string) [REP_weights]
	
	if !inlist("`record_type'", "p", "pers", "person", "h", "hh", "hous", "hhld", "household") {
		display as error "Record type must be person or household, or their respective supported abbreviations (see help file)."'
		exit
	}
	
	local record_type = cond(inlist("`record_type'", "p", "pers", "person"), "p", "h")
	local weight = cond("`record_type'" == "p", "pwgtp", "wgtp")
	
	confirm variable `weight'
	
	if "`rep_weights'" != "" {
		capture {
			forvalues r = 1/80 {
				display "`weight'`r'"
				confirm variable `weight'`r'
			}
		}
		if _rc != 0 {
			display as error "One or more replicate weight variables (`weight'1-`weight'80) not found."
			exit
		}
		svyset [iw=`weight'], vce(sdr) sdrweight(`weight'1-`weight'80) mse
	}
	
	if "`rep_weights'" == "" {
		svyset [iw=`weight']
	}

end


// for compatibility: old program name
program define declare_acs_svy_design
	syntax , RECord_type(string) [REP_weights]
	svyset_acs, record_type(`record_type') `rep_weights'
end

