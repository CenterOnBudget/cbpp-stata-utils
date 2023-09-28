{smcl}

{title:Title}

{p 4 4 2}
{bf:make_cbpp_profile} {hline 2} Set up CBPP{c 39}s standard profile.do.



{title:Description}

{p 4 4 2}
{bf:make_cbpp_profile} creates CBPP{c 39}s standard
{browse "https://www.stata.com/support/faqs/programming/profile-do-file/":profile.do}
in the user{c 39}s home directory. This command is only useful for CBPP staff. 

{p 4 4 2}
CBPP{c 39}s standard profile.do defines global macros that serve as shortcuts to 
synched SharePoint and OneDrive folders and cloned GitHub repositories. 

{p 4 4 2}
Users may also add the following to the standard profile.do:

{p 8 8 2}{c 149}  Census Bureau API key to for use by the  {browse "https://centeronbudget.github.io/getcensus/":getcensus} package, stored as a global macro named {c 39}censuskey{c 39}{p_end}

{p 8 8 2}{c 149}  Path to the user{c 39}s Rscript excutable for use by the  {browse "https://github.com/reifjulian/rscript":rscript} package, stored as a global macro named {c 39}RSCRIPT_PATH{c 39}{p_end}



{title:Syntax}

{p 8 8 2} {bf:make_cbpp_profile}, [{it:options}]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
	{synopt:{opt censuskey(string)}}Census Bureau API key.{p_end}
{space 2}{synopt:{opt rscript(string)}}Path to the user{c 39}s Rscript executable.{p_end}
	{synopt:{opt replace}}replace existing profile.do.{p_end}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




