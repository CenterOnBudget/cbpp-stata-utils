/***
Title
====== 

__generate_aian_var__ {hline 2} Generate categorical AI/AN variable for CPS or ACS microdata.


Description
-----------

__generate_aian_var__ generates a categorial variable for American Indian/Alaska Native (AI/AN) identification. It can be used with CPS or ACS microdata.

This variable is the preferred universe for presenting Census data intended to represent the Native American population. For more information, see [link to document](www.cbpp.org).


Syntax
------ 

__generate_aian_var__ _{help newvar}_, [_options_]


{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Required}
	{synopt:{opt data:set(string)}}CPS or ACS (case insensitive).{p_end}
	
{syntab:Optional}
    {synopt:{opt no_label}}{it:newvar} will not be labelled.{p_end}
    {synopt:{opt replace}}{it:newvar} will be replaced if it exists.{p_end}

	
Example(s)
----------

   Generate a variable named "aian" for ACS microdata.
        {bf:. generate_aian_var aian, dataset(acs)}
		
		
Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/


program generate_race_var

	syntax name(name = new_varname), DATAset(string) [no_label replace]
	
	* checks ------------------------------------------------------------------
	
	// check that new_varname does not already exist if no replace
	if "`replace'" == "" {
		capture confirm variable `new_varname' 
		if _rc == 0 {
			display as error "`new_varname' already defined. Choose another name or use 'replace' option." 
		}
	}
	
	// check that dataset is correctly specified
	local dataset = lower("`dataset''")
	if !(inlist("`dataset'", "acs", "cps")){
		display as error "dataset(`dataset') invalid. Must be acs or cps."
		exit
	}
	
	// check that needed variable exists
	local needed_var = cond("`dataset'" == "acs", "racaian", "prdtrac")
	capture confirm variable `var'
	if _rc != 0 {
		display as error "Variable `var' needed but not found."
		exit
	}
	
	// (optionally) drop new_varname if it already exists
	if "`replace'" != "" {
		capture drop `new_varname'
	}
	
	* acs ------------------------------------------------------------------

	if "`dataset'" == "acs" {
		generate `new_varname' = 1 if racaian == 1
	}
	
	* cps ------------------------------------------------------------------

	if "`dataset'" == "cps" {
		generate `new_varname' = 1 if inlist(prdtrace, 3, 7, 10, 13, 14, 16, 19, 20, 22, 23)
	}
	
	* create label ------------------------------------------------------------
	
	if "`no_label'" == "" {
		capture label drop `new_varname'_lbl
		label define `new_varname'_lbl 	1 "AIAN" 0 "Not AIAN"
		label values `new_varname' `new_varname'_lbl
	}
	
end
