*! version 0.2.9


/***
Title
====== 

__categorize__ {hline 2} Create a categorical variable from a continuous one.


Description
-----------

__categorize__ is a shortcut and extension of __{help egen} newvar = cut(args) [...], icodes__.

Unlike {help egen} with the __cut()__ function, __categorize__:

{p 8 10 2}{c 149} Does not require the user to include the minimum and the maximum value of the continuous variable in the list of breaks.

{p 8 10 2}{c 149} Creates more descriptive value labels for the generated categorical variable. Users can specify a variable label for the new variable.

{p 8 10 2}{c 149} Allows users working with age or poverty ratio variables to use "default" breaks.


Syntax
------ 

__categorize__ _{varname}_, {opth gen:erate(newvar)} {{opth breaks(numlist)}|{opt default(string)}} [_options_]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
  {synopt:{opth gen:erate(newvar)}}Name of the categorical variable to be generated.{p_end}
  {synopt:{opth breaks(numlist)}}Left-hand ends of the grouping intervals. Do not include the minimum or the maximum value of _varname_. Either __breaks()__ or __default()__ must be specified.{p_end}
  {synopt:{opt default(string)}}Use default breaks; "age" or "povratio". For {opt default("age")}, these are 18 and 65. For {opt default("povratio")}, these are 50, 100, 150, 200, and 250. Cannot be combined with __breaks()__.{p_end}
  {synopt:{opt lblname(string)}}Name of value label to create; default is "{it:varname}_lbl". Ignored if __nolabel__ is specified.{p_end}
  {synopt:{opt nformat(string)}}Numeric format to use in value labels; default is nformat(13.0gc). Ignored if nolabel is specified.{p_end}
  {synopt:{opt nol:abel}}Do not assign value labels to _newvar_.{p_end}
  {synopt:{opt varlab:el(string)}}Variable label for _newvar_.{p_end}
{synoptline}


Example(s)
----------

    Using user-specified breaks.
    
        {bf:. categorize pincp_adj, generate(pincp_cat) breaks(25000 50000 100000)}

    Using default breaks.
    
        {bf:. categorize agep, generate(age_cat) default("age") varlabel("Age group")}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


***/


* capture program drop categorize

program define categorize

  syntax varname(numeric),  ///
    GENerate(name)  ///
    [breaks(numlist sort) default(string)]  ///
    [lblname(string) nformat(string) NOLABel VARLABel(string)]
    
  local varname `varlist'
  
  
  **# Check if newvar already exists ------------------------------------------
  
  local newvar `generate'
  capture confirm `newvar'
  if _rc == 0 {
    display as error "{bf:`newvar'} already defined"
    exit 110
  }
  
  
  **# Define breaks -----------------------------------------------------------
  
  * Find minimum and maximum of varname
  quietly summarize `varname'
  local max = `r(max)' + 1
  local min = `r(min)'
  
  * Validate and expand user-specified breaks
  if "`breaks'" != "" {
    if "`default'" != "" {
      display as error "{bf:breaks()} and {bf:default()} may not be combined"
      exit 184
    }
    
    numlist "`breaks'", range(>`min' <`max')
    local at = "`min' `r(numlist)' `max'"
  }
  
  * Parse default breaks
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
  
  
  **# Generate new variable ---------------------------------------------------
  
  local cuts = ustrregexra("`at'", " ", ", ")
  egen `newvar' = cut(`varname'), at(`cuts') icodes
  quietly replace `newvar' = `newvar' + 1
  
  
  **# Label new variable ------------------------------------------------------
  
  if "`nolabel'" == "" {
    
    local n_cuts : word count `at'
    
    if "`lblname'" == "" {
      local lblname "`newvar'_lbl"
    }
    capture label drop `lblname'
    
    if "`nformat'" == "" {
      local nformat "%13.0gc"
    }
    
    forvalues c = 1/`n_cuts' {
      
      local c_1 = `c' + 1
      local start : word `c' of `at'
      local start = strofreal(`start', "`nformat'")
      local end : word `c_1' of `at'
      
      if `c' < (`n_cuts' - 1) {
        local end = `end' - 1
        local end = strofreal(`end', "`nformat'")
        local to " to"
      }
      if `c' == (`n_cuts' - 1) {
        local end "and up"
        local to ""
      }
      label define `lblname' `c' "`start'`to' `end'", add
    
    }
    
    label values `newvar' `lblname'
  }
  
  if "`varlabel'" != "" {
    label variable `newvar' "`varlabel'"
  }
  
end


