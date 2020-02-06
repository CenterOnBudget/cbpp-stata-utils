{smcl}

{title:Title}

{p 4 4 2}
{bf:make_acs_pums_lbls} {hline 2} Make .do files to label American Community Survey PUMS data.



{title:Description}

{p 4 4 2}
{bf:make_acs_pums_lbls} makes {help do} files to label American Community Survey  {browse "https://www.census.gov/programs-surveys/acs/technical-documentation/pums.html":public use microdata}. Variable and value labels are copied from the ACS PUMS  {browse "https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/":data dictionaries}.

{p 4 4 2}
The generated .do files will be named {bf:lbl_acs_pums_[year]_[sample]yr.do.} Files are saved in the current working directory (the default) or in another "destination directory" the user specifies with the {bf:dest_dir} option.

    {it}Note: {bf:make_acs_pums_lbls} does not support data years prior to 2013.{sf}


{title:Syntax}

{p 8 8 2} {bf:make_acs_pums_lbls}, {bf:year({it:#})} [{it:options}]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
	{synopt:{opt year(#)}}2013 to 2018.{p_end}
	
{syntab:Optional}
    {synopt:{opt sample(#)}}5 for the five-year sample or 1 for the one-year sample. Defaults to 1.{p_end}
    {synopt:{opt dest_dir(str)}}specifies the directory in which the data will be placed. Defaults to the current working directory.{p_end}
	{synopt:{opt keep_txt}}the original data dictionary .txt file will not be deleted after the .do file is created.{p_end}
	{synopt:{opt replace}}existing files will be replaced if they exist..



{title:Example(s)}

    Make .do file to label 2018 one-year PUMS data. 
        {bf:. make_acs_pums_lbls, year(2018)}

    RMake .do file to label the 2014 five-year sample for Vermont, and save the files to my_do_files.
        {bf:. make_acs_pums_lbls, year(2014) sample(5) dest_dir(my_do_files)}

		

{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}

{p 4 4 2}
This help file was dynamically produced by 
{browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package} 


