*! version 0.2.9


/***
Title
====== 

__labeller__ {hline 2} Create and attach variable and value labels in one step.


Description
-----------

__labeller__ is a shortcut command to label a variable and define and attach 
value labels in one go.

Labeling a variable and its values with built-in commands involves several 
steps:

      {bf:. label variable sex "Sex assigned at birth"}
      {bf:. label define sex_lbl 1 "Male" 2 "Female"}
      {bf:. label values sex sex_lbl}

Using __labeller__:

      {bf:. labeller sex, variable("Sex assigned at birth") values(1 "Male" 2 "Female")}
    
__labeller__ can also be used to "zap" variable and value labels from a variable, by specifying the __remove__ option.    
  
Syntax
------ 

> __labeller__ _{help varname}_, [__{cmdab:var:iable}(_string_)__] [__{cmdab:val:ues}(_string_)__] [_options_]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
  {synopt:{opt var:iable}}variable label following {help label variable}: {it:"label"}{p_end}
  {synopt:{opt val:ues}}value labels following {help label define}: {it:# "label" [# "label" ...]}{p_end}
  {synopt:{opt lblname(string)}}name of value label to use; default is {bf:lblname(}{it:varname}_lbl{bf:)}.{p_end}
  {synopt:{opt add}}add new entries in {opt values()} to {it:varname}'s value label.{p_end}
  {synopt:{opt modify}}modify or delete existing # to label correspondences and add new correspondences to {it:varname}'s value label.{p_end}
  {synopt:{opt remove}}remove variable and value labels from _varname_.{p_end}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


***/


* capture program drop labeller

program define labeller

	syntax varname,   ///
    [VARiable(string) VALues(string asis)]  ///
    [lblname(string)] [add modify remove]
	
	if "`add'" == "" & "`modify'" == "" {
		local replace "replace"
	}
	
	if "`variable'" != "" {
		label variable `varlist' "`variable'"
	}
	
	if `"`values'"' != "" {
    
    if "`lblname'" == "" {
      local lblname "`varlist'_lbl"
    }

    label define `lblname' `values', `add' `modify' `replace'
    label values `varlist' `lblname'
    
	}

	if "`remove'" != "" {
		label variable `varlist'
		label values `varlist'
	}
	
end


		