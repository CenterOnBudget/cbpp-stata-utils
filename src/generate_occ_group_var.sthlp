{smcl}

{title:Title}

{p 4 4 2}
{bf:generate_occ_group_var} {hline 2} Generate an occupation group variable in ACS or CPS microdata.



{title:Description}

{p 4 4 2}
{bf:generate_occ_group_var} generates a categorial variable for major occupation
groups representing 2-digit 
{browse "https://www.bls.gov/soc/2018/major_groups.htm":2018 Standard Occupational Classification System (SOC) codes}.

{p 4 4 2}
In ACS microdata, the variable {bf:occp} must exist. 

{p 4 4 2}
In CPS microdata, by default, the variable {bf:peioocc} must exist and the new 
variable will reflect the primary job worked last week. Users may specify 
{opt job(year)} to indicate the new variable should reflect the longest job 
held last year, in which case {bf:occup} must exist. 

{p 4 4 2}
Not all ACS or CPS data years use the 2018 SOC. This command will not work 
properly for data years that use other SOC versions.



{title:Syntax}

{p 4 4 2}
{bf:generate_occ_group_var} {newvar}, {opt data:set(string)} [{it:options}]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{space 2}{synopt:{opt data:set(string)}}The type of dataset in memory; ACS or CPS (case insensitive).{p_end}
{space 2}{synopt: {opt job(string)}}With {opt dataset(cps)}, which job to use: "week" for the primary job last week (the default) or "year" for the primary job last year. Default is "week".{p_end}
{space 2}{synopt:{opt nolab:el}}Do not assign value labels to {it:newvar}.{p_end}
{synoptline}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




