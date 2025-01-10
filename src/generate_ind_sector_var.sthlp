{smcl}

{title:Title}

{p 4 4 2}
{bf:generate_ind_sector_var} {hline 2} Generate an industry sector variable in ACS or CPS microdata.



{title:Description}

{p 4 4 2}
{bf:generate_ind_sector_var} generates a categorial variable for 22 industry sectors representing 2-digit 
{browse "https://www.census.gov/naics/?58967?yearbck=2017":2017 North American Industry Classification System (NAICS) codes}.

{p 4 4 2}
In ACS microdata, the variable {bf:indp} must exist. 

{p 4 4 2}
In CPS microdata, by default, the variable {bf:peioind} must exist and the new 
variable will reflect the primary job worked last week. Users may specify 
{opt job(year)} to indicate the new variable should reflect the longest job 
held last year, in which case {bf:industry} must exist. 

{p 4 4 2}
Not all ACS or CPS data years use the 2017 NAICS. This command will not work 
properly for data years that use other NAICS versions.

{p 4 4 2}
The 2-digit NAICS codes define 22 industry sectors. The CPS{c 39}s major industry 
recode variables {bf:a_mjind} and {bf:wemind} define 14 industry groups. In the 
ACS, 18 industry groups are represented by three-letter abbreviations at the 
beginning of the industry variable {bf:indp}{c 39}s value labels. 



{title:Syntax}

{p 4 4 2}
{bf:generate_ind_sector_var} {newvar}, {opt data:set(string)} [{it:options}]


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
{col 5}11{col 22}Agriculture, forestry, fishing, and hunting
{col 5}21{col 22}Mining, quarrying, and oil and gas extraction
{col 5}22{col 22}Utilities
{col 5}23{col 22}Construction
{col 5}31{col 22}Manufacturing
{col 5}42{col 22}Wholesale trade
{col 5}44{col 22}Retail trade
{col 5}48{col 22}Transportation and warehousing
{col 5}51{col 22}Information
{col 5}52{col 22}Finance and insurance
{col 5}53{col 22}Real estate and rental and leasing
{col 5}54{col 22}Professional, scientific, and technical services
{col 5}55{col 22}Management of companies and enterprises
{col 5}56{col 22}Administrative and support and waste management services
{col 5}61{col 22}Educational services
{col 5}62{col 22}Health care and social assistance
{col 5}71{col 22}Arts, entertainment, and recreation
{col 5}72{col 22}Accommodation and food services
{col 5}81{col 22}Other services, except public administration
{col 5}92{col 22}Public administration
{col 5}928110{col 22}Military
{space 4}{hline}


{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




