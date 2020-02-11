{smcl}

{title:Title}

{p 4 4 2}
{bf:get_acs_pums} {hline 2} Retrieve American Community Survey PUMS files from the Census Bureauy FTP.



{title:Description}
{break}    6
{bf:get_acs_pums} downloads American Community Survey  {browse "https://www.census.gov/programs-surveys/acs/technical-documentation/pums.html":public use microdata} files from the  {browse "https://www.census.gov/programs-surveys/acs/data/data-via-ftp.html":Census Bureau FTP} and creates {help dta} versions of the files.    {break}

{p 4 4 2}
Data are saved in acs_pums/[year]/[sample]_yr within the current working directory (the default) or in another "destination directory" the user specifies with the {bf:dest_dir} option. For instance, the command {bf:get_acs_pums, state(vt) year(2018) sample(5) record_type(h) dest_dir(my_data)} would save files in my_data/acs_pums/2018/5_yr, creating directories as needed.

{p 4 4 2}
The .dta files will be named the same as the original .csv files: psam_[record_type][state_fips_code] for 2017 and later, and ss[year][record_type][state] for earlier years. In the example above, the filename would be psam_h50.dta (50 is the state FIPS code for Vermont; if the user were retrieving data for 2016 instead of 2018, the file name would be ss16hvt.dta.



{title:Syntax}

{p 8 8 2} {bf:get_acs_pums}, {bf:state({it:string})} {bf:year({it:integer})} [{it:options}]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
	{synopt:{opt st:ate(string)}}state postal appreviation (2 characters, case insensitive).{p_end}
	{synopt:{opt year(integer)}}2005 to 2018 for the one-year sample; 2007 to 2018 for the five-year sample.{p_end}
	
{syntab:Optional}
    {synopt:{opt sample(integer)}}5 for the five-year sample or 1 for the one-year sample. Defaults to 1.{p_end}
    {synopt:{opt dest_dir(string)}}specifies the directory in which the data will be placed. Defaults to the current working directory.{p_end}
	{synopt:{opt rec:ord_type(string)}}record type to retrieve: person, household, or both (the default). Abbreviations {it:h, hhld, hous, p,} and {it:pers} are also accepted.{p_end}
	{synopt:{opt keep_zip}}.zip files will not be deleted after unzipping.{p_end}
	{synopt:{opt keep_csv}}.csv files will not be deleted after .dta files are created.{p_end}
	{synopt:{opt replace}}existing files will be replaced if they exist.{p_end}



{title:Example(s)}

    Retrieve both person and household records from the 2018 one-year sample for the District of Columbia.
        {bf:. get_acs_pums, state(DC) year(2018)}

    Retreive household records from the 2011 five-year sample for Vermont, and keep the original .csv files.
        {bf:. get_acs_pums, state(vt) year(2011) record_type(hhld) sample(5) keep_csv}

{p 4 4 2}
	Retreive household records from the 2013 one-year sample for Arizona, and save the files to my_datasets.
        {bf:. get_acs_pums, state(az) year(2013) record_type(h) dest_dir(my_datasets)}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


