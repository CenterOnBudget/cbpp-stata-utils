
/***
Title
====== 

__label_state__ {hline 2} Label state FIPS code variable with state names or postal abbreviations.


Description
-----------

__label_state__ labels state [FIPS code](https://www.census.gov/geographies/reference-files/2018/demo/popest/2018-fips.html) variables with the full state name (the default) or postal abbreviation.  
The 50 states, District of Columbia, Puerto Rico, and U.S. territories are supported.


Syntax
------ 

> __label_state__ {it}{help varname}{sf}, [_abbrv_]

If the state FIPS code variable __varname__ is a string, it will be destringed.    
To label with two-character postal abbreviations (e.g. "VT") rather than the full state name, use the _abbrv_ option.


Example(s)
----------

    Label 'gestfips', the variable for state FIPS code in the CPS, with state names.
        {bf:. label_state gestfips}
	Label 'st', the variable for state FIPS code in the ACS, with state abbreviations.
        {bf:. label_state st, abbrv}

Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -
This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/

* capture program drop label_state

program label_state

	syntax varname, [abbrv]

	// destring in case variable is string with leading zeros
	capture confirm string `varlist' 
	if _rc != 0 {
		quietly destring `varlist', replace 
	}
	
	// drop state_lbl if it exists
	capture label drop state_lbl			
	
	// construct labels from state_fips.dta (comes with cbppstatautils package)
	preserve
	sysuse state_fips, clear
	local lbl_content_var = cond("`abbrv'" == "", "state_name", "state_abbrv")
	generate lbl = "label define state_lbl " + state_fips + " " + `"""' + `lbl_content_var' + `"""' + ", add "
	quietly levelsof lbl, local(lbls)
	
	// define and apply label
	restore
	foreach l of local lbls {
		`l'
	}
	label values `varlist' state_lbl
	
end
