{smcl}

{title:Title}

{p 4 4 2}
{bf:relshipp_to_relp} {hline 2} Convert ACS microdata variable {c 39}relshipp{c 39} to {c 39}relp{c 39}.



{title:Description}

{p 4 4 2}
{bf:relshipp_to_relp} converts {c 39}relshipp{c 39}, the ACS microdata relationship 
variable in 2019 and later samples, to {c 39}relp{c 39}, the relationship variable in 
earlier samples. 

{p 4 4 2}
In a dataset containing only {c 39}relshipp{c 39}, {bf:relshipp_to_relp} will recode 
{c 39}relshipp{c 39} to generate {c 39}relp{c 39}. In a dataset containing both {c 39}relshipp{c 39} and 
{c 39}relp{c 39} (e.g., a dataset formed by appending 2019 or later and 2018 or earlier 
samples), {bf:relshipp_to_relp} will invisibly recode {c 39}relshipp{c 39} and, for 
observations where {c 39}relshipp{c 39} is not missing, copy the contents into {c 39}relp{c 39}. 

{p 4 4 2}
By default, {bf:relshipp_to_relp} will create a value label for {c 39}relp{c 39} if it does
not already exist.


{title:Syntax}

{p 8 8 2} {bf:relshipp_to_relp} , [{cmdab:nolab:el}]



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




