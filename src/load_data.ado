
/***
Title
====== 

__load_data__ {hline 2} Load CPS or ACS microdata from the CBPP datasets library.


Description
-----------

__load_data__ loads CPS or ACS microdata from the CBPP datasets library into memory. 

This program will only work for Center staff who have synched these datasets from the SharePoint datasets library, and have set up the global 'spdatapath'. 

If _dataset_ is ACS, the program will load the one-year merged person-household ACS files. If _dataset_ is CPS, the program will load the merged person-family-household CPS ASEC files. Available years are 1980-2019 for CPS and 2000-2018 for ACS.

Users may specify a single year or multiple years to the __years__ option as a {help numlist}. If multiple years are specified, the datasets will be appended together before loading.

The default is to load all variables in the dataset. Users may specify a subset of variables to load in the __vars__ option.


Syntax
------ 

> __load_data__ _dataset_, __{cmdab:y:ears}(_{help numlist}_)__ [__{cmdab:v:ars}(_{help varlist}_)__ __clear__]


Example(s)
----------

	Load CPS microdata for 2019.  
		{bf:. load_data cps, year(2019)}
		
	Load a subset of variables from ACS microdata for 2017-2019.  
		{bf:. load_data acs, years(2017/2019) vars(serialno sporder st agep povpip pwgtp)}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/


 capture program drop load_data

program define load_data 

	syntax namelist(name=dataset), Years(numlist sort) [Vars(namelist)] [clear]
	
	if "${spdatapath}" == "" {
		display as error "Global 'spdatapath' not found."
		exit
	}
	
	if "`clear'" == "" & _N != 0 & c(changed) != 0 {
		display as error "no; dataset in memory has changed since last saved"
		exit 4
	}

	local dataset = upper("`dataset'")
	
	if !inlist("`dataset'", "CPS", "ACS"){
		display as error "dataset(`dataset') invalid. Must be CPS or ACS."
	}

	local vars = cond("`vars'" == "", "*", "`vars'")
	
	// confirm dataset is synched
	mata : st_numscalar("dir_exists", direxists("${spdatapath}`dataset'"))
	if scalar(dir_exists) != 1 {
		display as error "${spdatapath}`dataset' not found. Make sure it is synched and try again"
		exit 
	}
	
	// confirm requested years are available for dataset
	if "`dataset'" == "CPS" {
		capture numlist "`years'", range(>= 1980 <=2019)
		if _rc != 0 {
			display as error "years(`years') invalid. Datasets library has CPS data for 1980-2019."
			exit
		}
	}
	if "`dataset'" == "ACS" {
		capture numlist "`years'", range(>= 2000 <=2018)
		if _rc != 0 {
			display as error "years(`years') invalid. Datasets library has ACS data for 2000-2018."
			exit
		}
	}
	
	// confirm all files exist
	capture noisily {
		foreach y of local years {
			if "`dataset'" == "CPS" {
				capture noisily confirm file "${spdatapath}`dataset'/mar`y'/mar`y'.dta"		
			}
			if "`dataset'" == "ACS" {
				capture noisily confirm file "${spdatapath}`dataset'/`y'/`y'us.dta"
			}
			local rc = cond(_rc != 0, 1, 0)
		}
	}
	if `rc' != 0 {
		exit 601
	}
	
	// load and append data
	clear
	tempfile temp 
	quietly save `temp', emptyok
	foreach y of local years {
		if "`dataset'" == "CPS" {
			quietly use `vars' using "${spdatapath}`dataset'/mar`y'/mar`y'.dta", clear	
		}
		if "`dataset'" == "ACS" {
			quietly use `vars' using "${spdatapath}`dataset'/`y'/`y'us.dta", clear
		}
		quietly append using `temp' 
		quietly save `temp', replace
	}
	use `temp', clear
 
end

