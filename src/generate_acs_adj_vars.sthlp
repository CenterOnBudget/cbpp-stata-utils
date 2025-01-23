{smcl}

{title:Title}

{p 4 4 2}
{bf:generate_acs_adj_vars} {hline 2} Adjust income and housing dollar variables with {bf:adjinc} and {bf:adjhsg} in ACS microdata.



{title:Description}

{p 4 4 2}
{bf:generate_acs_adj_vars} generates adjusted versions of any ACS microdata 
income or housing dollar variables needing adjustment that are found in the 
dataset in memory.

{p 4 4 2}
If income variables are present, the income and earnings inflation factor 
variable {bf:adjinc} must exist. If dollar-denominated housing variables are 
present, the housing dollar inflation factor variable {bf:adjhsg} must exist.
For 2007 and earlier ACS microdata samples, {bf:adjust} must exist and the 
{bf:pre_2008} option must be specified.

{p 4 4 2}
By default, names of the new variables are the original variable names suffixed 
"_adj". Users may supply an alternative variable prefix or suffix.

{p 4 4 2}
By default, variable labels will be copied from the original, deleting the 
phrase referencing the need to apply the adjustment (e.g., "use ADJINC to adjust to constant dollars"), and value labels will be copied from the 
original.



{title:Syntax}

{p 4 4 2}
{bf:generate_acs_adj_vars} [, {it:options}]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{space 2}{synopt:{opt pre:fix(string)}}Prefix to prepend to the new variable names.{p_end}
{space 2}{synopt:{opt suf:fix(string)}}Suffix to append to the new variable names; default is {opt suffix("_adj")}.{p_end}
{space 2}{synopt:{opt nol:abel}}Do not copy variable or value labels to the new variables.{p_end}
{space 2}{synopt:{opt pre_2008}}Indicate that data in memory is pre-2008 ACS microdata.{p_end}
{synoptline}



{title:Example(s)}

    Create adjusted versions of all relevant ACS variables.  

        {bf:. generate_acs_adj_vars}

    Create adjusted versions of all relevant ACS variables, prefixed with "adj_", in pre-2008 ACS microdata.  

        {bf:. generate_acs_adj_vars, prefix("adj_") pre_2008}



{title:Website}

{p 4 4 2}
{browse "https://centeronbudget.github.io/cbpp-stata-utils/":centeronbudget.github.io/cbpp-stata-utils}



