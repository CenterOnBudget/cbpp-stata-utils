
/***
Title
====== 

__categorize__ {hline 2} Create a categorical variable.


Description
-----------

__categorize__ is a shortcut and extension of {help egen}'s _cut_ function with 
the icodes option.

Unlike egen cut:  
__categorize__ does not require the user to include the minumum and the maximum 
value of the continuous variable in the list of breaks.  
It creates more descriptive value labels for the generated categorical variable.  
Users can specify a variable label for the new variable.

Finally, users working with age or poverty ratio variables may choose "default" 
breaks. With {opt default(age)}, breaks are 18 and 65. With 
{opt default(povratio)}, breaks are 50, 100, 150, 200, and 250.


Syntax
------ 

> __categorize__ _{help varname}_, {cmdab:gen:erate}(_{help newvar}_) [_options_]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
    {synopt:{opth gen:erate(newvar)}}name of the categorical variable to be generated.{p_end}
    
{syntab:Optional}
    {synopt:{opth breaks(numlist)}}left-hand ends of the grouping intervals. Do not include the minimum or the maximum value of {it:varname}. Either {opt breaks()} or {opt default()} must be specified.{p_end}
	{synopt:{opt default(age|povratio)}}use default breaks; cannot be combined with __breaks()__.{p_end}
	{synopt:{opt nolab:el}}do not give _newvar_ value labels.{p_end}
	{synopt:{opt varlab:el(string)}}variable label for _newvar_.{p_end}


Example(s)
----------

    Generate categorical variable 'inc_cat' from 'pincp'.
        {bf:. categorize pincp, generate(inc_cat) breaks(15000 30000 50000 100000)}

    Generate 'age_cat' from 'agep' using default breaks.
        {bf:. categorize agep, generate(age_cat) default(age) varlabel("Age group")}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


***/


* capture program drop categorize

program define categorize

	syntax varname(numeric), GENerate(name) [breaks(numlist sort)]          ///
                             [default(string) NOLABel VARLABel(string)]
	
    
    local varname `varlist'
    
    * check for errors --------------------------------------------------------
    
    // throw error if generate already exists
    local newvar `generate'
    capture confirm `newvar'
    if _rc == 0 {
        display as error "{bf:`newvar'} already defined"
        exit 110
    }
    
    
    * define breaks -----------------------------------------------------------
    
	// find min and max so user doesn't need to specify
	quietly summarize `varname'
	local max = `r(max)' + 1
	local min = `r(min)'
	
	// validate user-specified breaks and expand
	if "`breaks'" != "" {
		if "`default'" != "" {
			display as error "{bf:breaks()} and {bf:default()} may not be combined"
			exit 184
		}
		
		numlist "`breaks'", range(>`min' <`max')
		local at = "`min' `r(numlist)' `max'"
	}
	
	// parse default breaks
	if "`breaks'" == "" {
		if "`default'" == "" {
			display as error "{bf:default()} must be specified if {bf:default()} is not specified"
			exit 198
		}
		if !inlist("`default'", "age", "povratio") {
			display as error "{bf:default()} must be 'age' or 'povratio'"
			exit 198
		}
		if "`default'" == "age" {
			local at 0 18 65 `max'
			display as result "Using default age breaks: `at'."
		}
		if "`default'" == "povratio" {
			local at 0 50 100 150 200 250 `max'
			display as result "Using default poverty ratio breaks: `at'."
		}
	}
	
    
	* generate new variable ---------------------------------------------------
    
	local cuts = ustrregexra("`at'", " ", ", ")
	egen `newvar' = cut(`varname'), at(`cuts') icodes
	quietly replace `newvar' = `newvar' + 1
	
    
    * label new variable ------------------------------------------------------
    
	if "`nolabel'" == "" {
		
		local n_cuts : word count `at'
		capture label drop `newvar'_lbl
		
		forvalues c = 1/`n_cuts' {
			
			local c_1 = `c' + 1
			local start : word `c' of `at'
			local start = strofreal(`start', "%13.0gc")
			local end : word `c_1' of `at'
			
			if `c' < (`n_cuts' - 1) {
				local end = `end' - 1
				local end = strofreal(`end', "%13.0gc")
				local to " to"
			}
			if `c' == (`n_cuts' - 1) {
				local end "and up"
				local to ""
			}
			label define `newvar'_lbl `c' "`start'`to' `end'", add
		}
		
		label values `newvar' `newvar'_lbl
	}
	
	if "`varlabel'" != "" {
	    label variable `newvar' "`varlabel'"
	}
	
end


