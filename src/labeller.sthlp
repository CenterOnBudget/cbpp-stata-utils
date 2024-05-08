{smcl}

{title:Title}

{p 4 4 2}
{bf:labeller} {hline 2} Create and attach variable and value labels in one step.



{title:Description}

{p 4 4 2}
{bf:labeller} is a shortcut command to label a variable and define and attach 
value labels in one go.

{p 4 4 2}
Labeling a variable and its values with built-in commands involves several 
steps:

      {bf:. label variable sex "Sex assigned at birth"}
      {bf:. label define sex_lbl 1 "Male" 2 "Female"}
      {bf:. label values sex sex_lbl}

{p 4 4 2}
Using {bf:labeller}:

      {bf:. labeller sex, variable("Sex assigned at birth") values(1 "Male" 2 "Female")}

{p 4 4 2}
{bf:labeller} can also be used to "zap" variable and value labels from a variable, by specifying the {bf:remove} option.      {break}


{title:Syntax}

{p 8 8 2} {bf:labeller} {it:{help varname}}, [{bf:{cmdab:var:iable}({it:string})}] [{bf:{cmdab:val:ues}({it:string})}] [{it:options}]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{space 2}{synopt:{opt var:iable}}variable label following {help label variable}: {it:"label"}{p_end}
{space 2}{synopt:{opt val:ues}}value labels following {help label define}: {it:# "label" [# "label" ...]}{p_end}
{space 2}{synopt:{opt lblname(string)}}name of value label to use; default is {bf:lblname(}{it:varname}_lbl{bf:)}.{p_end}
{space 2}{synopt:{opt add}}add new entries in {opt values()} to {it:varname}{c 39}s value label.{p_end}
{space 2}{synopt:{opt modify}}modify or delete existing # to label correspondences and add new correspondences to {it:varname}{c 39}s value label.{p_end}
{space 2}{synopt:{opt remove}}remove variable and value labels from {it:varname}.{p_end}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




