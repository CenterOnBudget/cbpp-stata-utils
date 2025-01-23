{smcl}

{title:Title}

{p 4 4 2}
{bf:acs_relshipp_to_relp} {hline 2} Recode {bf:relshipp} to {bf:relp} in ACS microdata.



{title:Description}

{p 4 4 2}
{bf:acs_relshipp_to_relp} converts {bf:relshipp}, the household relationship 
variable in ACS microdata from 2019 to present, to {bf:relp}, the relationship 
variable in earlier samples.

{p 4 4 2}
In a dataset containing only {bf:relshipp}, {bf:acs_relshipp_to_relp} will recode 
{bf:relshipp} to generate {bf:relp}.

{p 4 4 2}
In a dataset containing both {bf:relshipp} and {bf:relp} (for example, a dataset 
formed by appending 2019 or later and 2018 or earlier samples), 
{bf:acs_relshipp_to_relp} will, for observations where {bf:relp} is missing and 
{bf:relshipp} is not, populate {bf:relp} with recoded values of {bf:relshipp}.

{p 4 4 2}
By default, {bf:acs_relshipp_to_relp} will create a value label for {bf:relp} if 
one does not already exist.


{title:Syntax}

{p 4 4 2}
{bf:acs_relshipp_to_relp} [, {opt nolab:el}]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{space 2}{synopt:{opt nolab:el}}Do not assign value labels to {bf:relp}.{p_end}
{synoptline}



{title:Website}

{p 4 4 2}
{browse "https://centeronbudget.github.io/cbpp-stata-utils/":centeronbudget.github.io/cbpp-stata-utils}



