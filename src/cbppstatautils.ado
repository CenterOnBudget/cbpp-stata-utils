*! version 0.2.0


/***
Title
====== 

__cbppstatautils__ __{hline 2}__ Stata utility programs for working with ACS and CPS microdata, created by and for researchers at the Center on Budget and Policy Priorities.


Updates
-----------

Run __{stata cbppstatautils, update}__ to update to the latest version.


Contents
-----------

> __{help categorize}__ : Generate a categorical variable.

> __{help etotal}__ : Flexible counts and totals.

> __{help generate_acs_adj_vars}__ : Generate adjusted versions of ACS PUMS 
income and housing variables using 'adjinc' and 'adjhsg'.

> __{help generate_aian_var}__ : Generate categorical AI/AN variable for CPS or 
ACS microdata.

> __{help generate_race_var}__ : Generate categorical variable for 
race/ethnicity in CPS or ACS microdata.

> __{help get_acs_pums}__ : Retrieve ACS PUMS files from the Census Bureau FTP.

> __{help get_cpiu}__ : Retrieve annual CPI-U or CPI-U-RS series as a dataset, 
variable, or matrix.

> __{help inspect_2}__ : Summary statistics for positive, zero, negative, and 
missing values. 

> __{help label_acs_pums}__ : Label American Community Survey PUMS data.

> __{help label_state}__ : Label a numeric state FIPS code variable with state 
names or postal abbreviations.

> __{help labeller}__ : Define and apply variable and value labels in one step.

> __{help load_data}__ : Load datasets from the CBPP datasets library into 
memory.

> __{help make_cbpp_profile}__ : Set up CBPP's standard profile.do.

> __{help svyset_acs}__ : Declare the survey design for ACS PUMS.


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


***/


* capture program drop cbppstatautils

program define cbppstatautils

	syntax, [update]
	
	if "`update'" == "" {
	    help cbppstatautils
	}
	
	if "`update'" != "" {
	    ado update cbppstatautils, update
		display `"{browse "https://github.com/CenterOnBudget/cbpp-stata-utils/blob/master/NEWS.md":View changelog}"'
	}
	
end


