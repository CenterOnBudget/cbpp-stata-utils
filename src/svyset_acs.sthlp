{smcl}

{title:Title}

{p 4 4 2}
{bf:svyset_acs} {hline 2} Declare the survey design for ACS PUMS.



{title:Description}

{p 4 4 2}
{bf:svyset_acs} is a shortcut program to declare the survey design for ACS PUMS.

{p 4 4 2}
In person-level data with the {it:rep_weights} option, it is the equivalent to typing "svyset [iw=pwgtp], vce(sdr) sdrweight(pwgtp1 - pwgtp80) mse".
	
{p 4 4 2}
That command can be hard to remember and repeatedly copy-pasting can be troublesome; {bf:svyset_acs} provides a more convenient way.    {break}



{title:Syntax}

{p 8 8 2} {bf:svyset_acs}, {bf:{cmdab:rec:ord_type}({it:string})} [{it:{cmdab:rep:_weights}}]

{p 4 4 2}
Users must pass the record type of the data in memory (person or household) to {bf:record_type}. Abbreviations {it:h, hhld, hous, p,} and {it:pers} are also accepted.

{p 4 4 2}
To specify that replicate weights be used in the survey design, use the {bf:rep_weights} option. 



{title:Example(s)}

    Survey set household-level ACS PUMS data using replicate weights.
        {bf:. svyset_acs, record_type(hhld) rep_weights}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


