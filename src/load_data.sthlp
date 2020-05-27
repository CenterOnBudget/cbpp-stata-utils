{smcl}

{title:Title}

{p 4 4 2}
{bf:load_data} {hline 2} Load CPS or ACS microdata from the CBPP datasets library.



{title:Description}

{p 4 4 2}
{bf:load_data} loads CPS or ACS microdata from the CBPP datasets library into memory. 

{p 4 4 2}
This program will only work for Center staff who have synched these datasets from the SharePoint datasets library, and have set up the global {c 39}spdatapath{c 39}. 

{p 4 4 2}
If {it:dataset} is ACS, the program will load the one-year merged person-household ACS files. If {it:dataset} is CPS, the program will load the merged person-family-household CPS ASEC files. Available years are 1980-2019 for CPS and 2000-2018 for ACS.

{p 4 4 2}
Users may specify a single year or multiple years to the {bf:years} option as a {help numlist}. If multiple years are specified, the datasets will be appended together before loading.

{p 4 4 2}
The default is to load all variables in the dataset. Users may specify a subset of variables to load in the {bf:vars} option.



{title:Syntax}

{p 8 8 2} {bf:load_data} {it:dataset}, {bf:{cmdab:y:ears}({it:{help numlist}})} [{bf:{cmdab:v:ars}({it:{help varlist}})} {bf:clear}]



{title:Example(s)}

{p 4 4 2}
	Load CPS microdata for 2019.    {break}
		{bf:. load_data cps, year(2019)}
		
{p 4 4 2}
	Load a subset of variables from ACS microdata for 2017-2019.    {break}
		{bf:. load_data acs, years(2017/2019) vars(serialno sporder st agep povpip pwgtp)}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


