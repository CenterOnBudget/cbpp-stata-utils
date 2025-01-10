*! version 0.2.0


/***
Title
====== 

__generate_acs_adj_vars__ {hline 2} Adjust income and housing dollar variables with __adjinc__ and __adjhsg__ in ACS microdata.


Description
-----------

__generate_acs_adj_vars__ generates adjusted versions of any ACS microdata 
income or housing dollar variables needing adjustment that are found in the 
dataset in memory.

If income variables are present, the income and earnings inflation factor 
variable __adjinc__ must exist. If dollar-denominated housing variables are 
present, the housing dollar inflation factor variable __adjhsg__ must exist.
For 2007 and earlier ACS microdata samples, __adjust__ must exist and the 
__pre_2008__ option must be specified.

By default, names of the new variables are the original variable names suffixed 
"_adj". Users may supply an alternative variable prefix or suffix.

By default, variable labels will be copied from the original, deleting the 
phrase referencing the need to apply the adjustment (e.g., "use ADJINC to adjust to constant dollars"), and value labels will be copied from the 
original.


Syntax
------ 

__generate_acs_adj_vars__ [, _options_]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
  {synopt:{opt pre:fix(string)}}Prefix to prepend to the new variable names.{p_end}
  {synopt:{opt suf:fix(string)}}Suffix to append to the new variable names; default is {opt suffix("_adj")}.{p_end}
  {synopt:{opt nol:abel}}Do not copy variable or value labels to the new variables.{p_end}
  {synopt:{opt pre_2008}}Indicate that data in memory is pre-2008 ACS microdata.{p_end}
{synoptline}


Example(s)
----------

    Create adjusted versions of all relevant ACS variables.  
    
        {bf:. generate_acs_adj_vars}

    Create adjusted versions of all relevant ACS variables, prefixed with "adj_", in pre-2008 ACS microdata.  
    
        {bf:. generate_acs_adj_vars, prefix("adj_") pre_2008}


Website
-------

[centeronbudget.github.io/cbpp-stata-utils](https://centeronbudget.github.io/cbpp-stata-utils/)

***/


* capture program drop generate_acs_adj_vars

program define generate_acs_adj_vars

  syntax , [PREfix(string) SUFfix(string) NOLabel pre_2008]
  
  
  * checks ------------------------------------------------------------------
  
  if "`prefix'" != "" & "`suffix'" != "" {
    display as error "{bf:prefix()} and {bf:suffix()} cannot be combined"
    exit 184
  }
  
  if "`prefix'" == "" & "`suffix'" == "" {
    local prefix ""
    local suffix "_adj"
  }
  
  
  * define adjustment variables and variables needing adjustment ------------
  
  local adj_inc = cond("`pre_2008'" == "", "adjinc", "adjust")
  local adj_hsg = cond("`pre_2008'" == "", "adjhsg", "adjust")
  
  local inc_vars "pincp pernp wagp ssp ssip intp pap oip retp semp fincp hincp"
  local hous_vars "conp elep fulp gasp grntp insp mhp mrgp smocp rntp smp watp taxamt"
  
  
  * generate adjusted variables ---------------------------------------------
  
  local cmd = cond("`nolabel'" == "", "clonevar", "quietly generate")
  
  foreach var of local inc_vars {
    capture confirm variable `var'
    local newvar = "`prefix'`var'`suffix'"
    if _rc == 0 {
      // redundant to confirm `adj_*' every loop, but how else to do it without 
      // asking the user to specify the record type of data in memory...
      confirm variable `adj_inc'  
      `cmd' `newvar' = `var'
      quietly replace `newvar' = `newvar' * `adj_inc' / 1000000 
      if "`nolabel'" == "" {
        quietly notes drop `newvar'
        // remove "use ADJINC to adjust..." from variable label
        local lbl : variable label `newvar'
        local lbl = ustrregexra("`lbl'", "\(?use ADJINC(.*)$", "")
        local lbl = ustrregexra("`lbl'", "(, )$", ")")
        label variable `newvar' "`lbl'"
      }
    }
  }
  
  foreach var of local hous_vars {
    capture confirm variable `var'
    local newvar = "`prefix'`var'`suffix'"
    if _rc == 0 {
      confirm variable `adj_hsg'  
      `cmd' `newvar' = `var'
      quietly replace `newvar' = `newvar' * `adj_hsg' / 1000000 
      if "`nolabel'" == "" {
        quietly notes drop `newvar'
        // remove "use ADJHSG to adjust..." from variable label
        local lbl : variable label `newvar'
        local lbl = ustrregexra("`lbl'", "\(?use ADJHSG(.*)$", "")
        local lbl = ustrregexra("`lbl'", "(, )$", ")")
        label variable `newvar' "`lbl'"
      }
    }
  }

end


