{smcl}

{title:Title}

{p 4 4 2}
{bf:label_state} {hline 2} Label state FIPS code variable with state names or postal abbreviations.



{title:Description}

{p 4 4 2}
{bf:label_state} labels state  {browse "https://www.census.gov/geographies/reference-files/2018/demo/popest/2018-fips.html":FIPS code} variables with the full state name (the default) or postal abbreviation.    {break}
The 50 states, District of Columbia, Puerto Rico, and U.S. territories are supported.



{title:Syntax}

{p 8 8 2} {bf:label_state} {it}{help varname}{sf}, [{it:abbrv}]

{p 4 4 2}
If the state FIPS code variable {bf:varname} is a string, it will be destringed.      {break}
To label with two-character postal abbreviations (e.g. "VT") rather than the full state name, use the {it:abbrv} option.



{title:Example(s)}

    Label 'gestfips', the variable for state FIPS code in the CPS, with state names.
        {bf:. label_state gestfips}
    Label 'st', the variable for state FIPS code in the ACS, with state abbreviations.
		{bf:. label_state st, abbrv}


{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


