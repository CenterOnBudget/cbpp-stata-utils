{smcl}

{title:Title}

{p 4 4 2}
{bf:load_data} {hline 2} Load datasets from the CBPP datasets library.



{title:Description}

{p 4 4 2}
{bf:load_data} loads CPS, ACS, SNAP QC, or Household Pulse Survey microdata from 
the CBPP datasets library into memory. This command is only useful for CBPP 
staff.

{p 4 4 2}
This program will only work for Center staff who have synched these datasets 
from the SharePoint datasets library, and have set up the global {it:spdatapath}.    {break}

{p 4 4 2}
With {opt dataset(acs)}, the program will load the one-year merged 
person-household ACS files. With {opt dataset(cps)}, the program will load the 
merged person-family-household CPS ASEC files. Available years are 1980-2021 for
CPS, 2000-2019 for ACS, and 1980-2019 for QC. 

{p 4 4 2}
Users may specify a single year or multiple years to {bf:years()} as a 
{help numlist}. With {opt dataset(pulse)}, users can specify the weeks of data 
to retrieve in either {bf:weeks()} or {bf:years()}. If multiple years are 
specified, the datasets will be appended together before loading and retain 
variable and value labels from the maximum year in {bf:years()}. 

{p 4 4 2}
The default is to load all variables in the dataset. Users may specify a subset 
of variables to load in the {bf:vars()} option.

{p 4 4 2}
To save the loaded data as a new dataset, use the {bf:saveas()} option. Also 
specify {bf:replace} to overwrite the dataset if it already exists.

{p 4 4 2}
Note: When loading multiple years of ACS datasets including 2018 and later 
samples, {c 39}serialno{c 39} will be edited to facilitate appending ({c 39}serialno{c 39} is string
in 2018 and later datasets, and numeric in prior years{c 39} datasets): "00" and "01"
will be substituted for "HU" and "GQ", respectively, and the variable will be 
destringed.




{title:Syntax}

{p 8 8 2} {bf:load_data} {it:dataset} [{it:{help if}}], {bf:{cmdab:y:ears}({it:{help numlist}})} [{bf:{cmdab:v:ars}({it:{help varlist}})} {bf:saveas({it:{help filename}})} {bf:replace} {bf:clear}]



{title:Example(s)}

{p 4 4 2}
	Load March 2019 CPS ASEC microdata.    {break}
		{bf:. load_data cps, year(2019)}

{p 4 4 2}
	Load a subset of variables from ACS microdata for 2016-2018.    {break}
		{bf:. load_data acs, years(2016/2018) vars(serialno sporder st agep povpip pwgtp)}

{p 4 4 2}
	Load SNAP QC microdata for 2018.    {break}
		{bf:. load_data qc, years(2018)}
	
{p 4 4 2}
	Load Household Pulse Survey microdata for weeks 22-24.    {break}
		{bf: . load_data pulse, weeks(22/24)}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




