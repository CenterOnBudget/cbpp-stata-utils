{smcl}

{title:Title}

{p 4 4 2}
{bf:svyset_acs} {hline 2} Declare the survey design for ACS PUMS.



{title:Description}

{p 4 4 2}
{bf:svyset_acs} is a shortcut program to declare the survey design for ACS PUMS.

{p 4 4 2}
When used with {it:record_type(person)}, it is the equivalent to typing:

{p 8 8 2}	svyset [iw=pwgtp], vce(sdr) sdrweight(pwgtp1-pwgtp80) mse



{title:Syntax}

{p 8 8 2} {bf:svyset_acs}, {bf:{cmdab:rec:ord_type}({it:string})} [{it:options}]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
	{synopt:{opt rec:ord_type(string)}}record type weight to use: person or household. Abbreviations h, hhld, hous, p, and pers are also accepted.{p_end}
	
{syntab:Optional}
    {synopt:{opt nosdr:weights}}do not declare SDR replicate weights in the survey design.{p_end}



{title:Example(s)}

{p 4 4 2}
	Survey set household-level ACS PUMS data.    {break}
		{bf:. svyset_acs, record_type(hhld)}

{p 4 4 2}
	Survey set person-level ACS PUMS data without replicate weights.    {break}
		{bf:. svyset_acs, record_type(person) nosdrweights}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}
{it:This help file was dynamically produced by {browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package}.}


