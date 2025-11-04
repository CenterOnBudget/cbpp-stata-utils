*! version 0.2.12


/***
Title
====== 

__get_cpiu__ {hline 2} Load CPI-U or R-CPI-U-RS price index data series into memory or a matrix.


Description
-----------

get_cpiu retrieves annual average CPI-U (the default) or
[R-CPI-U-RS](https://www.bls.gov/cpi/research-series/r-cpi-u-rs-home.htm) 
(formerly CPI-U-RS) data series from the Bureau of Labor Statistics. The series 
may be loaded as a variable joined to existing data in memory, as a matrix, or as 
a new dataset replacing data in memory.

To ensure __get_cpiu__ is able to download data from the BLS website, specify 
your  email address in the __user_agent()__ option, or define a global macro 
named "BLS_USER_AGENT". The BLS website may block programs without an email 
address in the user-agent, per its [usage policy](https://www.bls.gov/bls/pss.htm). 

Users may request inflation adjustment factors based on the retrieved price index 
be generated. Inflation adjustment factors are used to convert current (nominal) 
dollars into constant (real) dollars. The __base_year()__ option specifies which 
year to use as the base year for the inflation adjustment factor. For example, 
__get_cpiu, base_year(2022)__ clear will load into memory the CPI-U data series 
as variable __cpiu__ and generate __cpiu_2022_adj__. Users may then multiply a 
variable containing nominal dollar values by __cpiu_2022_adj__ to obtain the 
values in 2022 constant dollars.

Data series are automatically cached. Users can load the cached data rather than 
re-downloading it by specifying __use_cache__. Note that price indices are 
occasionally back-revised. When loading cached data, __get_cpiu__ will display 
the date when the was originally downloaded. To refresh the cached data with the 
latest available data, run __get_cpiu__ without the __use_cache__ option.


Syntax
------ 

__get_cpiu__, { {bf:merge} | {opt mat:rix(matname)} | {bf:clear} } [_options_]


{synoptset 20}{...}
{synopthdr:options}
{synoptline}
  {synopt:{opt merge}}Merge the data into the dataset in memory.{p_end}
  {synopt:{opt mat:rix(matname)}}Load data into matrix _matname_.{p_end}
  {synopt:{opt clear}}Load the data into memory, replacing the dataset currently in memory. Cannot be combined with __merge__.{p_end}
  {synopt:{opt rs}}Retrieve the R-CPI-U-RS. If unspecified, the CPI-U will be retrieved.{p_end}
  {synopt:{opt b:ase_year(integer)}}Create inflation-adjustment factors from nominal dollars to real dollars, using the specified base year.{p_end}
  {synopt:{opt yearvar}}If __merge__ is specified, the key variable on which to merge the data into the dataset in memory. Default is {opt yearvar(year)}.{p_end}
  {synopt:{opt nolab:el}}Do not attach variable labels to the retrieved data. May only be specified with __merge__ or __clear__.{p_end}
  {synopt:{opt use_cache}}Use data from the cache if it exists. An internet connection is required to retrieve data when __use_cache__ is not specified or cached data does not exist.{p_end}
  {synopt:{opt user_agent(string)}}Email address to provide in the header of the HTTP request to the BLS website; passed to {help copy_curl}.{p_end} 
{synoptline}


Example(s)
----------

    Merge the CPI-U into the dataset in memory.
    
        {bf:. get_cpiu, merge}

    Load CPI-U-RS and inflation-adjustment factors to 2022 constant dollars into memory, replacing the dataset currently in memory.
    
        {bf:. get_cpiu, rs base_year(2022) clear}

    Load cached CPI-U data series into matrix {bf:inflation}.
    
        {bf:. get_cpiu, matrix(inflation) use_cache}


Website
-------

[centeronbudget.github.io/cbpp-stata-utils](https://centeronbudget.github.io/cbpp-stata-utils/)

***/


/* for debugging:
  sysuse uslifeexp2.dta, clear
  replace year = year + 79
**/

* capture program drop get_cpiu

program define get_cpiu

  syntax , [rs] [merge clear MATrix(name)]  ///
    [YEARVARname(string) Base_year(integer 0)]  ///
    [use_cache NOLABel user_agent(string)]
  
  
  **# Checks ------------------------------------------------------------------
  
  if "`merge'" == "" & "`clear'" == "" & "`matrix'" == "" {
    display as error "must specify one of {bf:merge}, {bf:clear}, or {bf:matrix()}"
    exit 198
  }
  
  if "`merge'" != "" & "`clear'" != "" {
    display as error "{bf:merge} and {bf:clear} may not be combined"
    exit 184
  }
  if "`merge'" == "" & "`yearvarname'" != "" {
    display as error "{bf:yearvarname()} may only be specified with {bf:merge}"
    exit 198
  }
    
  if "`merge'" != "" {
    if "`yearvarname'" != "" {
      confirm variable `yearvarname'
    }
    if "`yearvarname'" == "" {
      local yearvarname "year"
    }
  }
  
  local series = cond("`rs'" == "", "cpiu", "cpiu_rs")
  
  
  **# Set up cache directory --------------------------------------------------
  
  _cbppstatautils_cache  
  local cache_dir = "`s(cache_dir)'"
  
  
  **# Download file (if needed) and clean data --------------------------------
  
  * Download if use_cache is not specified, or if use_cache is specified but 
  * the file does not exist
  capture confirm file "`cache_dir'/`series'.dta"
  local download = (_rc != 0) | ("`use_cache'" == "")

  if "`clear'" == "" {
    preserve
  }
  
  if !`download' {
    use "`cache_dir'/`series'.dta", clear
  }
  
  if `download' {
    
    local user_agent = cond("${BLS_USER_AGENT}" != "", "${BLS_USER_AGENT}", "`user_agent'")
    
    quietly {
      
      if "`rs'" != "" {
        local url "https://www.bls.gov/cpi/research-series/r-cpi-u-rs-allitems.xlsx"
      } 
      else {
        local url "https://download.bls.gov/pub/time.series/cu/cu.data.1.AllItems"
      }
      
      tempfile data
      
      capture copy `url' `data'
        
      if _rc == 679 {
        if "`user_agent'" != "" {
          display "BLS server refused to send file"
          display "retrying with {help copy_curl} using user-agent '`user_agent''"
          copy_curl "`url'" `data', user_agent(`user_agent')
        }
        if "`user_agent'" == "" {
          display as error "BLS server refused to send file"
          display as error "{p}please specify your email to {bf:user_agent()} or define a global macro named {bf:BLS_USER_AGENT} and try again{p_end}"
          exit 679
        }
      }
      
      if "`rs'" != "" {
        import excel using `data', cellrange(A6) firstrow case(lower) clear
        rename avg `series'
        keep year `series'
        drop if missing(`series')
      }
      
      if "`rs'" == "" {
        import delimited using `data', clear
        keep if regexm(series_id, "CUUR0000SA0")
        keep if year >= 1978 & period == "M13"
        label variable value  // Remove variable label of mysterious origin
        rename value `series'
        keep year `series'
      }
      
      * Labeling the dataset has the nice side-effect of displaying the 
      * downloaded date when cached data is loaded
      label data "Inflation series `series' last downloaded `c(current_date)'."
      note : Inflation series `series' last downloaded `c(current_date)'.
      save "`cache_dir'/`series'.dta", replace
    
    }
  }
  
  * Calculate inflation adjustment factor if requested ------------------------
  
  if `base_year' != 0 {
  
    * Check that the base year is present in the series
    quietly levelsof year, local(years) separate("|")
    if !ustrregexm("`base_year'", "`years'") {
      display as error "{bf:base_year()} invalid or unavailable"
      exit 198
    }
    
    * Create inflation adjustment factor variable
    quietly generate val_if_base_year = `series' if year == `base_year'
    egen val_of_base_year = max(val_if_base_year)
    quietly generate `series'_`base_year'_adj =  val_of_base_year / `series'
    drop val_*_base_year

  }
  
  **# Label variables ---------------------------------------------------------
  
  if "`nolabel'" == "" {
  
    local series_nm = cond("`rs'" == "", "CPI-U", "CPI-U-RS")
    local lbl = ///
      cond("`merge'" != "", ///
        "`series_nm' for observation year '`yearvarname''", ///
        "`series_nm'")
    label variable `series' "`lbl'"
    if `base_year' != 0 {
      local lbl = ///
        cond("`merge'" != "", ///
          "`series_nm' inflator for observation year `yearvarname'' to `base_year'", ///
          "`series_nm' inflator to `base_year'")
      label variable `series'_`base_year'_adj "`lbl'"
    }
  
  }

  **# Create matrix and restore if matrix() specified -------------------------
  
  tempfile temp
  quietly save `temp'
  
  if "`matrix'" != "" {
    local mat_vars =  ///
      cond(`base_year' != 0, `"`series' `series'_`base_year'_adj"', "`series'")
    mkmat `mat_vars', matrix("`matrix'") rownames(year)
    restore
  }
  
  **# Restore and merge if merge specified ------------------------------------
  
  if "`merge'" != "" {
    if "`matrix'" == "" {
      restore
    }
    if "`yearvarname'" != "year" {
      quietly generate year = `yearvarname'
    }
    merge m:1 year using `temp', nogenerate keep(master match) nolabel noreport
    if "`yearvarname'" != "year" {
      quietly drop year
    }
  }
  
end


