{smcl}

{title:Title}

{p 4 4 2}
{bf:make_cbpp_profile} {hline 2} Set up CBPP{c 39}s standard profile.do.



{title:Description}

{p 4 4 2}
make_cbpp_profile creates CBPP{c 39}s standard  {browse "https://www.stata.com/support/faqs/programming/profile-do-file/":profile.do} 
in the user{c 39}s home directory.

{p 4 4 2}
This command is only useful for CBPP staff.

{p 4 4 2}
CBPP{c 39}s standard profile.do defines global macros that serve as shortcuts to 
synced cloud folders and cloned GitHub repositories:

{p 8 10 2}{c 149} {bf:odpath} – Path to the user{c 39}s OneDrive, "C:/Users/{username}/OneDrive - Center on Budget and Policy Priorities

{p 8 10 2}{c 149} {bf:sppath} – Path to the directory for synced SharePoint folders, "C:/Users/{username}/Center on Budget and Policy Priorities

{p 8 10 2}{c 149} {bf:spdatapath} – Start of path to a synced datasets libraries, "C:/Users/{username}/Center on Budget and Policy Priorities/Datasets - 

{p 8 10 2}{c 149} {bf:ghpath} – Path to cloned GitHub repositories, "C:/Users/{username}/Documents/GitHub

{p 4 4 2}
It also contains global macros for use by other cbppstatautils commands:

{p 8 10 2}{c 149} {bf:BLS_USER_AGENT} User{c 39}s CBPP email address, "{username}@cbpp.org", to enable {help get_cpiu} to download from the BLS website.

{p 4 4 2}
Users may optionally add the following to the standard profile.do:

{p 8 10 2}{c 149} Census Bureau API key to for use by the  {browse "https://centeronbudget.github.io/getcensus/":getcensus} package, to be stored as global macro {bf:censuskey}.

{p 8 10 2}{c 149} Path to the user{c 39}s Rscript excutable for use by the  {browse "https://github.com/reifjulian/rscript":rscript} package, to be stored as global macro {bf:RSCRIPT_PATH}.

{p 4 4 2}
The standard profile.do includes {bf:set more off, permanently}.



{title:Syntax}

{p 4 4 2}
{bf:make_cbpp_profile} [, {it:options}]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{space 2}{synopt:{opt censuskey(string)}}Census Bureau API key.{p_end}
{space 2}{synopt:{opt rscript(string)}}Path to the Rscript executable; typically "C:/Users/{username}/AppData/Local/Programs/R/R-{version}/bin/Rscript.exe".{p_end}
{space 2}{synopt:{opt replace}}Replace existing profile.do.{p_end}
{synoptline}



{title:Website}

{p 4 4 2}
{browse "https://centeronbudget.github.io/cbpp-stata-utils/":centeronbudget.github.io/cbpp-stata-utils}



