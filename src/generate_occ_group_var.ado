*! version 0.2.9


/***
Title
====== 

__generate_occ_group_var__ {hline 2} Generate an occupation group variable in ACS or CPS microdata.


Description
-----------

__generate_occ_group_var__ generates a categorial variable for major occupation
groups representing 2-digit 
{browse "https://www.bls.gov/soc/2018/major_groups.htm":2018 Standard Occupational Classification System (SOC) codes}.

In ACS microdata, the variable __occp__ must exist. 

In CPS microdata, by default, the variable __peioocc__ must exist and the new 
variable will reflect the primary job worked last week. Users may specify 
{opt job(year)} to indicate the new variable should reflect the longest job 
held last year, in which case __occup__ must exist. 

Not all ACS or CPS data years use the 2018 SOC. This command will not work 
properly for data years that use other SOC versions.


Syntax
------ 

__generate_occ_group_var__ {newvar}, {opt data:set(string)} [_options_]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
  {synopt:{opt data:set(string)}}The type of dataset in memory; ACS or CPS (case insensitive).{p_end}
  {synopt: {opt job(string)}}With {opt dataset(cps)}, which job to use: "week" for the primary job last week (the default) or "year" for the primary job last year.{p_end}
  {synopt:{opt nolab:el}}Do not assign value labels to {it:newvar}.{p_end}
{synoptline}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


***/    


* capture program drop generate_occ_group_var

program define generate_occ_group_var 

  syntax newvarname, DATAset(string) [job(string)] [NOLabel]
  
  local newvar `varlist'
  
  local dataset = lower("`dataset'")
  if !(inlist("`dataset'", "acs", "cps")){
    display as error "{bf:dataset()} must be acs or cps (case insensitive)"
    exit 198
  }
  
  local job = lower(cond("`job'" == "", "week", "`job'"))
  if !inlist("`job'", "week", "year") {
    display as error "{bf:job() must be week or year}"
    exit 198
  }
  
  local occ_var = ///
    cond("`dataset'" == "acs", "occp", cond("`job'" == "week", "peioocc", "occup"))
  confirm variable `occ_var'
  
  recode `occ_var' ///
    (0010/0440 = 11 "Management occupations")  ///
    (0500/0960 = 13 "Business and financial operations occupations")  ///
    (1005/1240 = 15 "Computer and mathematical occupations")  ///
    (1305/1560 = 17 "Architecture and engineering occupations") ///
    (1600/1980 = 19 "Life, physical, and social science occupations") ///
    (2001/2060 = 21 "Community and social service occupations") ///
    (2100/2180 = 23 "Legal occupations")  ///
    (2205/2555 = 25 "Educational instruction and library occupations")  ///
    (2600/2920 = 27 "Arts, design, entertainment, sports, and media occupations") ///
    (3000/3550 = 29 "Healthcare practitioners and technical occupations")  ///
    (3601/3655 = 31 "Healthcare support occupations") ///
    (3700/3960 = 33 "Protective service occupations") ///
    (4000/4160 = 35 "Food preparation and serving related occupations") ///
    (4200/4255 = 37 "Building and grounds cleaning and maintenance occupations")  ///
    (4330/4655 = 39 "Personal care and service occupations")  ///
    (4700/4965 = 41 "Sales and related occupations")  ///
    (5000/5940 = 43 "Office and administrative support occupations")  ///
    (6005/6130 = 45 "Farming, fishing, and forestry occupations") ///
    (6200/6950 = 47 "Construction and extraction occupations")  ///
    (7000/7640 = 49 "Installation, maintenance, and repair occupations")  ///
    (7700/8990 = 51 "Production occupations") ///
    (9005/9760 = 53 "Transportation and material moving occupations") ///
    (9800/9840 = 55 "Military specific occupations"), ///
    generate(`newvar') label(`newvar'_lbl)
    
  if "`dataset'" == "acs" {
    label define `newvar'_lbl 9920 "Unemployed, with no work experience in the last 5 years or earlier or never worked", add
  }
  if "`dataset'" == "cps" {
    label define `newvar'_lbl -1 "Not in universe or children", add
  }
  
  if "`nolabel'" != "" {
    label drop `newvar'_lbl
  }

end
