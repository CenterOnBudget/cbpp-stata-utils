*! version 0.2.0


/***
Title
====== 

__load_data__ {hline 2} Load datasets from the CBPP datasets library.


Description
-----------

__load_data__ loads CPS ASEC, ACS, SNAP QC, or Household Pulse Survey microdata from 
the CBPP datasets library into memory. This command is only useful for CBPP 
staff.

This program will only work for Center staff who have synched these datasets 
from the SharePoint datasets library, and have set up the global _spdatapath_.  

With {opt dataset(acs)}, the program will load the one-year merged 
person-household ACS files. 

With {opt dataset(cps)}, the program will load the 
merged person-family-household CPS ASEC files. With {opt dataset(cps)}, 
__years()__ refers to the survey year, rather than the reference year. For 
example, __load_data cps, year(2019)__ will load the March 2019 CPS ASEC, whose
reference year is 2018.

Available years are 1980-2022 for
CPS ASEC, 2000-2019 and 2021 for ACS, and 1980-2019 for QC. 

Users may specify a single year or multiple years to __years()__ as a 
{help numlist}. With {opt dataset(pulse)}, users can specify the weeks of data 
to retrieve in either __weeks()__ or __years()__. If multiple years are 
specified, the datasets will be appended together before loading and retain 
variable and value labels from the maximum year in __years()__. 

The default is to load all variables in the dataset. Users may specify a subset 
of variables to load in the __vars()__ option.

To save the loaded data as a new dataset, use the __saveas()__ option. Also 
specify __replace__ to overwrite the dataset if it already exists.

Note: When loading multiple years of ACS datasets including 2018 and later 
samples, 'serialno' will be edited to facilitate appending ('serialno' is string
in 2018 and later datasets, and numeric in prior years' datasets): "00" and "01"
will be substituted for "HU" and "GQ", respectively, and the variable will be 
destringed.  


Syntax
------ 

> __load_data__ _dataset_ [_{help if}_], __{cmdab:y:ears}(_{help numlist}_)__ [__{cmdab:v:ars}(_{help varlist}_)__ __saveas(_{help filename}_)__ __replace__ __clear__]


Example(s)
----------

	Load March 2019 CPS ASEC microdata.  
		{bf:. load_data cps, year(2019)}

	Load a subset of variables from ACS microdata for 2016-2018.  
		{bf:. load_data acs, years(2016/2018) vars(serialno sporder st agep povpip pwgtp)}

	Load SNAP QC microdata for 2018.  
		{bf:. load_data qc, years(2018)}
	
	Load Household Pulse Survey microdata for weeks 22-24.  
		{bf: . load_data pulse, weeks(22/24)}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


***/


* capture program drop load_data
* capture program drop load

program define load_data 

	syntax anything(everything), [Years(numlist sort)] [Vars(string)] 		///
								 [saveas(string)] [Weeks(numlist sort)] 	///
								 [clear replace]
	
	
	* parse dataset and if ----------------------------------------------------
	
    local n_words : word count `anything'
	if `n_words' == 1 {
	    local dataset "`anything'"
		local if ""
	}
	if `n_words' > 1 {
	    local dataset : word 1 of `anything'
		local has_if = word("`anything'", 2) == "if"
		if `has_if' != 1 {
		    display as error "could not parse input. syntax is {bf:load_data dataset [if], years() [options]}"
			exit 198
		}
		local if : subinstr local anything "`dataset'" "", word
	}
	
	
    * error checking ----------------------------------------------------------
    
    if "`clear'" == "" & _N != 0 & c(changed) != 0 {
		display as error "no; dataset in memory has changed since last saved"
		exit 4
	}
    
    // check supported dataset
    local dataset = upper("`dataset'")
    if !inlist("`dataset'", "CPS", "ACS", "QC", "PULSE") {
		display as error "{bf:dataset()} must be acs, cps, qc, or pulse (case insensitive)"
        exit 198
	}    
	// check that years is specified unless dataset is pulse
	if "`dataset'" != "PULSE" & "`years'" == "" {
		display as error "option {bf:years()} required"
		exit 198
	}
	// if dataset is pulse use weeks for years, and rename
	if "`dataset'" == "PULSE" {
		local dataset "HPS"
		if "`weeks'" != "" {
			local years "`weeks'"
		}
	}
	
    // check years-dataset combination
	if "`dataset'" == "CPS" {
		capture numlist "`years'", range(>=1980 <=2022)
		if _rc != 0 {
			display as error "{bf:years()} must be between 1980 and 2022 inclusive when {bf:dataset()} is cps"
			exit 198
		}
	}
	if "`dataset'" == "ACS" {
		capture numlist "`years'", range(>=2000 <=2021)
		if _rc != 0 {
			display as error "{bf:years()} must be between 2000 and 2021 inclusive  (excluding 2020) when {bf:dataset()} is acs"
			exit 198
		}
        if ustrregexm("`r(numlist)'", "2020") {
            display as error "{bf:years()} must be between 2000 and 2019 inclusive (excluding 2020) when {bf:dataset()} is acs"
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
	local dir = "`dataset'"
	if "`dataset'" == "HPS" {		// HPS could be synched as one of two names
	    mata : st_numscalar("dir_exists", direxists("${spdatapath}`dir'"))
		if scalar(dir_exists) != 1 {
		    local dir = "Household Pulse Survey"
		}
	}
	mata : st_numscalar("dir_exists", direxists("${spdatapath}`dir'"))
	if scalar(dir_exists) != 1 {
		display as error "${spdatapath}`dir' not found. Make sure it is synched and try again"
		exit 601
	}
  
    // check all needed files within dataset library are synched
	capture noisily {
		foreach y of local years {
			if "`dataset'" == "CPS" {
				capture noisily confirm file "${spdatapath}`dir'/mar`y'/mar`y'.dta"		
			}
			if "`dataset'" == "ACS" {
				capture noisily confirm file "${spdatapath}`dir'/`y'/`y'us.dta"
			}
			if "`dataset'" == "QC" {
				local suff = cond(`y' == 1980, "_aug", "")
				capture noisily confirm file "${spdatapath}`dir'/`y'/qc_pub_fy`y'`suff'.dta"
			}
			if "`dataset'" == "HPS" {
				local y =  string(`y', "%02.0f")
				capture noisily confirm file "${spdatapath}`dir'/hps_wk_`y'.dta"
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
	
	// for messages if dataset is CPS
	local mar = cond("`dataset'" == "CPS", "March ", "")
	
    tempfile temp 
	quietly save `temp', emptyok
    
	foreach y of local years {
    	
		if "`dataset'" != "HPS" {

			display as result "Loading `mar'`y' `dataset' data..."
		}
		if "`dataset'" == "HPS" {
			display as result "Loading week `y' Pulse data..."
		}
        
		if "`dataset'" == "CPS" {
			quietly use `vars' `if' using "${spdatapath}`dir'/mar`y'/mar`y'.dta", clear
			quietly destring _all, replace
		}
        
		if "`dataset'" == "ACS" {
			quietly use `vars' `if' using "${spdatapath}`dir'/`y'/`y'us.dta", clear
			if `y' >= 2018 & `destring' & 						///
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
			quietly use `vars' `if' using "${spdatapath}`dir'/`y'/qc_pub_fy`y'`suff'.dta", clear
		}
		
		if "`dataset'" == "HPS" {
			local y = string(`y', "%02.0f")
			quietly use `vars' `if' using "${spdatapath}`dir'/hps_wk_`y'.dta", clear
		}
        
        local nolabel = cond(`y' == `max_year', "", "nolabel")
		quietly append using `temp', `nolabel' 
		quietly save `temp', replace
	}
    
	use `temp', clear
	local lbl_tweak = cond("`dataset'" == "HPS", "week ", "")
	local lbl_message = cond(`n_years' > 1, "Labels are from `lbl_tweak'`mar'`max_year' dataset.", "")
	display as result "Done. `lbl_message'"
    
	
    * save if requested -------------------------------------------------------
    
	if "`saveas'" != "" {
		save "`saveas'", `replace'	
	}
 
end



program define load

	syntax anything(everything), [Years(numlist sort)] [Vars(string)] 		///
								 [Weeks(numlist sort)] [saveas(string)] 	///
								 [clear replace]
	
	load_data `anything', years(`years') vars(`vars') saveas(`saveas') `clear' `replace'
	
end


