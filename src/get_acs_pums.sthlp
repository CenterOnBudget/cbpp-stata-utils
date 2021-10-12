{smcl}

{title:Title}

{p 4 4 2}
{bf:get_acs_pums} {hline 2} Retrieve American Community Survey PUMS files from 
the Census Bureauy FTP.



{title:Description}

{p 4 4 2}
{bf:get_acs_pums} downloads American Community Survey 
{browse "https://www.census.gov/programs-surveys/acs/technical-documentation/pums.html":public use microdata}
files from the 
{browse "https://www.census.gov/programs-surveys/acs/data/data-via-ftp.html":Census Bureau FTP}
and creates {help dta} versions of the files.    {break}

{p 4 4 2}
Data are saved in "acs_pums/[year]/[sample]_yr" within the current working 
directory (the default) or in another directory the user specifies with the 
{bf:dest_dir} option. For instance, 
{bf:get_acs_pums, state(vt) year(2018) sample(5) record_type(h) dest_dir(my_data)} 
would save files in "my_data/acs_pums/2018/5_yr", creating directories as 
needed.

{p 4 4 2}
If {it:state} is not specified, the program will download the national PUMS files. 
Note that these files are very large and downloading them can take an hour or 
more. The national sample comes in several files (e.g. "ss18husa", "ss18husb").
{bf:get_acs_pums} appends them together into a single .dta file.

{p 4 4 2}
State PUMS .dta files will be named the same as the original .csv files: "psam_[record_type][state_fips_code]" for 2017 and later, and 
"ss[year][record_type][state]" for earlier years. In the example above, the 
filename would be "psam_h50.dta" (the state FIPS code for Vermont is 50). If the
user were retrieving data for 2016 instead of 2018, the file name would be 
"ss16hvt.dta". National PUMS .dta are named "psam_[record_type]us.dta" for 2017
and later, and "ss[year][record_type]us.dta" for earlier years.

{p 4 4 2}
Note that data for Puerto Rico is not available prior to 2005.

{p 4 4 2}
Data will be labeled with information from the ACS PUMS data dictionary 
(implemented with {help label_acs_pums} and supported for 2013 and later years)
unless {bf:nolabel} is specified.



{title:Syntax}

{p 8 8 2} {bf:get_acs_pums}, {bf:year({it:integer})} [{it:options}]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
	{synopt:{opt year(integer)}}2000 to 2019 for the one-year sample; 2007 to 2019 for the five-year sample.{p_end}
	
{syntab:Optional}
    {synopt:{opt sample(integer)}}5 for the five-year sample or 1 for the one-year sample; default is {opt sample(1)}.{p_end}
	{synopt:{opt st:ate(string)}}state postal appreviation (2 characters, case insensitive).{p_end}
    {synopt:{opt dest_dir(string)}}specifies the directory in which the data will be placed; default is current working directory.{p_end}
	{synopt:{opt rec:ord_type(string)}}record type to retrieve: person, household, or both; default is {opt record_type(both)}. Abbreviations h, hhld, hous, p, and pers are also accepted.{p_end}
	{synopt:{opt nolab:el}}do not label data with information from the ACS PUMS data dictionary.{p_end}
	{synopt:{opt keep_zip}}.zip files will not be deleted after unzipping.{p_end}
	{synopt:{opt keep_all}}neither .zip nor .csv files will be deleted after .dta files are created.{p_end}
	{synopt:{opt replace}}existing files will be replaced if they exist.{p_end}



{title:Example(s)}

    Retrieve both person and household records from the 2018 one-year sample for the District of Columbia.
        {bf:. get_acs_pums, state(DC) year(2018)}

    Retreive household records from the 2011 five-year sample for Vermont, and keep the original .zip and .csv files.
        {bf:. get_acs_pums, state(vt) year(2011) sample(5) record_type(hhld) keep_all}

    Retreive household records from the 2013 one-year national sample and save the file to my_datasets.
        {bf:. get_acs_pums, year(2013) record_type(h) dest_dir(my_datasets)}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




