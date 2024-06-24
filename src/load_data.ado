*! version 0.2.9


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

    Load a subset of variables from ACS microdata for 2019, 2021, and 2022.  
  
      {bf:. load_data acs, years(2019 2021/2022) vars(serialno sporder st agep povpip pwgtp)}

    Load SNAP QC microdata for 2019.  
  
      {bf:. load_data qc, years(2019)}
  
    Load Household Pulse Survey microdata for weeks 61-63. 
  
      {bf:. load_data pulse, weeks(61/63)}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


***/


* capture program drop load_data
* capture program drop load

program define load_data 

  syntax anything(everything name=dataset id=dataset),  ///
    [Years(numlist sort)] [Vars(string)]  ///
    [Weeks(numlist sort)] [Period(integer 0)] ///
    [saveas(string) clear replace]
  
  
  gettoken dataset if : dataset
  
  
  *# Checks -------------------------------------------------------------------
    
  if "`clear'" == "" & _N != 0 & c(changed) != 0 {
    display as error "no; dataset in memory has changed since last saved"
    exit 4
  }

  local dataset = upper("`dataset'")
  if !inlist("`dataset'", "CPS", "ACS", "ACS-SPM", "QC", "PULSE") {
    display as error `"{bf:dataset()} must be "acs", "acs-spm", "cps", "qc", or "pulse" (case insensitive)"'
    exit 198
  }    
  
  * Years is required unless dataset is PULSE
  if "`years'" == "" & "`dataset'" != "PULSE" {
    display as error "option {bf:years()} required"
    exit 198
  }
  
  * If dataset is PULSE, either weeks or years is required
  if "`dataset'" == "PULSE" {
    if "`weeks'" == "" & "`years'" == "" {
      display as error "option {bf:weeks()} required"
      exit 198
    }
    if "`weeks'" != "" & "`years'" != "" {
      display as result "using {bf:weeks()} and ignoring {bf:years()}"
    }
    if "`weeks'" != "" {
      local years "`weeks'"
    }
  }

  
  **## Check dataset is available for requested years -------------------------
  
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
  
  **## Confirm dataset library is synced --------------------------------------
  
  * Datasets library global macro
  if "${spdatapath}" == "" {
    display as error "global 'spdatapath' not found."
    exit
  }
 
  local dir = "`dataset'"
  
  * Pulse could be synced as one of two names (neither of which are Pulse)
  if "`dataset'" == "PULSE" {
    local dir "HPS"
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
  
  
  **# Setup -------------------------------------------------------------------
  
  **## Find max year requested ------------------------------------------------
  
  * If multiple years are requested, will keep labels from maximum year
  local n_years : word count `years'
  if `n_years' > 1 {
    local years_list = ustrregexra("`years'", " ", ", ")
    local max_year = max(`years_list')
  }
  if `n_years' == 1 {
    local max_year = `years'
  }
  
  **## Flag if ACS serialno will need to be destringed ------------------------
  
  * If ACS data years span the introduction of string characters to serialno in 
  * 2018, serialno will need to be destringed before appending
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


  **# Load data ---------------------------------------------------------------
  
  clear
  
  * Default to all variables
  local vars = cond("`vars'" == "", "*", "`vars'")

  tempfile temp 
  quietly save `temp', emptyok
  
  foreach y of local years {
    
    if "`dataset'" == "PULSE" {
      display as result "Loading week `y' Pulse data..."
      local y = string(`y', "%02.0f")
      quietly use `vars' `if' using "${spdatapath}`dir'/hps_wk_`y'.dta", clear
    }
    
    if "`dataset'" == "CPS" {
      display as result "Loading March `y' CPS data..."
      quietly use `vars' `if' using "${spdatapath}`dir'/mar`y'/mar`y'.dta", clear
      quietly destring _all, replace
    }
    
    if "`dataset'" == "ACS" {
      
      display as result "Loading `y' ACS data..."
      quietly use `vars' `if' using "${spdatapath}`dir'/`y'/`y'us.dta", clear
      
      * If ACS data years span the introduction of string characters to serialno
      * in 2018, sub them out and destring
      if `y' >= 2018 & `destring' & ///
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
      display as result "Loading `y' ACS SPM data..."
      quietly use `vars' `if' using "${spdatapath}`dir'/acs_spm_`y'.dta", clear
    }
    
    if "`dataset'" == "QC" {
      display as result "Loading `y' QC data..."
      local suff = cond(`y' == 1980, "_aug", "")
      local suff = cond(`y' == 2020 & `period' != 0, "_per`period'", "")
      quietly use `vars' `if' using "${spdatapath}`dir'/`y'/qc_pub_fy`y'`suff'.dta", clear
    }
    
    * Keep labels only if year is the maximum year requested
    local nolabel = cond(`y' == `max_year', "", "nolabel")
    quietly append using `temp', `nolabel'
    quietly save `temp', replace
    
  }
  
  use `temp', clear
  
  local max_year_prefix =   ///
    cond("`dataset'" == "CPS", "March ", cond("`dataset'" == "PULSE", "week ", ""))
  local lbl_message =   ///
    cond(`n_years' > 1, "Labels are from `max_year_prefix'`max_year' dataset.", "")
  display as result "Done. `lbl_message'"
  
  
  **# Save if requested -------------------------------------------------------

  if "`saveas'" != "" {
    save "`saveas'", `replace'  
  }
 
end



program define load

  syntax anything(everything name=dataset id=dataset),  ///
    [Years(numlist sort)] [Vars(string)]  ///
    [Weeks(numlist sort)] [Period(integer 0)] ///
    [saveas(string) clear replace]
  
  load_data `dataset',  ///
    years(`years') vars(`vars')   ///
    weeks(`weeks') period(`period') saveas(`saveas') `clear' `replace'

end


