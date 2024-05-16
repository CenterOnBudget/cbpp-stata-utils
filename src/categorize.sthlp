{smcl}

{title:Title}

{p 4 4 2}
{bf:categorize} {hline 2} Create a categorical variable from a continuous one.



{title:Description}

{p 4 4 2}
{bf:categorize} is a shortcut and extension of {bf:{help egen} newvar = cut(args) [...], icodes}.

{p 4 4 2}
Unlike {help egen} with the {bf:cut()} function, {bf:categorize}:

{p 8 10 2}{c 149} Does not require the user to include the minimum and the maximum value of the continuous variable in the list of breaks.

{p 8 10 2}{c 149} Creates more descriptive value labels for the generated categorical variable. Users can specify a variable label for the new variable.

{p 8 10 2}{c 149} Allows users working with age or poverty ratio variables to use "default" breaks.



{title:Syntax}

{p 4 4 2}
{bf:categorize} {it:{varname}}, {opth gen:erate(newvar)} {{opth breaks(numlist)}|{opt default(string)}} [{it:options}]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{space 2}{synopt:{opth gen:erate(newvar)}}Name of the categorical variable to be generated.{p_end}
{space 2}{synopt:{opth breaks(numlist)}}Left-hand ends of the grouping intervals. Do not include the minimum or the maximum value of {it:varname}. Either {bf:breaks()} or {bf:default()} must be specified.{p_end}
{space 2}{synopt:{opt default(string)}}Use default breaks; "age" or "povratio". For {opt default("age")}, these are 18 and 65. For {opt default("povratio")}, these are 50, 100, 150, 200, and 250. Cannot be combined with {bf:breaks()}.{p_end}
{space 2}{synopt:{opt lblname(string)}}Name of value label to create; default is "{it:varname}_lbl". Ignored if {bf:nolabel} is specified.{p_end}
{space 2}{synopt:{opt nformat(string)}}Numeric format to use in value labels; default is nformat(13.0gc). Ignored if nolabel is specified.{p_end}
{space 2}{synopt:{opt nol:abel}}Do not assign value labels to {it:newvar}.{p_end}
{space 2}{synopt:{opt varlab:el(string)}}Variable label for {it:newvar}.{p_end}
{synoptline}



{title:Example(s)}

    Using user-specified breaks.

        {bf:. categorize pincp_adj, generate(pincp_cat) breaks(25000 50000 100000)}

    Using default breaks.

        {bf:. categorize agep, generate(age_cat) default("age") varlabel("Age group")}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




