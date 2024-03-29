*! version 0.2.0


/***
Title
====== 

__generate_acs_adj_vars__ {hline 2} Generate versions of ACS microdata's income and housing variables appropriately adjusted by 'adjinc' or 'adjhsg'.


Description
-----------

__generate_acs_adj_vars__ generates adjusted versions of all of the income or 
housing variables needing adjustment that are found in the user's dataset.
 
Adjusted versions of variables are named as the original with the suffix "_adj" 
by default (e.g. "pincp_adj"), or users may supply a prefix or suffix. 

Variable labels will be copied from the original, excluding the phrase 
referencing the need to apply the adjustment (e.g., "use ADJINC to adjust to 
adjust to constant dollars"). Value labels will be copied from the original. 
Specify the __nolabel__ option to skip copying variable and value labels.

See the 
[ACS PUMS data dictionary](https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/PUMSDataDict16.pdf) 
for a list of variables to which 'adjinc' or 'adjhsg' are applied. In the 2
005-2007 PUMS samples, a single adjustment factor, 'adjust', is used for both 
income and housing variables. If using PUMS samples from those years, use the 
__pre_2008__ option to specify that variables should be adjusted using 'adjust'.


Syntax
------ 

> __generate_acs_adj_vars__ , [__prefix(_string_) suffix(_string_) pre_2008__]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt pre:fix(string)}}prefix to prepend to the variable names.{p_end}
{synopt:{opt suf:fix(string)}}suffix to append to the variable names; default is {bf:suffix(}{it:_adj}{bf:)}.{p_end}
{synopt:{opt nol:abel}}do not copy variable and value labels from the originals.{p_end}
{synopt:{opt pre_2008}}data is from the 2005-2007 samples.{p_end}


Example(s)
----------

    Create adjusted versions of all relevant ACS variables.  
        {bf:. generate_acs_adj_vars}

    Create adjusted versions of all relevant ACS variables, prefixed with "adj", in a pre-2008 PUMS sample.  
        {bf:. generate_acs_adj_vars, prefix(adj) pre_2008}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


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


