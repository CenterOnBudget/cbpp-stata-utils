
/***
Title
====== 

__load_data__ {hline 2} Load datasets from the CBPP datasets library.


Description
-----------

__load_data__ loads CPS, ACS, or SNAP QC microdata from the CBPP datasets library into memory. 

This program will only work for Center staff who have synched these datasets from the SharePoint datasets library, and have set up the global _spdatapath_.  

If _dataset_ is ACS, the program will load the one-year merged person-household ACS files. If _dataset_ is CPS, the program will load the merged person-family-household CPS ASEC files. Available years are 1980-2020 for CPS, 2000-2019 for ACS, and 1980-2019 for QC.

Users may specify a single year or multiple years to the _years_ option as a {help numlist}. If multiple years are specified, the datasets will be appended together before loading and retain variable and value labels from the maximum year in _years_.  

The default is to load all variables in the dataset. Users may specify a subset of variables to load in the _vars_ option.  

To save the loaded data as a new dataset, use the _saveas_ option. If the file passed to _saveas_ already exists, it will be replaced.  

Note: When loading multiple years of ACS samples, _serialno_ may be edited to facilitate appending. The program will display a message if this occurs. This is because the _serialno_ variable is string in 2018 and later ACS datasets, and numeric in prior years' ACS datasets. If _serialno_ is edited, "00" and "01" will be substituted for "HU" and "GQ", respectively, in 2018 and later observations, and the variable will be destringed.  


Syntax
------ 

> __load_data__ _dataset_, __{cmdab:y:ears}(_{help numlist}_)__ [__{cmdab:v:ars}(_{help varlist}_)__ __saveas(_{help filename}_)__ __clear__]


Example(s)
----------

	Load CPS microdata for 2019.  
		{bf:. load_data cps, year(2019)}

	Load a subset of variables from ACS microdata for 2016-2018.  
		{bf:. load_data acs, years(2016/2018) vars(serialno sporder st agep povpip pwgtp)}

	Load SNAP QC microdata for 2018.  
		{bf:. load_data qc, years(2018)}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -
{it:This help file was dynamically produced by {browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package}.}
***/


* capture program drop load_data
* capture program drop load

program define load_data 

	syntax name(name=dataset), Years(numlist sort) [Vars(string)] [saveas(string)] [clear]
	
    
    * error checking ----------------------------------------------------------
    
    if "`clear'" == "" & _N != 0 & c(changed) != 0 {
		display as error "no; dataset in memory has changed since last saved"
		exit 4
	}
    
    // check supported dataset
    local dataset = upper("`dataset'")
    if !inlist("`dataset'", "CPS", "ACS", "QC"){
		display as error "{bf:dataset()} must be acs, cps, or qc (case insensitive)"
        exit 198
	}    
    // check years-dataset combination
	if "`dataset'" == "CPS" {
		capture numlist "`years'", range(>=1980 <=2020)
		if _rc != 0 {
			display as error "{bf:years()} must be between 1980 and 2020 inclusive when {bf:dataset()} is cps"
			exit 198
		}
	}
	if "`dataset'" == "ACS" {
		capture numlist "`years'", range(>=2000 <=2019)
		if _rc != 0 {
			display as error "{bf:years()} must be between 2000 and 2019 inclusive when {bf:dataset()} is acs"
			exit 198
		}
	}
	if "`dataset'" == "QC" {
		capture numlist "`years'", range(>=1980 <=2019)
		if _rc != 0 {
			display as error "{bf:years()} must be between 1980 and 2019 inclusive when {bf:dataset()} is qc"
			exit 198
		}
	}
    
    // check datasets library path global exists
	if "${spdatapath}" == "" {
		display as error "global 'spdatapath' not found."
		exit
	}
    
    // check dataset library is synched
	mata : st_numscalar("dir_exists", direxists("${spdatapath}`dataset'"))
	if scalar(dir_exists) != 1 {
		display as error "${spdatapath}`dataset' not found. Make sure it is synched and try again"
		exit 
	}
    
    // check all needed files within dataset library are synched
	capture noisily {
		foreach y of local years {
			if "`dataset'" == "CPS" {
				capture noisily confirm file "${spdatapath}`dataset'/mar`y'/mar`y'.dta"		
			}
			if "`dataset'" == "ACS" {
				capture noisily confirm file "${spdatapath}`dataset'/`y'/`y'us.dta"
			}
			if "`dataset'" == "QC" {
				local suff = cond(`y' == 1980, "_aug", "")
				capture noisily confirm file "${spdatapath}`dataset'/`y'/qc_pub_fy`y'`suff'.dta"
			}
			local rc = cond(_rc != 0, 1, 0)
		}
	}
	if `rc' != 0 {
		exit 601
	}


	* find max year requested -------------------------------------------------
    
    // if multiple years, will use labels from max year
    // see `nolabel' in next section
    local n_years : word count `years'
    if `n_years' > 1 {
    	local years_list = ustrregexra("`years'", " ", ", ")
    	local max_year = max(`years_list')
    }
    if `n_years' == 1 {
    	local max_year = `years'
    }
    
	if "`dataset'" == "ACS" {
		if `n_years' > 1 {
			capture numlist "`years'", range(<=2017)
			local all_str = _rc == 0
			capture numlist "`years'", range(>=2018)
			local all_num = _rc == 0
			local destring = cond(`all_num' == 0 & `all_str' == 0, 1, 0)
		}
		if `n_years' == 1 {
		    local destring 0
		}
	}
    

    * load and append data ----------------------------------------------------
    
	clear
    
    // default to all variables
	local vars = cond("`vars'" == "", "*", strlower("`vars'"))
	
    tempfile temp 
	quietly save `temp', emptyok
    
	foreach y of local years {
    	
		display as result "Loading `y' `dataset' data..."
        
		if "`dataset'" == "CPS" {
			quietly use `vars' using "${spdatapath}`dataset'/mar`y'/mar`y'.dta", clear	
		}
        
	if "`dataset'" == "ACS" {
			quietly use `vars' `if' using "${spdatapath}`dataset'/`y'/`y'us.dta", clear
			if `y' >= 2018 & `destring' & 									///
			   ("`vars'" == "*" | ustrregexm("`vars'", "serialno", 1)) {
			    quietly {
					replace serialno = ustrregexra(serialno, "HU", "00")
					replace serialno = ustrregexra(serialno, "GQ", "01")
					generate double serialno_num = real(serialno)
					drop serialno
					rename serialno_num serialno
				}
				display as result "serialno of `y' sample edited and destringed to facilitate appending."
			}
		}
		
		if "`dataset'" == "QC" {
			local suff = cond(`y' == 1980, "_aug", "")
			quietly use `vars' using "${spdatapath}`dataset'/`y'/qc_pub_fy`y'`suff'.dta", clear
		}
        
        local nolabel = cond(`y' == `max_year', "", "nolabel")
		quietly append using `temp', `nolabel' 
		quietly save `temp', replace
	}
    
    local lbl_message = cond(`n_years' > 1, "Labels are from `max_year' dataset.", "")
	display as result "Done. `lbl_message'"
    
	use `temp', clear
	
    
    * save if requested -------------------------------------------------------
    
	if "`saveas'" != "" {
		save "`saveas'", replace	
	}
 
end



program define load

	syntax name(name=dataset), Years(numlist sort) [Vars(string)] [saveas(string)] [clear]
	
	load_data `dataset', years(`years') vars(`vars') saveas(`saveas') `clear'
	
end


