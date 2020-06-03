{smcl}

{title:Title}

{p 4 4 2}
{bf:cbppstatautils} {bf:{hline 2}} Stata utility programs for working with ACS and CPS microdata, created by and for researchers at the Center on Budget and Policy Priorities.


{title:Updates}

{p 4 4 2}
Run {bf:__{stata cbppstatautils, update}__} to update to the latest version.


{title:Contents}

{p 8 8 2} {bf:{help load_data}} : Load CPS or ACS microdata from the CBPP datasets library into memory.

{p 8 8 2} {bf:{help get_acs_pums}} : Retrieve ACS PUMS files from the Census Bureau FTP.

{p 8 8 2} {bf:{help make_acs_pums_lbls}} : Generate .do files to label ACS PUMS data.

{p 8 8 2} {bf:{help generate_acs_adj_vars}} : Generate adjusted versions of ACS PUMS income and housing variables using {c 39}adjinc{c 39} and {c 39}adjhsg{c 39}.

{p 8 8 2} {bf:{help generate_acs_major_group}} : Generate categorical variable for major industry and/or occupation groups in ACS PUMS data.

{p 8 8 2} {bf:{help generate_race_var}} : Generate categorical variable for race/ethnicity in CPS or ACS microdata.

{p 8 8 2} {bf:{help label_state}} : Label a numeric state FIPS code variable with state names or postal abbreviations.

{p 8 8 2} {bf:{help get_cpiu}} : Retrieve annual CPI-U or CPI-U-RS series as a dataset, variable, or matrix.



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


