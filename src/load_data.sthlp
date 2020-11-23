{smcl}

{title:Title}

{p 4 4 2}
{bf:load_data} {hline 2} Load datasets from the CBPP datasets library.



{title:Description}

{p 4 4 2}
{bf:load_data} loads CPS, ACS, or SNAP QC microdata from the CBPP datasets library into memory. 

{p 4 4 2}
This program will only work for Center staff who have synched these datasets from the SharePoint datasets library, and have set up the global {it:spdatapath}.    {break}

{p 4 4 2}
If {it:dataset} is ACS, the program will load the one-year merged person-household ACS files. If {it:dataset} is CPS, the program will load the merged person-family-household CPS ASEC files. Available years are 1980-2020 for CPS, 2000-2019 for ACS, and 1980-2019 for QC.

{p 4 4 2}
Users may specify a single year or multiple years to the {it:years} option as a {help numlist}. If multiple years are specified, the datasets will be appended together before loading.    {break}

{p 4 4 2}
The default is to load all variables in the dataset. Users may specify a subset of variables to load in the {it:vars} option.    {break}

{p 4 4 2}
To save the loaded data as a new dataset, use the {it:saveas} option. If the file passed to {it:saveas} already exists, it will be replaced.    {break}

{p 4 4 2}
Note: When loading multiple years of ACS datasets including 2018 and later data, {it:serialno} will be edited to facilitate appending ({it:serialno} is string in 2018 and later and numeric in prior years): "00" and "01" will be substituted for "HU" and "GQ", respectively, and the variable will be destringed.    {break}



{title:Syntax}

{p 8 8 2} {bf:load_data} {it:dataset}, {bf:{cmdab:y:ears}({it:{help numlist}})} [{bf:{cmdab:v:ars}({it:{help varlist}})} {bf:saveas({it:{help filename}})} {bf:clear}]



{title:Example(s)}

{p 4 4 2}
	Load CPS microdata for 2019.    {break}
		{bf:. load_data cps, year(2019)}

{p 4 4 2}
	Load a subset of variables from ACS microdata for 2016-2018.    {break}
		{bf:. load_data acs, years(2016/2018) vars(serialno sporder st agep povpip pwgtp)}

{p 4 4 2}
	Load SNAP QC microdata for 2018.    {break}
		{bf:. load_data qc, years(2018)}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}
{it:This help file was dynamically produced by {browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package}.}


