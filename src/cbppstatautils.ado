*! version 0.2.9


/***
Title
====== 

__cbppstatautils__ __{hline 2}__ Stata utility programs for working with ACS and CPS microdata, created by and for researchers at the Center on Budget and Policy Priorities.


Updates
-----------

Run __{stata cbppstatautils, update}__ to update to the latest version.


Contents
-----------

{dlgtab:Data exploration and transformation}

{phang}{help categorize} {hline 2} Create a categorical variable from a continuous one.{p_end}

{phang}{help etotal}  {hline 2}  Flexible counts and totals.{p_end}

{phang}{help inspect_2} {hline 2} Summary statistics for positive, zero, negative, and missing values.{p_end}

{phang}{help label_state} {hline 2} Label a state FIPS code variable with state names or postal abbreviations.{p_end}

{phang}{help labeller} {hline 2}  Create and attach variable and value labels in one step.{p_end}


{dlgtab:Data retrieval}

{phang}{help get_acs_pums} {hline 2} Download ACS microdata files from the Census Bureau FTP and convert them to .dta format.{p_end}

{phang}{help get_cpiu} {hline 2} Load CPI-U or R-CPI-U-RS price index data series into memory or a matrix.{p_end}

{phang}{help load_data} {hline 2} Load data from CBPP's datasets library into memory.{p_end}


{dlgtab:ACS and CPS microdata utilities}

{phang}{help acs_relshipp_to_relp} {hline 2} Recode relshipp to relp in ACS microdata.{p_end}

{phang}{help generate_acs_adj_vars} {hline 2} Adjust income and housing dollar variables with __adjinc__ and __adjhsg__ in ACS microdata.{p_end}

{phang}{help generate_aian_var} {hline 2} Generate an AIAN AOIC variable in ACS or CPS microdata.{p_end}

{phang}{help generate_ind_sect_var} {hline 2} Generate an industry sector variable in ACS or CPS microdata.{p_end}

{phang}{help generate_occ_grp_var} {hline 2} generate an occupation group variable in ACS or CPS microdata.{p_end}

{phang}{help generate_race_var} {hline 2} Generate a race-ethnicity variable in ACS or CPS microdata.{p_end}

{phang}{help label_acs_pums} {hline 2} Label ACS microdata in memory.{p_end}

{phang}{help svyset_acs} {hline 2} Declare the survey design in ACS microdata.{p_end}


{dlgtab:For CBPP staff}

{phang}{help load_data} {hline 2} Load data from CBPP's datasets library into memory.{p_end}

{phang}{help make_cbpp_profile} {hline 2} Set up CBPP's standard profile.do.{p_end}



Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


***/


* capture program drop cbppstatautils

program define cbppstatautils

  syntax, [update]
  
  if "`update'" == "" {
    help cbppstatautils
  }
  
  if "`update'" != "" {
    ado update cbppstatautils, update
    display `"{browse "https://github.com/CenterOnBudget/cbpp-stata-utils/blob/master/NEWS.md":View changelog}"'
  }
  
end


