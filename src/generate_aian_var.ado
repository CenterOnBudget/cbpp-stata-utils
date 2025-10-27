*! version 0.2.0


/***
Title
====== 

__generate_aian_var__ {hline 2} Generate an AIAN AOIC variable in ACS or CPS microdata.


Description
-----------

__generate_aian_var__ generates a categorical variable for American 
Indian or Alaska Native (AIAN) identification, alone or in combination (AOIC),
regardless of Hispanic or Latino identification. 

In ACS microdata, the variable __rac1p__ must exist. In CPS microdata, the variable 
__prdtrace__ must exist.

__generate_aian_var__ should not be used in CPS microdata for calendar years 
before 2012.


Syntax
------ 

__generate_aian_var__ {newvar}, {opt data:set(acs|cps)} [_options_]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
	{synopt:{opt data:set(string)}}The type of dataset in memory; ACS or CPS (case insensitive).{p_end}
  {synopt:{opt nolab:el}}Do not assign value labels to {it:newvar}.{p_end}
{synoptline}


Website
-------

[centeronbudget.github.io/cbpp-stata-utils](https://centeronbudget.github.io/cbpp-stata-utils/)

***/


* capture program drop generate_aian_var

program generate_aian_var

	syntax newvarname, DATAset(string) [NOLABel]

  
  local newvar `varlist'
  
  
	* checks ------------------------------------------------------------------
	
	// check that dataset is valid
	local dataset = lower("`dataset'")
	if !inlist("`dataset'", "acs", "cps") {
		display as error "{bf:dataset()} must be acs or cps (case insensitive)"
		exit 198
	}
	
	// check that needed variable exists
	local needed_var = cond("`dataset'" == "acs", "racaian", "prdtrace")
	confirm variable `needed_var'
	
	
  * generate variables ------------------------------------------------------

	if "`dataset'" == "acs" {
		generate `newvar' = racaian
	}

	if "`dataset'" == "cps" {
		generate `newvar' = 											///
			inlist(prdtrace, 3, 7, 10, 13, 14, 16, 19, 20, 22, 23, 24) ///
			if !missing(prdtrace)
    
		display as result "Definition valid for CPS ASEC files CY 2012 to present"
	}
	
  * create label ------------------------------------------------------------
  
  if "`no_label'" == "" {
    capture label drop `newvar'_lbl
    label define `newvar'_lbl 1 "AIAN AOIC" 0 "Not AIAN AOIC"
    label values `newvar' `newvar'_lbl
  }
  
end


