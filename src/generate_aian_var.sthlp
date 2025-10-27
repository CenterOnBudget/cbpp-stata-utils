{smcl}

{title:Title}

{p 4 4 2}
{bf:generate_aian_var} {hline 2} Generate an AIAN AOIC variable in ACS or CPS microdata.



{title:Description}

{p 4 4 2}
{bf:generate_aian_var} generates a categorical variable for American 
Indian or Alaska Native (AIAN) identification, alone or in combination (AOIC),
regardless of Hispanic or Latino identification. 

{p 4 4 2}
In ACS microdata, the variable {bf:rac1p} must exist. In CPS microdata, the variable 
{bf:prdtrace} must exist.

{p 4 4 2}
{bf:generate_aian_var} should not be used in CPS microdata for calendar years 
before 2012.



{title:Syntax}

{p 4 4 2}
{bf:generate_aian_var} {newvar}, {opt data:set(acs|cps)} [{it:options}]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
	{synopt:{opt data:set(string)}}The type of dataset in memory; ACS or CPS (case insensitive).{p_end}
{space 2}{synopt:{opt nolab:el}}Do not assign value labels to {it:newvar}.{p_end}
{synoptline}



{title:Website}

{p 4 4 2}
{browse "https://centeronbudget.github.io/cbpp-stata-utils/":centeronbudget.github.io/cbpp-stata-utils}



