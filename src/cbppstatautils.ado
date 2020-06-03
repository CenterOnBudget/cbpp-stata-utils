
/***
Title
====== 

__cbppstatautils__ __{hline 2}__ Stata utility programs for working with ACS and CPS microdata, created by and for researchers at the Center on Budget and Policy Priorities.

Updates
-----------

Run __{stata cbppstatautils, update}__ to update to the latest version.

Contents
-----------

> __{help load_data}__ : Load CPS or ACS microdata from the CBPP datasets library into memory.

> __{help get_acs_pums}__ : Retrieve ACS PUMS files from the Census Bureau FTP.

> __{help make_acs_pums_lbls}__ : Generate .do files to label ACS PUMS data.

> __{help generate_acs_adj_vars}__ : Generate adjusted versions of ACS PUMS income and housing variables using 'adjinc' and 'adjhsg'.

> __{help generate_acs_major_group}__ : Generate categorical variable for major industry and/or occupation groups in ACS PUMS data.

> __{help generate_race_var}__ : Generate categorical variable for race/ethnicity in CPS or ACS microdata.

> __{help label_state}__ : Label a numeric state FIPS code variable with state names or postal abbreviations.

> __{help get_cpiu}__ : Retrieve annual CPI-U or CPI-U-RS series as a dataset, variable, or matrix.


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/

* capture program drop cbppstatautils

program define cbppstatautils

	syntax, [update]
	
	if "`update'" == "" {
	    help cbppstatautils
	}
	
	if "`update'" != "" {
	    net install cbppstatautils, from("https://raw.githubusercontent.com/CenterOnBudget/cbpp-stata-utils/master/src") replace
	}
	
end