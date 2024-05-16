*! version 0.2.9


/***
Title
====== 

__generate_ind_sect_var__ {hline 2} Generate an industry sector variable in ACS or CPS microdata.


Description
-----------

__generate_ind_sect_var__ generates a categorial variable for industry sectors representing 2-digit 
{browse "https://www.census.gov/naics/?58967?yearbck=2017":2017 North American Industry Classification System (NAICS) sectors}.

For ACS microdata, the variable __indp__ must exist. For CPS microdata, the 
variable __peioind__ must exist.

Not all ACS or CPS data years use the 2017 NAICS. This command will not work properly for data years that use other NAICS versions.


Syntax
------ 

__generate_ind_sect_var__ {newvar}, {opt data:set(string)} [_options_]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
  {synopt:{opt data:set(string)}}The type of dataset in memory; ACS or CPS (case insensitive).{p_end}
  {synopt:{opt nolab:el}}Do not assign value labels to {it:newvar}.{p_end}
{synoptline}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


***/    


* capture program drop generate_ind_sect_var

program define generate_ind_sect_var 

  syntax newvarname, DATAset(string) [NOLabel]
  
  local newvar `varlist'
  
  local dataset = lower("`dataset'")
  if !(inlist("`dataset'", "acs", "cps")){
    display as error "{bf:dataset()} must be acs or cps (case insensitive)"
    exit 198
  }
  
  local ind_var = cond("`dataset'" == "acs", "indp", "peioind")
  confirm variable `ind_var'
  
  recode `ind_var' ///
    (0170/0290 = 11 "Agriculture, forestry, fishing, and hunting")  ///
    (0370/0490 = 21 "Mining, quarrying, and oil and gas extraction")  ///
    (0770      = 23 "Construction") ///
    (1070/3990 = 31 "Manufacturing") /* NAICS 31-33 */ ///
    (4070/4590 = 42 "Wholesale trade")  ///
    (4670/5790 = 44 "Retail trade") /* NAICS 44-45 */  ///
    (6070/6390 = 48 "Transportation and warehousing") /* NAICS 48-49 */  ///
    (0570/0690 = 22 "Utilities")  ///
    (6470/6780 = 51 "Information")  ///
    (6870/6992 = 52 "Finance and insurance")  ///
    (7071/7190 = 53 "Real estate and rental and leasing") ///
    (7270/7490 = 54 "Professional, scientific, and technical services") ///
    (7570      = 55 "Management of companies and enterprises") ///
    (7580/7790 = 56 "Administrative and support and waste management services") ///
    (7860/7890 = 61 "Educational services") ///
    (7970/8470 = 62 "Health care and social assistance")  ///
    (8561/8590 = 71 "Arts, entertainment, and recreation") ///
    (8660/8690 = 72 "Accommodation and food services")  ///
    (8770/9290 = 81 "Other services, except public administration") ///
    (9370/9590 = 92 "Public administration")  ///
    (9670/9890 = 928110 "Military"),  ///
    generate(`newvar') label(`newvar'_lbl)
    
  if "`dataset'" == "acs" {
    label define `newvar'_lbl 9920 "Unemployed, with no work experience in the last 5 years or earlier or never worked", add
  }
  if "`dataset'" == "cps" {
    label define `newvar'_lbl 0 "Not in universe or children", add
  }
  
  if "`nolabel'" != "" {
    label drop `newvar'_lbl
  }

end
