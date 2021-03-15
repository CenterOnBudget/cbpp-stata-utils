{smcl}

{title:Title}

{p 4 4 2}
{bf:generate_aian_var} {hline 2} Generate categorical AI/AN variable for CPS or ACS microdata.



{title:Description}

{p 4 4 2}
{bf:generate_aian_var} generates a categorial variable for American Indian/Alaska Native (AI/AN) identification, alone or in combination, regardless of Hispanic identification. It can be used with CPS (calendar year 2012 and later) or ACS microdata.



{title:Syntax}

{p 4 4 2}
{bf:generate_aian_var} {it:{help newvar}}, [{it:options}]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Required}
	{synopt:{opt data:set(string)}}CPS or ACS (case insensitive).{p_end}
	
{syntab:Optional}
    {synopt:{opt nolab:el}}{it:newvar} will not be labelled.{p_end}

	

{title:Example(s)}

{space 3}Generate a variable named {c 39}aian{c 39} for ACS microdata.
        {bf:. generate_aian_var aian, dataset(acs)}
		
		

{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}
{it:This help file was dynamically produced by {browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package}.}


