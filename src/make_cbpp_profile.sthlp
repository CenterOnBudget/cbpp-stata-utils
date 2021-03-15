{smcl}

{title:Title}

{p 4 4 2}
{bf:make_cbpp_profile} {hline 2} Set up CBPP{c 39}s standard profile.do.



{title:Description}

{p 4 4 2}
{bf:make_cbpp_profile} retreives CBPP{c 39}s standard  {browse "https://www.stata.com/support/faqs/programming/profile-do-file/":profile.do} and places it in the user{c 39}s home directory. This command is only useful for CBPP staff. 

{p 4 4 2}
CBPP{c 39}s standard profile.do defines global macros that serve as shortcuts to synched SharePoint and OneDrive folders and cloned GitHub repositories. It also defines a global macro named {c 39}censuskey{c 39} that contains the user{c 39}s Census Bureau API key. Users may specify their API key to {bf:censuskey()} to insert it into the profile.do. If this option is not specified, the {it:censuskey} global will contain placeholder text.



{title:Syntax}

{p 8 8 2} {bf:make_cbpp_profile}, [{it:options}]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
	{synopt:{opt censuskey(string)}}Census Bureau API key.{p_end}
	{synopt:{opt replace}}replace existing profile.do with standard profile.do.{p_end}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}
{it:This help file was dynamically produced by {browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package}.}


