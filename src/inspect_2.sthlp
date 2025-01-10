{smcl}

{title:Title}

{p 4 4 2}
{bf:inspect_2} {hline 2} Summary statistics for positive, zero, negative, and missing values.



{title:Description}

{p 4 4 2}
A cross between {help summarize} and {help inspect}, {bf:inspect_2} gives the 
frequency of positive, zero, negative, and missing values in a variable, as well 
as the mean, minimum, and maximum value of a variable within those categories and 
overall.

{p 4 4 2}
Results may be stored in a matrix (or matrices, if {it:varlist} is multiple 
variables) by specifying matrix name(s) to {bf:matrix()}.



{title:Syntax}

{p 4 4 2}
{bf:inspect_2} {varlist} [{it:{help if}}] {weight} [, {it:options}]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{space 2}{synopt:{opt mat:rix(matname)}}Store results in matrix {it:matname}. If multiple variables are specified in {it:varlist}, a list of matrix names in which to store the results.{p_end}
{synoptline}


{p 4 4 2}
{bf:fweight}s and {bf:iweight}s are allowed; see {help weight}.



{title:Example(s)}

    Inspect a single variable.

        {bf:. inspect_2 thnetworth}

    Inspect multiple variables, storing the results in matrices.

        {bf:. inspect_2 pincp_adj pernp_adj, matrix(pincp_mat pernp_mat)}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




