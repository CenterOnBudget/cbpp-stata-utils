{smcl}

{title:Title}

{p 4 4 2}
{bf:label_state} {hline 2} Label state FIPS code variable with state names.



{title:Description}

{p 4 4 2}
{bf:label_state} labels state  {browse "https://www.census.gov/geographies/reference-files/2018/demo/popest/2018-fips.html":FIPS code} variables with the full state name.     {break}
The 50 states, District of Columbia, and Puerto Rico are supported.



{title:Syntax}

{p 8 8 2} {bf:label_state} {it}{help varname}{sf}

{p 4 4 2}
If {bf:varname} is a string variable, it will be destringed.    {break}
Defaults to {it:st,} the American Community Survey PUMS variable for state FIPS codes.{p_end}



{title:Example(s)}

    Label 'gestfips', the variable for state FIPS code in the CPS, with state names.
        {bf:. label_state gestfips}


{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


