{smcl}

{title:Title}

{p 4 4 2}
{bf:etotal} {hline 2} Flexible counts and totals.



{title:Description}

{p 4 4 2}
An extension of {help total}, {bf:etotal} produces either totals or counts, 
depending on what the user has specified.

{p 4 4 2}
If weights are specified, or if data are {help svyset} and the {bf:svy} option 
is specified, standard errors and confidence intervals are included.



{title:Syntax}

{p 4 4 2}
Count of observations

{p 8 8 2} {bf:etotal} [{it:{help if}}] {weight} [, {it:options}]

{p 4 4 2}
Total of existing variable

{p 8 8 2} {bf:etotal} [{it:{varname}}] [{it:{help if}}] {weight} [, {it:options}]

{p 4 4 2}
Total of expression

{p 8 8 2} {bf:etotal} [{it:{help exp}}] [{it:{help if}}] {weight} [, {it:options}]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{space 2}{synopt:{opth over(varname)}}Group over subpopulations defined by {it:varname}.{p_end}
{space 2}{synopt:{opt svy}}Adjust the results for survey settings identified by {bf:{help svyset}}.{p_end}
{space 2}{synopt:{opt level(#)}}Set confidence level; default is {opt level(95)}.{p_end}
{space 2}{synopt:{opth cformat(%fmt)}}Specifies how to format estimates, standard errors, and confidence limits; deftault is {opt cformat(%14.0fc)}.{p_end}
{space 2}{synopt:{opt mat:rix(matname)}}Save results in matrix {it:matname}.{p_end}
{synoptline}


{p 4 4 2}
{bf:fweight}s, {bf:iweight}s, and {bf:pweight}s are allowed; see {help weight}.



{title:Example(s)}

    Weighted count of observations  

        {bf:. etotal [iw=wgtp]}

    Total of existing variable  

        {bf:. etotal hincp if relp == 0 [iw=wgtp]}

    Total of existing variable, data is svyset  

        {bf:. etotal hincp, svy}

    Total of expression, saving results in matrix  

        {bf:. etotal hincp / 1000 [iw=wgtp], matrix(tot_hh_inc_thous)}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




