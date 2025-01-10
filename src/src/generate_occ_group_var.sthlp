{smcl}

{title:Title}

{p 4 4 2}
{bf:generate_occ_group_var} {hline 2} Generate an occupation group variable in ACS or CPS microdata.



{title:Description}

{p 4 4 2}
{bf:generate_occ_group_var} generates a categorial variable for 23 major occupation
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

{p 4 4 2}
The 2-digit SOC codes define 23 occupation groups. The CPS{c 39}s occupation
recode variables {bf:a_dtocc} and {bf:wemocg} define the same 23 groups. In the
ACS, 25 occupation groups are represented by three-letter abbreviations at
the beginning of the occupation variable {bf:occp}{c 39}s value labels.



{title:Syntax}

{p 4 4 2}
{bf:generate_occ_group_var} {newvar}, {opt data:set(string)} [{it:options}]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{space 2}{synopt:{opt data:set(string)}}The type of dataset in memory; ACS or CPS (case insensitive).{p_end}
{space 2}{synopt: {opt job(string)}}With {opt dataset(cps)}, which job to use: "week" for the primary job last week (the default) or "year" for the primary job last year.{p_end}
{space 2}{synopt:{opt nolab:el}}Do not assign value labels to {it:newvar}.{p_end}
{synoptline}



{title:Values and Labels}

{col 5}Value{col 22}Label
{space 4}{hline}
{col 5}11{col 22}Management occupations
{col 5}13{col 22}Business and financial operations occupations
{col 5}15{col 22}Computer and mathematical occupations
{col 5}17{col 22}Architecture and engineering occupations
{col 5}19{col 22}Life, physical, and social science occupations
{col 5}21{col 22}Community and social service occupations
{col 5}23{col 22}Legal occupations
{col 5}25{col 22}Educational instruction and library occupations
{col 5}27{col 22}Arts, design, entertainment, sports, and media occupations
{col 5}29{col 22}Healthcare practitioners and technical occupations
{col 5}31{col 22}Healthcare support occupations
{col 5}33{col 22}Protective service occupations
{col 5}35{col 22}Food preparation and serving related occupations
{col 5}37{col 22}Building and grounds cleaning and maintenance occupations
{col 5}39{col 22}Personal care and service occupations
{col 5}41{col 22}Sales and related occupations
{col 5}43{col 22}Office and administrative support occupations
{col 5}45{col 22}Farming, fishing, and forestry occupations
{col 5}47{col 22}Construction and extraction occupations
{col 5}49{col 22}Installation, maintenance, and repair occupations
{col 5}51{col 22}Production occupations
{col 5}53{col 22}Transportation and material moving occupations
{col 5}55{col 22}Military specific occupations
{space 4}{hline}


{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




