{smcl}

{title:Title}

{p 4 4 2}
{bf:categorize} {hline 2} Create a categorical variable.



{title:Description}

{p 4 4 2}
{bf:categorize} is a shortcut and extension of {help egen}{c 39}s {it:cut} function with 
the icodes option.

{p 4 4 2}
Unlike egen cut:    {break}
{bf:categorize} does not require the user to include the minumum and the maximum 
value of the continuous variable in the list of breaks.    {break}
It creates more descriptive value labels for the generated categorical variable.    {break}
Users can specify a variable label for the new variable.

{p 4 4 2}
Finally, users working with age or poverty ratio variables may choose "default" 
breaks. With {opt default(age)}, breaks are 18 and 65. With 
{opt default(povratio)}, breaks are 50, 100, 150, 200, and 250.



{title:Syntax}

{p 8 8 2} {bf:categorize} {it:{help varname}}, {cmdab:gen:erate}({it:{help newvar}}) [{it:options}]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
    {synopt:{opth gen:erate(newvar)}}name of the categorical variable to be generated.{p_end}

{syntab:Optional}
    {synopt:{opth breaks(numlist)}}left-hand ends of the grouping intervals. Do not include the minimum or the maximum value of {it:varname}. Either {opt breaks()} or {opt default()} must be specified.{p_end}
	{synopt:{opt default(age|povratio)}}use default breaks; cannot be combined with {bf:breaks()}.{p_end}
{space 2}{synopt:{opt lblname(string)}}Name of value label to create; default is "{it:varname}_lbl". Ignored if {bf:nolabel} is specified.{p_end}
{space 2}{synopt: {opth nformat(%fmt)}}Numeric display format to use in value labels; default is {it:%13.0gc}. Ignored if {bf:nolabel} is specified.{p_end}
	{synopt:{opt nolab:el}}do not give {it:newvar} value labels.{p_end}
	{synopt:{opt varlab:el(string)}}variable label for {it:newvar}.{p_end}



{title:Example(s)}

    Generate categorical variable 'inc_cat' from 'pincp'.
        {bf:. categorize pincp, generate(inc_cat) breaks(15000 30000 50000 100000)}

    Generate 'age_cat' from 'agep' using default breaks.
        {bf:. categorize agep, generate(age_cat) default(age) varlabel("Age group")}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




