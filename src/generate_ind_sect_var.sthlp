{smcl}

{title:Title}

{p 4 4 2}
{bf:generate_ind_sect_var} {hline 2} Generate categorical industry sector 
variable for CPS or ACS microdata.



{title:Description}

{p 4 4 2}
{bf:generate_ind_sect_var} generates a categorial variable for industry sectors representing 2-digit {browse "https://www.census.gov/naics/?58967?yearbck=2017":2017 North American Industry Classification System (NAICS) sectors}. It can be used 
with ACS or CPS microdata.

{p 4 4 2}
Note that not all ACS or CPS data years use the 2017 NAICS. This command won{c 39}t work properly for data years that use other NAICS versions.



{title:Syntax}

{p 4 4 2}
{bf:generate_ind_sect_var} {it:{help newvar}}, {bf:{cmdab:data:set}({it:string})} [{it:options}]


{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Required}
{space 2}{synopt:{opt data:set(string)}}ACS or CPS (case insensitive).{p_end}

{syntab:Optional}
{space 2}{synopt:{opt nolab:el}}{it:newvar} will not be labelled.{p_end}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




