{smcl}

{title:Title}

{p 4 4 2}
{bf:cbppstatautils} {bf:{hline 2}} Stata utility programs for working with ACS and CPS microdata, created by and for researchers at the Center on Budget and Policy Priorities.



{title:Updates}

{p 4 4 2}
Run {bf:{stata cbppstatautils, update}} to update to the latest version.



{title:Contents}

{dlgtab:Data exploration and transformation}

{phang}{help categorize} {hline 2} Create a categorical variable from a continuous one.{p_end}

{phang}{help etotal}  {hline 2}  Flexible counts and totals.{p_end}

{phang}{help inspect_2} {hline 2} Summary statistics for positive, zero, negative, and missing values.{p_end}

{phang}{help label_state} {hline 2} Label a state FIPS code variable with state names or postal abbreviations.{p_end}

{phang}{help labeller} {hline 2}  Create and attach variable and value labels in one step.{p_end}


{dlgtab:Data retrieval}

{phang}{help get_acs_pums} {hline 2} Download ACS microdata files from the Census Bureau FTP and convert them to .dta format.{p_end}

{phang}{help get_cpiu} {hline 2} Load CPI-U or R-CPI-U-RS price index data series into memory or a matrix.{p_end}

{phang}{help load_data} {hline 2} Load data from CBPP{c 39}s datasets library into memory.{p_end}

{phang}{help copy_curl} {hline 2} Copy file from URL using curl.{p_end}


{dlgtab:ACS and CPS microdata utilities}

{phang}{help acs_relshipp_to_relp} {hline 2} Recode relshipp to relp in ACS microdata.{p_end}

{phang}{help generate_acs_adj_vars} {hline 2} Adjust income and housing dollar variables with {bf:adjinc} and {bf:adjhsg} in ACS microdata.{p_end}

{phang}{help generate_aian_var} {hline 2} Generate an AIAN AOIC variable in ACS or CPS microdata.{p_end}

{phang}{help generate_ind_sector_var} {hline 2} Generate an industry sector variable in ACS or CPS microdata.{p_end}

{phang}{help generate_occ_group_var} {hline 2} generate an occupation group variable in ACS or CPS microdata.{p_end}

{phang}{help generate_race_var} {hline 2} Generate a race-ethnicity variable in ACS or CPS microdata.{p_end}

{phang}{help label_acs_pums} {hline 2} Label ACS microdata in memory.{p_end}

{phang}{help svyset_acs} {hline 2} Declare the survey design in ACS microdata.{p_end}


{dlgtab:For CBPP staff}

{phang}{help load_data} {hline 2} Load data from CBPP{c 39}s datasets library into memory.{p_end}

{phang}{help make_cbpp_profile} {hline 2} Set up CBPP{c 39}s standard profile.do.{p_end}




{title:Website}

{p 4 4 2}
{browse "https://centeronbudget.github.io/cbpp-stata-utils/":centeronbudget.github.io/cbpp-stata-utils}




