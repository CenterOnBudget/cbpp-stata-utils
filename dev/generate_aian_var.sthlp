{smcl}

{title:Title}

{p 4 4 2}
{bf:generate_aian_var} {hline 2} Generate categorical AI/AN variable for CPS or ACS microdata.



{title:Description}

{p 4 4 2}
{bf:generate_aian_var} generates a categorial variable for American Indian/Alaska Native (AI/AN) identification. It can be used with CPS or ACS microdata.

{p 4 4 2}
This variable is the preferred universe for presenting Census data intended to represent the Native American population. For more information, see  {browse "www.cbpp.org":link to document}.



{title:Syntax}

{p 4 4 2}
{bf:generate_aian_var} {it:{help newvar}}, [{it:options}]


{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Required}
	{synopt:{opt data:set(string)}}CPS or ACS (case insensitive).{p_end}
	
{syntab:Optional}
    {synopt:{opt no_label}}{it:newvar} will not be labelled.{p_end}
    {synopt:{opt replace}}{it:newvar} will be replaced if it exists.{p_end}

	

{title:Example(s)}

{space 3}Generate a variable named "aian" for ACS microdata.
        {bf:. generate_aian_var aian, dataset(acs)}
		
		

{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


