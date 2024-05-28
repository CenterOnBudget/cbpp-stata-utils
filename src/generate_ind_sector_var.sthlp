{smcl}

{title:Title}

{p 4 4 2}
{bf:generate_ind_sector_var} {hline 2} Generate an industry sector variable in ACS or CPS microdata.



{title:Description}

{p 4 4 2}
{bf:generate_ind_sector_var} generates a categorial variable for industry sectors representing 2-digit 
{browse "https://www.census.gov/naics/?58967?yearbck=2017":2017 North American Industry Classification System (NAICS) sectors}.

{p 4 4 2}
For ACS microdata, the variable {bf:indp} must exist. For CPS microdata, the 
variable {bf:peioind} must exist.

{p 4 4 2}
Not all ACS or CPS data years use the 2017 NAICS. This command will not work properly for data years that use other NAICS versions.



{title:Syntax}

{p 4 4 2}
{bf:generate_ind_sector_var} {newvar}, {opt data:set(string)} [{it:options}]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{space 2}{synopt:{opt data:set(string)}}The type of dataset in memory; ACS or CPS (case insensitive).{p_end}
{space 2}{synopt:{opt }}
{space 2}{synopt:{opt nolab:el}}Do not assign value labels to {it:newvar}.{p_end}
{synoptline}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




