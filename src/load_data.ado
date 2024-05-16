*! version 0.2.0


/***
Title
====== 

__load_data__ {hline 2} Load data from CBPP's datasets library into memory.


Description
-----------

__load_data__ loads CPS, ACS, ACS SPM, SNAP QC, or Household Pulse Survey microdata from a CBPP datasets library into memory.

This command is only useful for CBPP staff.

To use load_data, first:

{p 8 10 2}{c 149} Sync the datasets library to your laptop.

{p 8 10 2}{c 149} Add CBPP's global macros to your profile.do with {help make_cbpp_profile}.

Multiple years of data may be loaded at once by specifying a list of years to 
the __years()__ option. Variable and value labels from the maximum year will be 
retained.

When loading multiple years of ACS data, if the range of __years()__ spans the 
introduction of string characters to serialno in 2018, serialno will be edited 
("00" and "01" will be substituted for "HU" and "GQ", respectively) and 
destringed. 


Syntax
------ 

__load_data__ _dataset_ [_{help if}_], {opt y:ears(numlist)} [_options_]

where _dataset_ is "cps", "acs", "acs-spm", "qc", or "pulse" (case insensitive).


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
  {synopt:{opth y:ears(numlist)}}Year(s) of data to load. When _dataset_ is "cps", __years()__ refers to the survey (data release) year.{p_end}
  {synopt:{opth v:ars(varlist)}}Variables to load; default is all.{p_end}
  {synopt:{opth w:eeks(numlist)}}Alias for __years()__; for use when _dataset_ is "pulse".{p_end}
  {synopt:{opth p:eriod(integer)}}With _dataset_ "qc" and {opt year(2020)}, period of data to load: 1 for the pre-pandemic period or 2 for the waiver period.{p_end}
  {synopt:{opth saveas(filename)}}Save dataset to file.{p_end}
  {synopt:{opt replace}}When __saveas()__ is specified, replace existing dataset.{p_end}
  {synopt:{opt clear}}Replace the data in memory, even if the current data have not been saved to disk.{p_end}
{synoptline}


Example(s)
----------

    Load March 2023 CPS ASEC microdata.  
  
      {bf:. load_data cps, year(2023)}

    Load a subset of variables from ACS microdata for 2016-2018.  
  
      {bf:. load_data acs, years(2019 2021/2022) vars(serialno sporder st agep povpip pwgtp)}

    Load SNAP QC microdata for 2019.  
  
      {bf:. load_data qc, years(2019)}
  
    Load Household Pulse Survey microdata for weeks 61-23. 
  
      {bf:. load_data pulse, weeks(61/63)}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


***/


* capture program drop load_data
* capture program drop load

program define load_data 

	syntax anything(everything), [Years(numlist sort)] [Vars(string)] 		///
								 [saveas(string)] [Weeks(numlist sort)] [Period(integer 0)]	///
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
    if !inlist("`dataset'", "CPS", "ACS", "ACS-SPM", "QC", "PULSE") {
		display as error `"{bf:dataset()} must be "acs", "acs-spm", "cps", "qc", or "pulse" (case insensitive)"'
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
		capture numlist "`years'", range(>=1980 <=2023)
		if _rc != 0 {
			display as error "{bf:years()} must be between 1980 and 2023 inclusive when {bf:dataset()} is cps"
      display as error "to load a recently-released year, you may need to update cbppstatautils"
			exit 198
		}
	}
	if "`dataset'" == "ACS" {
		capture numlist "`years'", range(>=2000 <=2022)
		if _rc != 0 {
			display as error "{bf:years()} must be between 2000 and 2022 inclusive  (excluding 2020) when {bf:dataset()} is acs"
      display as error "to load a recently-released year, you may need to update cbppstatautils"
			exit 198
		}
        if ustrregexm("`r(numlist)'", "2020") {
            display as error "{bf:years()} must be between 2000 and 2019 inclusive (excluding 2020) when {bf:dataset()} is acs"
            exit 198
        }
	}
  if "`dataset'" == "ACS-SPM" {
    capture numlist "`years'", range(>=2009 <=2022)
    if _rc != 0 {
			display as error `"{bf:years()} must be between 2009 and 2022 inclusive  (excluding 2020) when {bf:dataset()} is "acs-spm""'
      display as error "to load a recently-released year, you may need to update cbppstatautils"
			exit 198
    }
    if ustrregexm("`r(numlist)'", "2020") {
      display as error `"{bf:years()} must be between 2009 and 2022 inclusive (excluding 2020) when {bf:dataset()} is "acs-spm""'
      exit 198
    }
  }
	if "`dataset'" == "QC" {
		capture numlist "`years'", range(>=1980 <=2020)
		if _rc != 0 {
			display as error "{bf:years()} must be between 1980 and 2020 inclusive when {bf:dataset()} is qc"
			exit 198
		}
    if !inrange(`period', 0, 2) {
      display as error "{bf:period()} must be 1 or 2 if specified"
      exit 198
    }
	}
    
    // check datasets library path global exists
	if "${spdatapath}" == "" {
		display as error "global 'spdatapath' not found."
		exit
	}
    
    // check dataset library is synced
	local dir = "`dataset'"
	if "`dataset'" == "HPS" {		// HPS could be synced as one of two names
	    mata : st_numscalar("dir_exists", direxists("${spdatapath}`dir'"))
		if scalar(dir_exists) != 1 {
		    local dir = "Household Pulse Survey"
		}
	}
	mata : st_numscalar("dir_exists", direxists("${spdatapath}`dir'"))
	if scalar(dir_exists) != 1 {
		display as error "${spdatapath}`dir' not found. Make sure it is synced and try again"
		exit 601
	}
  scalar drop dir_exists
  
    // check all needed files within dataset library are synced
	capture noisily {
		foreach y of local years {
			if "`dataset'" == "CPS" {
				capture noisily confirm file "${spdatapath}`dir'/mar`y'/mar`y'.dta"		
			}
			if "`dataset'" == "ACS" {
				capture noisily confirm file "${spdatapath}`dir'/`y'/`y'us.dta"
			}
      if "`dataset'" == "ACS-SPM" {
        capture noisily confirm file "${spdatapath}`dir'/acs_spm_`y'.dta"
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
          order serialno
				}
			display as result "serialno of `y' sample edited and destringed to facilitate appending."
			}
		}
    
    if "`dataset'" == "ACS-SPM" {
      quietly use `vars' `if' using "${spdatapath}`dir'/acs_spm_`y'.dta", clear
    }
		
		if "`dataset'" == "QC" {
			local suff = cond(`y' == 1980, "_aug", "")
      local suff = cond(`y' == 2020 & `period' != 0, "_per`period'", "")
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
								 [Weeks(numlist sort)] [saveas(string)] [Period(integer 0)]	///
								 [clear replace]
	
	load_data `anything', years(`years') vars(`vars') saveas(`saveas') period(`period') `clear' `replace'
	
end


