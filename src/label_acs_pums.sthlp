{smcl}

{title:Title}

{p 4 4 2}
{bf:label_acs_pums} {hline 2} Label ACS microdata in memory.



{title:Description}

{p 4 4 2}
{bf:label_acs_pums} labels 
{browse "https://www.census.gov/programs-surveys/acs/microdata.html":American Community Survey public use microdata}
in memory using information retrieved from the ACS PUMS data dictionaries.

{p 4 4 2}
Only 2013 and later ACS microdata are supported.

{p 4 4 2}
By default, the data dictionaries and intermediate labeling .do files are 
cached. Specify {bf:use_cache} to use the cached files rather than re-downloading
and re-generating them.

{p 4 4 2}
Variable and value labels generated by {bf:label_acs_pums} are not a substitute 
for the ACS microdata data dictionary. Labels may be truncated and some 
important information may be missing.



{title:Syntax}

{p 4 4 2}
{bf:label_acs_pums}, {opt year(integer)} [{it:options}]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{space 2}{synopt:{opt year(integer)}}Year of dataset in memory; 2013 or later.{p_end}
{space 2}{synopt:{opt sample(integer)}}Sample of dataset in memory; 1 for the 1-year sample (the default) or 5 for the 5-year sample.{p_end}
{space 2}{synopt:{opt use_cache}}Use data from the cache if it exists. An internet connection is required when {bf:use_cache} is not specified or cached data does not exist.{p_end}
{synoptline}



{title:Website}

{p 4 4 2}
{browse "https://centeronbudget.github.io/cbpp-stata-utils/":centeronbudget.github.io/cbpp-stata-utils}



