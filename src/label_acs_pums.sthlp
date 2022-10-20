{smcl}

{title:Title}

{p 4 4 2}
{bf:label_acs_pums} {hline 2} Label American Community Survey PUMS data.



{title:Description}

{p 4 4 2}
{bf:label_acs_pums} labels American Community Survey 
{browse "https://www.census.gov/programs-surveys/acs/technical-documentation/pums.html":public use microdata}
using information compiled from the ACS PUMS 
{browse "https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/":data dictionaries}.

{p 4 4 2}
The program automatically caches the retrived data dictionary and labels. To 
avoid downloading and generating the files each time, specify the 
{bf:use_cache} option. If you do not specify {bf:use_cache}, or if you have never
run {bf:label_acs_pums} for the year and sample specified, you must be connected
to the internet to use this program.

{p 4 4 2}
The variable and value labels generated by this program are not a substitute for
the original data dictionary: they may be truncated and some important notes may
be excluded.



{title:Syntax}

{p 8 8 2} {bf:label_acs_pums}, {bf:year({it:integer})} [{it:options}]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
	{synopt:{opt year(integer)}}2013 to 2021.{p_end}

{syntab:Optional}
    {synopt:{opt sample(integer)}}5 for the five-year sample or 1 for the one-year sample; default is {opt sample(1)}.{p_end}
    {synopt:{opt use_cache}}use cached dictionary and label files (recommended).{p_end}



{title:Example(s)}

    Label the 2018 one-year sample, not using cached files. 
        {bf:. label_acs_pums, year(2018)}

    Label the 2014 five-year sample, using cached files.
        {bf:. label_acs_pums, year(2014) sample(5) use_cache}

		

{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




