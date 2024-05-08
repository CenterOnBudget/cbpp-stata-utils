{smcl}

{title:Title}

{p 4 4 2}
{bf:svyset_acs} {hline 2} Declare the survey design in ACS microdata.



{title:Description}

{p 4 4 2}
{bf:svyset_acs} is a shortcut program to declare the survey design in ACS 
microdata.

{p 4 4 2}
For example, {bf:svyset_acs, record_type(person)} is equivalent to 
{bf:svyset [iw=pwgtp], vce(sdr) sdrweight(pwgtp1-pwgtp80) mse}.



{title:Syntax}

{p 8 8 2} {bf:svyset_acs}, {bf:{cmdab:rec:ord_type}({it:string})} [{it:options}]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
	{synopt:{opt rec:ord_type(string)}}record type weight to use: person or household. Abbreviations h, hhld, hous, p, and pers are also accepted.{p_end}
	
{syntab:Optional}
	{synopt:{opt n_years(#)}}in a dataset comprised of # 1-year ACS microdata samples, create and use #-year average weights.{p_end}



{title:Example(s)}

{p 4 4 2}
	Survey set household-level ACS microdata.    {break}
		{bf:. svyset_acs, record_type(hhld)}

{p 4 4 2}
	Survey set a dataset comprised of 3 years of 1-year person-level ACS microdata.    {break}
		{bf:. svyset_acs, record_type(person) n_years(3)}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




