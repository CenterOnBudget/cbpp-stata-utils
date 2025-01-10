{smcl}

{title:Title}

{p 4 4 2}
{bf:labeler} {hline 2} Create and attach variable and value labels in one step.



{title:Description}

{p 4 4 2}
{bf:labeler} is a shortcut command to label a variable and define and attach 
value labels in one go.

{p 4 4 2}
Labeling a variable and its values with built-in commands involves several 
steps:

      {bf:. label variable sex "Sex assigned at birth"}
      {bf:. label define sex_lbl 1 "Male" 2 "Female"}
      {bf:. label values sex sex_lbl}

{p 4 4 2}
Using {bf:labeler}:

      {bf:. labeler sex, variable("Sex assigned at birth") values(1 "Male" 2 "Female")}

{p 4 4 2}
{bf:labeler} can also be used to "zap" variable and value labels from a variable, by specifying the {bf:remove} option.      {break}


{title:Syntax}

{p 4 4 2}
{bf:labeler} {varname}, [{opt var:iable(string)}] [{opt val:ues(string)}] [{it:options}]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{space 2}{synopt:{opt var:iable}}Variable label for {it:varname}.{p_end}
{space 2}{synopt:{opt val:ues}}Value labels for {it:varname}, following the same syntax as {help label define}: {it:# "label" [# "label" ...]}{p_end}
{space 2}{synopt:{opt lblname(string)}}Name of the value label to use. Default is "{it:varname}_lbl".{p_end}
{space 2}{synopt:{opt add}}Add value labels in {bf:values()} to {it:varname}{c 39}s existing value label.{p_end}
{space 2}{synopt:{opt modify}}Use value labels in {bf:values()} to modify or delete existing # to label correspondences or add new correspondences to {it:varname}{c 39}s existing value label.{p_end}
{space 2}{synopt:{opt remove}}Remove variable labels and detach value labels from {it:varname}. Value labels will not be dropped from the dataset.{p_end}
{synoptline}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




