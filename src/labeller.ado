
/***
Title
====== 

__labeller__ {hline 2} Define and apply variable and value labels in one step.



Syntax
------ 

> __labeller__ _{help varname}_, [__{cmdab:var:iable}(_string_)__] [__{cmdab:val:ues}(_string_)__], [_options_]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
	{synopt:{opt var:iable}}variable label following {help label variable}: {it:"label"}{p_end}
	{synopt:{opt val:ues}}value labels following {help label define}: {it: # "label" [# "label" ...]}{p_end}
    {synopt:{opt add}}add new entries in {bf:values} to existing value label created by {bf:labeller}.{p_end}
    {synopt:{opt modify}}modify or delete existing # to label correspondences and add new
        correspondences to existing value label created by {bf:labeller}.{p_end}
	{synopt:{opt remove}}remove variable and value labels from a variable.{p_end}

Example(s)
----------

    Using labeller
        {bf:. labeller gender, variable("Gender") values(1 "Male" 2 "Female" 3 "Other")}

    Using built-in functions  
        {bf:. label variable gender "Gender"}  
        {bf:. label define gender_lbl 1 "Male" 2 "Female" 3 "Other"}  
        {bf:. label values gender gender_lbl}  
  

Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/


* capture program drop labeller

program define labeller

	syntax varname, [VARiable(string) VALues(string asis)] [add modify remove]

	display "Warning from cbppstatautils developers: command name likely to change"
	
	if "`add'" == "" & "`modify'" == "" {
		local replace "replace"
	}
	
	if "`variable'" != "" {
		label variable `varlist' "`variable'"
	}
	
	if `"`values'"' != "" {
		label define `varlist'_lbl `values', `add' `modify' `replace'
		label values `varlist' `varlist'_lbl
	}

	if "`remove'" != "" {
		label variable `varlist'
		label values `varlist'
	}
	
end
	
		