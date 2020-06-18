{smcl}

{title:Title}

{p 4 4 2}
{bf:etotal} {hline 2} Flexible counts and totals.



{title:Description}

{p 4 4 2}
An extension of {help total}, {bf:etotal} produces either totals or counts, depending on what the user has specified. If weights are specified, standard errors and confidence intervals are included.



{title:Syntax}

{p 4 4 2}
Count of observations

{p 8 8 2} {bf:etotal} [{it:{help if}}] [{it:{help weight}}], {it:options}

{p 4 4 2}
Total of existing variable

{p 8 8 2} {bf:etotal} [{it:{help varname}}] [{it:{help if}}] [{it:{help weight}}], {it:options}

{p 4 4 2}
Total of expression

{p 8 8 2} {bf:etotal} [{it:{help exp}}] [{it:{help if}}] [{it:{help weight}}], {it:options}


{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
    {synopt:{opth over(varname)}}group over subpopulations defined by _varname_.{p_end}
	{synopt:{opt mat:rix(string)}}save results in matrix named {it:string}.{p_end}
{synoptline}

{p 4 4 2}
{bf:fweight}s, {bf:iweight}s, and {bf:pweight}s are allowed; see {help weight}.



{title:Example(s)}

    Weighted count of observations  
        {bf:. etotal [iw=wgtp]}

    Total of existing variable  
        {bf:. etotal hincp [iw=wgtp]}

    Total of expression, saving results in matrix  
        {bf:. etotal hincp / 1000 [iw=wgtp], matrix(tot_hh_inc_thous)}


{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


