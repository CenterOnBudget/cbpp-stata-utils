{smcl}

{title:Title}

{p 4 4 2}
{bf:categorize} {hline 2} Create a categorical variable.



{title:Description}

{p 4 4 2}
{bf:cagegorize} is a shortcut and extension of {help egen}{c 39}s {it:cut} function with the icodes option.

{p 4 4 2}
Unlike egen cut, {bf:categorize} does not require the user to include the minumum and the maximum value of the continuous variable in the list of breaks. It creates more descriptive value labels for the generated categorical variable. Users can specify a variable label for the new variable. 

{p 4 4 2}
Finally, users working with age or poverty ratio variables may choose "default" breaks. With default(age), breaks are 18 and 65. With default(povratio), breaks are 50, 100, 150, 200, and 250.



{title:Syntax}

{p 8 8 2} {bf:categorize} {it:{help newvar}} ={it:{help varname}}, [{it:options}]

{p 4 4 2}
where {it:{help newvar}} is the name of the categorical variable to be generated and {it:{help varname}} is the name of the continuous variable in memory.


{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
    {synopt:{opth breaks(numlist)}}left-hand ends of the grouping intervals. Do not include the minimum or the maximum value of {it:varname}.{p_end}
	{synopt:{opt default(age|povratio)}}use default breaks. Cannot be combined with the {it:breaks} option.{p_end}
	{synopt:{opt nolab:el}}{it:newvar} will not be given value labels.{p_end}
	{synopt:{opt varlab:el(string)}}variable label for {it:newvar}.{p_end}



{title:Example(s)}

    Generate labelled categorical variable 'income_cat' based on 'pincp'.
        {bf:. categorize inc_cat = pincp, breaks(15000 30000 50000 100000) varlabel("Income category")}

    Generate 'agecat' based on 'agep' with default breaks.
        {bf:. categorize age_cat = agep, default(age)}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


