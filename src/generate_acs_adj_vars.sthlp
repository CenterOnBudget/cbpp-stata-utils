{smcl}

{title:Title}

{p 4 4 2}
{bf:generate_acs_adj_vars} {hline 2} Generate versions of ACS microdata{c 39}s income and housing variables appropriately adjusted by {c 39}adjinc{c 39} or {c 39}adjhsg{c 39}.



{title:Description}

{p 4 4 2}
{bf:generate_acs_adj_vars} generates adjusted versions of all of the income or housing variables needing adjustment that are found in the user{c 39}s dataset.

{p 4 4 2}
Adjusted versions of variables are named as the original with the suffix "_adj" by default (e.g. {bf:pincp_adj_}), or users may supply a prefix or suffix. 

{p 4 4 2}
See the  {browse "https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/PUMSDataDict16.pdf?#":ACS PUMS data dictionary} for a list of variables to which {c 39}adjinc{c 39} or {c 39}adjhsg{c 39} are applied. In the 2005-2007 PUMS samples, a single adjustment factor, {c 39}adjust{c 39}, is used for both income and housing variables. If using PUMS samples from those years, use the {bf:pre_2008} option to specify that variables should be adjusted using {c 39}adjust{c 39}.



{title:Syntax}

{p 8 8 2} {bf:generate_acs_adj_vars} , [{bf:prefix({it:string}) suffix({it:string}) pre_2008}]

{synopthdr}
{synopt:{opt pre:fix(string)}}prefix to prepend to the variable name.{p_end}
{synopt:{opt suf:fix(string)}}suffix to append to the or variable name. Defaults to "_adj".{p_end}



{title:Example(s)}

    Create adjusted versions of all relevant ACS variables.  
        {bf:. generate_acs_adj_vars}

    Create adjusted versions of all relevant ACS variables, prefixed with "adj", in a pre-2008 PUMS sample.  
        {bf:. generate_acs_adj_vars, prefix(adj) pre_2008}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


