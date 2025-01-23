{smcl}

{title:Title}

{p 4 4 2}
{bf:label_state} {hline 2} Label a state FIPS code variable with state names or postal abbreviations.



{title:Description}

{p 4 4 2}
label_state attaches value labels to a variable containing 
{browse "https://www.census.gov/library/reference/code-lists/ansi/ansi-codes-for-states.html":state FIPS codes}. Value labels are the full state name by default. The 50 states, the 
District of Columbia, Puerto Rico, and U.S. territories are supported.

{p 4 4 2}
If the state FIPS code variable in {it:varname} is a string, it will be destringed.



{title:Syntax}

{p 4 4 2}
{bf:label_state} {varname} [, {it:options}]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{space 2}{synopt:{opt abbrv}}Use state postal abbreviations rather than state names (the default) for value labels.{p_end}
{synoptline}



{title:Website}

{p 4 4 2}
{browse "https://centeronbudget.github.io/cbpp-stata-utils/":centeronbudget.github.io/cbpp-stata-utils}



