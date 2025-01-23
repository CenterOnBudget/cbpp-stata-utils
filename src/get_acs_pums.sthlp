{smcl}

{title:Title}

{p 4 4 2}
{bf:get_acs_pums} {hline 2} Download ACS microdata files from the Census Bureau FTP and convert them to .dta format.



{title:Description}

{p 4 4 2}
{bf:get_acs_pums} downloads 
{browse "https://www.census.gov/programs-surveys/acs/microdata.html":American Community Survey public use microdata}
CSV files from the Census Bureau FTP and converts them to Stata{c 39}s .dta format.

{p 4 4 2}
If {bf:state()} is not specified, the program will retrieve the national dataset. 
Downloading the data for the entire U.S. can take several hours. The national 
dataset is split into several CSV files. get_acs_pums appends them into a single 
.dta file.

{p 4 4 2}
Datasets will be saved in "acs_pums/[year]/[sample]_yr" within the current 
working directory (the default) or in another directory the user specifies with 
the dest_dir() option. For example, {bf:get_acs_pums, state(vt) year(2022) 
sample(5) record_type(h) dest_dir(my_data)} would save files in 
"my_data/acs_pums/2022/5_yr", creating intermediate directories as needed.

{p 4 4 2}
State .dta files are named the same as the original CSV files: 
"psam_[record_type][state_fips_code]" for 2017 and later, and 
"ss[year][record_type][state]" for earlier years. National .dta files are named 
"psam_[record_type]us.dta" for 2017 and later, and "ss[year][record_type]us.dta" 
for earlier years.

{p 4 4 2}
If {bf:year()} is 2013 or later, datasets will be labeled with information from 
the ACS PUMS data dictionaries by default.



{title:Syntax}

{p 4 4 2}
{bf:get_acs_pums}, {opt year(integer)} [{it:options}]


{synoptset 22}{...}
{synopthdr:options}
{synoptline}
{space 2}{synopt:{opt year(integer)}}Data year to retrieve. With {opt sample(1)}, 2005 to the most recent available, excluding 2020. With {opt sample(5)}, 2009 to the most recent available.{p_end}
{space 2}{synopt:{opt sample(integer)}}Sample to retrieve; 1 for the 1-year sample (the default) or 5 for the 5-year sample.{p_end}
{space 2}{synopt:{opt st:ate(string)}}Postal abbreviation of the state to retrieve (case insensitive).{p_end}
{space 2}{synopt:{opt rec:ord_type(string)}}Record type to retrieve; "person", "household", or "both" (the default). Abbreviations "h", "hhld", "hous", "p", and "pers" are also accepted.{p_end}
{space 2}{synopt:{opt nolab:el}}Do not attach variable or value labels to the dataset.{p_end}
{space 2}{synopt:{opt dest_dir(string)}}Directory in which to save the retrieved data. Default is the current working directory.{p_end}
{space 2}{synopt:{opt keep_zip}}Downloaded ZIP files will not be deleted after .dta files are created.{p_end}
{space 2}{synopt:{opt keep_all}}Downloaded ZIP files and unzipped CSV files will not be deleted after .dta files are created.{p_end}
{space 2}{synopt:{opt replace}}Existing .dta, CSV, and ZIP files will be replaced.{p_end}
{synoptline}



{title:Example(s)}

    Retrieve person and household records for the District of Columbia.

        {bf:. get_acs_pums, state("dc") year(2022)}

    Retrieve household records from the 2022 5-year sample for Vermont, preserving the ZIP and CSV files.

        {bf:. get_acs_pums, state("vt") year(2022) sample(5) record_type("household") keep_all}

    Retrieve person records from the 1-year national sample and save the files to "my_datasets".

        {bf:. get_acs_pums, year(2022) record_type("p") dest_dir("my_datasets")}



{title:Website}

{p 4 4 2}
{browse "https://centeronbudget.github.io/cbpp-stata-utils/":centeronbudget.github.io/cbpp-stata-utils}



