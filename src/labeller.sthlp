{smcl}

{title:Title}

{p 4 4 2}
{bf:labeller} {hline 2} Define and apply variable and value labels in one step.




{title:Syntax}

{p 8 8 2} {bf:labeller} {it:{help varname}}, [{bf:{cmdab:var:iable}({it:string})}] [{bf:{cmdab:val:ues}({it:string})}], [{it:options}]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
	{synopt:{opt var:iable}}variable label following {help label variable}: {it:"label"}{p_end}
	{synopt:{opt val:ues}}value labels following {help label define}: {it: # "label" [# "label" ...]}{p_end}
    {synopt:{opt add}}add new entries in {bf:values} to existing value label created by {bf:labeller}.{p_end}
    {synopt:{opt modify}}modify or delete existing # to label correspondences and add new
        correspondences to existing value label created by {bf:labeller}.{p_end}
	{synopt:{opt remove}}remove variable and value labels from a variable.{p_end}


{title:Example(s)}

    Using labeller
        {bf:. labeller gender, variable("Gender") values(1 "Male" 2 "Female" 3 "Other")}

    Using built-in functions  
        {bf:. label variable gender "Gender"}  
        {bf:. label define gender_lbl 1 "Male" 2 "Female" 3 "Other"}  
        {bf:. label values gender gender_lbl}  



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


