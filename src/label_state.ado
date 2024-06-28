*! version 0.2.0


/***
Title
====== 

__label_state__ {hline 2} Label a state FIPS code variable with state names or postal abbreviations.


Description
-----------

label_state attaches value labels to a variable containing 
[state FIPS codes](https://www.census.gov/library/reference/code-lists/ansi/ansi-codes-for-states.html). Value labels are the full state name by default. The 50 states, the 
District of Columbia, Puerto Rico, and U.S. territories are supported.

If the state FIPS code variable in _varname_ is a string, it will be destringed.


Syntax
------ 

__label_state__ {varname} [, _options_]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
  {synopt:{opt abbrv}}Use state postal abbreviations rather than state names (the default) for value labels.{p_end}
{synoptline}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


***/


* capture program drop label_state

program label_state

  syntax varname, [abbrv]

  * Destring varname
  capture confirm string `varlist' 
  if _rc != 0 {
    quietly destring `varlist', replace 
  }
  
  * Drop state_lbl if it exists
  capture label drop state_lbl      
  
  * Construct value labels from state_fips dataset
  preserve
  sysuse state_fips, clear
  local lbl_content_var = cond("`abbrv'" == "", "state_name", "state_abbrv")
  generate lbl =  ///
    "label define state_lbl " + state_fips + " " +  ///
    `"""' + `lbl_content_var' + `"""' + ", add "
  quietly levelsof lbl, local(lbls)
  
  * Define and apply value label
  restore
  foreach l of local lbls {
    `l'
  }
  label values `varlist' state_lbl
  
end


