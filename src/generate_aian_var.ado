*! version 0.2.0


/***
Title
====== 

__generate_aian_var__ {hline 2} Generate categorical AI/AN variable for CPS or 
ACS microdata.


Description
-----------

__generate_aian_var__ generates a categorial variable for American 
Indian/Alaska Native (AI/AN) identification, alone or in combination, regardless
of Hispanic identification. It can be used with CPS (calendar year 2012 and 
later) or ACS microdata.


Syntax
------ 

__generate_aian_var__ _{help newvar}_, [_options_]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Required}
	{synopt:{opt data:set(string)}}CPS or ACS (case insensitive).{p_end}
	
{syntab:Optional}
    {synopt:{opt nolab:el}}{it:newvar} will not be labelled.{p_end}

	
Example(s)
----------

   Generate a variable named 'aian' for ACS microdata.
        {bf:. generate_aian_var aian, dataset(acs)}
		
		
Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


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


