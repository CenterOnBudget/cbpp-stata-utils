{smcl}

{title:Title}

{p 4 4 2}
{bf:generate_acs_major_group} {hline 2} Generate categorical variable for major industry and/or occupation groups in American Community Survey PUMS data.



{title:Description}

{p 4 4 2}
{bf:generate_acs_major_group} generates a categorical variable for major industry and major occupation groups in American Community Survey  {browse "https://www.census.gov/programs-surveys/acs/technical-documentation/pums.html":public use microdata} by recoding {c 39}occp{c 39} and {c 39}indp{c 39}. 

{p 4 4 2}
The program takes the value labels for {c 39}occp{c 39} and {c 39}indp{c 39} from the ACS PUMS  {browse "https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/":data dictionaries} and uses them to recode these variables into major groups. For instance, {c 39}occp{c 39} values 9370 through 9590 are recoded to 1 and labelled "ADM", values 0170 through 0290 are recoded to 2 and labelled "AGR", and so on. 

{p 4 4 2}
Generated major group variables are named as the original with the prefix "maj_" by default. Users may supply another prefix to the {it:prefix} option.

{p 4 4 2}
By default, the program will attempt to confirm and generate a major group variable for both {c 39}indp{c 39} and {c 39}occp{c 39}. Users wishing to use only one the variables should pass its name to {it:varname}.

{p 4 4 2}
The program automatically caches the ACS PUMS data dictionary. Users can load cached data by specifying the {it:use_cache} option (recommended).

{p 4 4 2}
More information on the Census Bureau{c 39}s industry and occupation codes, including comparability over time and to NAICS and SOC codes, respectively, can be found in the Code List section of the  {browse "https://www.census.gov/programs-surveys/acs/technical-documentation/pums.html":ACS PUMS technical documentation} and on the  {browse "https://www.census.gov/topics/employment/industry-occupation/guidance.html":Guidance for Industry & Occupation Data Users} page on the Census Bureau website.



{title:Syntax}

{p 8 8 2} {bf:generate_acs_major_group} {bf:[{it:{help varname}}]}, {bf:year({it:integer})} [{it:options}]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
	{synopt:{opt year(integer)}}2013 to 2018.{p_end}
	
{syntab:Optional}
    {synopt:{opt sample(integer)}}5 for the five-year sample or 1 for the one-year sample; default is {bf:sample(1)}.{p_end}
	{synopt:{opt pre:fix(string)}}prefix to prepend to the variable name; default is {bf:prefix(maj})}.{p_end}
	{synopt:{opt use_cache}}use cached data dictionary file (recommended).{p_end}



{title:Example(s)}

    Generate categorical variables for major industry and occupation groups 
	in the 2018 one-year sample.
        {bf:. generate_acs_major_group, year(2018) use_cache}

{space 3}Generate a categorical variable for major industry groups named {c 39}grouped_indp{c 39} 
{space 3}in the 2016 five-yer sample.
        {bf:. generate_acs_major_group indp, year(2016) sample(5) prefix(grouped_) use_cache}

		

{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}
{it:This help file was dynamically produced by {browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package}.}


