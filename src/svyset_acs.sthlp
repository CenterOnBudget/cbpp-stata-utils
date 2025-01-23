{smcl}

{title:Title}

{p 4 4 2}
{bf:svyset_acs} {hline 2} Declare the survey design in ACS microdata.



{title:Description}

{p 4 4 2}
{bf:svyset_acs} is a shortcut program to declare the survey design in ACS 
microdata with {help svyset}.

{p 4 4 2}
For example, {bf:svyset_acs, record_type(person)} is equivalent to 
{bf:svyset [iw=pwgtp], vce(sdr) sdrweight(pwgtp1-pwgtp80) mse}.



{title:Syntax}

{p 4 4 2}
{bf:svyset_acs}, {opt rec:ord_type(string)} [{it:options}]


{synoptset 20}{...}
{synopthdr:options}
{synoptline}
{space 2}{synopt:{opt rec:ord_type(string)}}Record type of the dataset in memory; "person" or "household". Abbreviations "h", "hhld", "hous", "p", and "pers" are also accepted.{p_end}
{space 2}{synopt:{opth n_years(integer)}}Specifies the number of years of ACS microdata in memory; default is 1. If {bf:n_years()} is greater than 1, {bf:svyset_acs} will generate copies of the weights variables divided by this number and use those weights in {bf:svyset}.{p_end}
{synoptline}



{title:Example(s)}

    Survey set household-level ACS microdata.  

      {bf:. svyset_acs, record_type(hhld)}

    Survey set a dataset comprised of 3 years of 1-year person-level ACS microdata.  

      {bf:. svyset_acs, record_type(person) n_years(3)}



{title:Website}

{p 4 4 2}
{browse "https://centeronbudget.github.io/cbpp-stata-utils/":centeronbudget.github.io/cbpp-stata-utils}



