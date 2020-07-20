
/***
Title
====== 

__categorize__ {hline 2} Create a categorical variable.


Description
-----------

__cagegorize__ is a shortcut and extension of {help egen}'s _cut_ function with the icodes option.

Unlike egen cut, __categorize__ does not require the user to include the minumum and the maximum value of the continuous variable in the list of breaks. It creates more descriptive value labels for the generated categorical variable. Users can specify a variable label for the new variable. 

Finally, users working with age or poverty ratio variables may choose "default" breaks. With default(age), breaks are 18 and 65. With default(povratio), breaks are 50, 100, 150, 200, and 250.


Syntax
------ 

> __categorize__ _{help newvar}_ =_{help varname}_, [_options_]

where _{help newvar}_ is the name of the categorical variable to be generated and _{help varname}_ is the name of the continuous variable in memory.


{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
    {synopt:{opth breaks(numlist)}}left-hand ends of the grouping intervals. Do not include the minimum or the maximum value of {it:varname}.{p_end}
	{synopt:{opt default(age|povratio)}}use default breaks. Cannot be combined with the _breaks_ option.{p_end}
	{synopt:{opt nolab:el}}{it:newvar} will not be given value labels.{p_end}
	{synopt:{opt varlab:el(string)}}variable label for _newvar_.{p_end}


Example(s)
----------

    Generate labelled categorical variable 'income_cat' based on 'pincp'.
        {bf:. categorize inc_cat = pincp, breaks(15000 30000 50000 100000) varlabel("Income category")}

    Generate 'agecat' based on 'agep' with default breaks.
        {bf:. categorize age_cat = agep, default(age)}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/

* capture program drop categorize

program define categorize

	syntax newvarname =/exp, [breaks(numlist sort) default(string)]	///
							 [NOLABel] [VARLABel(string)]
	
	// throw error if other than varname or string variable
	confirm numeric variable `exp'
	
	// find min and max so user doesn't need to specify
	quietly summarize `exp'
	local max = `r(max)' + 1
	local min = `r(min)'
	
	// validate user-specified breaks and expand
	if "`breaks'" != "" {
		if "`default'" != "" {
			display as error "options breaks(`breaks') and default(`default') may not be combined"
			exit 184
		}
		
		numlist "`breaks'", range(>`min' <`max')
		local at = "`min' `r(numlist)' `max'"
	}
	
	// parse default breaks
	if "`breaks'" == "" {
		if "`default'" == "" {
			display as error "The 'default' option must be specified if no breaks are specified."
			exit 198
		}
		if !inlist("`default'", "age", "povratio") {
			display as error "option default(`default') incorrectly specified. Must be 'age' or 'povratio'."
			exit 198
		}
		if "`default'" == "age" {
			local at 0 18 65 `max'
			display "Using default age breaks: `at'."
		}
		if "`default'" == "povratio" {
			local at 0 50 100 150 200 250 `max'
			display "Using default poverty ratio breaks: `at'."
		}
	}
		
	local cuts = ustrregexra("`at'", " ", ", ")
	egen `varlist' = cut(`exp'), at(`cuts') icodes
	quietly replace `varlist' = `varlist' + 1
	
	if "`nolabel'" == "" {
		
		local n_cuts : word count `at'
		capture label drop `varlist'_lbl
		
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
			label define `varlist'_lbl `c' "`start'`to' `end'", add
		}
		
		label values `varlist' `varlist'_lbl
	}
	
	if "`varlabel'" != "" {
	    label variable `varlist' "`varlabel'"
	}
	
end
