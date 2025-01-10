*! version 0.2.9


/***
Title
====== 

__svyset_acs__ {hline 2} Declare the survey design in ACS microdata.


Description
-----------

__svyset_acs__ is a shortcut program to declare the survey design in ACS 
microdata with {help svyset}.

For example, __svyset_acs, record_type(person)__ is equivalent to 
__svyset [iw=pwgtp], vce(sdr) sdrweight(pwgtp1-pwgtp80) mse__.


Syntax
------ 

__svyset_acs__, {opt rec:ord_type(string)} [_options_]


{synoptset 20}{...}
{synopthdr:options}
{synoptline}
  {synopt:{opt rec:ord_type(string)}}Record type of the dataset in memory; "person" or "household". Abbreviations "h", "hhld", "hous", "p", and "pers" are also accepted.{p_end}
  {synopt:{opth n_years(integer)}}Specifies the number of years of ACS microdata in memory; default is 1. If __n_years()__ is greater than 1, __svyset_acs__ will generate copies of the weights variables divided by this number and use those weights in __svyset__.{p_end}
{synoptline}


Example(s)
----------

    Survey set household-level ACS microdata.  
    
      {bf:. svyset_acs, record_type(hhld)}

    Survey set a dataset comprised of 3 years of 1-year person-level ACS microdata.  
    
      {bf:. svyset_acs, record_type(person) n_years(3)}


Website
-------

[centeronbudget.github.io/cbpp-stata-utils](https://centeronbudget.github.io/cbpp-stata-utils/)

***/


* capture program drop svyset_acs

program svyset_acs

  syntax ,  ///
    RECord_type(string) ///
    [n_years(integer 1)]  ///
    [MULTIyear(integer 1)] [NOSDRweights] 
  
  if !inlist("`record_type'", "p", "pers", "person", "h", "hh", "hous", "hhld", "household") {
    display as error "{bf:record_type()} must be person, household, their respective supported abbreviations, or both"
    exit 198
  }
  
  local record_type = cond(inlist("`record_type'", "p", "pers", "person"), "p", "h")
  local weight = cond("`record_type'" == "p", "pwgtp", "wgtp")
  
  confirm variable `weight'
  
  if "`nosdrweights'" == "" {
    capture {
      forvalues r = 1/80 {
        confirm variable `weight'`r'
      }
    }
    if _rc != 0 {
      display as error "one or more replicate weight variables (`weight'1-`weight'80) not found"
      exit 111
    }
  }
  
  if `multiyear' > 1  {
    display as result "{bf:multiyear()} is deprecated; please use {bf:n_years()}"
    if `n_years' > 1 {
      display as error "either {bf:n_years()} or {bf:multiyear()} may be specified, not both"
      exit 198
    }
  }
  
  local n_years = max(`multiyear', `n_years')
  
  if `n_years' == 1 {
    if "`nosdrweights'" == "" {
      svyset [iw=`weight'], mse vce(sdr) sdrweight(`weight'1-`weight'80)
    }
    if "`nosdrweights'" != "" {
      svyset [iw=`weight']
    }
  }
    
  if `n_years' > 1 {
    display as result "using `n_years'-year average weights"
    foreach w of varlist `weight'* {
      quietly generate `w'_`n_years'yr = `w' / `n_years'
    }
    if "`nosdrweights'" == "" {
      svyset [iw=`weight'_`n_years'yr], mse vce(sdr)  ///
        sdrweight(`weight'1_`n_years'yr-`weight'80_`n_years'yr)
    }
    if "`nosdrweights'" != "" {
      svyset [iw=`weight'_`n_years'yr]
    }
  }

end


