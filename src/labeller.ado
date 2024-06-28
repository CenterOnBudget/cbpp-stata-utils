*! version 0.2.9


/***
Title
====== 

__labeler__ {hline 2} Create and attach variable and value labels in one step.


Description
-----------

__labeler__ is a shortcut command to label a variable and define and attach 
value labels in one go.

Labeling a variable and its values with built-in commands involves several 
steps:

      {bf:. label variable sex "Sex assigned at birth"}
      {bf:. label define sex_lbl 1 "Male" 2 "Female"}
      {bf:. label values sex sex_lbl}

Using __labeler__:

      {bf:. labeler sex, variable("Sex assigned at birth") values(1 "Male" 2 "Female")}
    
__labeler__ can also be used to "zap" variable and value labels from a variable, by specifying the __remove__ option.    
  
Syntax
------ 

__labeler__ {varname}, [{opt var:iable(string)}] [{opt val:ues(string)}] [_options_]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
  {synopt:{opt var:iable}}Variable label for _varname_.{p_end}
  {synopt:{opt val:ues}}Value labels for _varname_, following the same syntax as {help label define}: {it:# "label" [# "label" ...]}{p_end}
  {synopt:{opt lblname(string)}}Name of the value label to use. Default is "{it:varname}_lbl".{p_end}
  {synopt:{opt add}}Add value labels in __values()__ to {it:varname}'s existing value label.{p_end}
  {synopt:{opt modify}}Use value labels in __values()__ to modify or delete existing # to label correspondences or add new correspondences to {it:varname}'s existing value label.{p_end}
  {synopt:{opt remove}}Remove variable labels and detach value labels from _varname_. Value labels will not be dropped from the dataset.{p_end}
{synoptline}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


***/


* capture program drop labeller
* capture program drop labeler

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


program define labeler

  syntax varname,   ///
    [VARiable(string) VALues(string asis)]  ///
    [lblname(string)] [add modify remove]
	
  labeller `varlist', 	///
	variable(`variable') values(`values') 	///
	lblname(`lblname') `add' `modify' `remove'
  
end
    