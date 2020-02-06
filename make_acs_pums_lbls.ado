*! v 0.1.0
* depends: _import_text

/***
Title
====== 

__make_acs_pums_lbls__ {hline 2} Make .do files to label American Community Survey PUMS data.


Description
-----------

__make_acs_pums_lbls__ makes {help do} files to label American Community Survey [public use microdata](https://www.census.gov/programs-surveys/acs/technical-documentation/pums.html). Variable and value labels are copied from the ACS PUMS [data dictionaries](https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/).

The generated .do files will be named __lbl_acs_pums_[year]_[sample]yr.do.__ Files are saved in the current working directory (the default) or in another "destination directory" the user specifies with the __dest_dir__ option.

    {it}Note: {bf:make_acs_pums_lbls} does not support data years prior to 2013.{sf}

Syntax
------ 

> __make_acs_pums_lbls__, __year(_#_)__ [_options_]

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


Example(s)
----------

    Make .do file to label 2018 one-year PUMS data. 
        {bf:. make_acs_pums_lbls, year(2018)}

    RMake .do file to label the 2014 five-year sample for Vermont, and save the files to my_do_files.
        {bf:. make_acs_pums_lbls, year(2014) sample(5) dest_dir(my_do_files)}

		
Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/

 capture program drop make_acs_pums_lbls

program define make_acs_pums_lbls

	syntax , year(integer) [sample(integer 1) dest_dir(string) keep_txt replace]
	
	if !inrange(`year', 2013, 2018){
		display `"{err}year(`year') invalid or unsupported. Year must be between 2013 and 2018."'
		exit
	}

	local dest_dir = cond("`dest_dir'" == "", c(pwd), "`dest_dir'")
	
	* Download data dictionary from Census Bureau FTP -------------------------

	if `sample' == 1 {
		local yr = substr("`year'", 3, 4)
		local dict_file_name = cond(`year' > 2016,						///
									"PUMS_Data_Dictionary_`year'", 		///
									"PUMSDataDict`yr'")
	}
	if `sample' == 5 {
		local start_year = `year' - 4
		local dict_file_name "PUMS_Data_Dictionary_`start_year'-`year'"
	}

	local dest_file = "`dest_dir'/pums_dict_`year'_`sample'yr.txt"
	copy "https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/`dict_file_name'.txt"	///
				 "`dest_file'", replace	

	* Import and parse data dictionary ----------------------------------------

	quietly _import_text using "`dest_file'", clear

	quietly gen str400 output = "", before(input)
	format output input %-50s

	* trim and split
	quietly replace input = strtrim(stritrim(input))
	quietly split input, gen(value) parse(".")
	quietly split input, gen(token)
	format value* token* %-10s

	* Add variable labels 		
	local num = cond(`year' < 2017, 2, 3) 	// after 2017, data type was added to the variable name line of the data dictionary text file
	quietly gen isvarname = input[_n-1] == "" & wordcount(input) == `num' & token3 < "A" , after(input)
	quietly gen varname =  lower(token1) if isvarname, after(isvarname)
	quietly gen varlabel =  input[_n+1] if isvarname, after(varname)
	format varname varlabel %-20s
	quietly replace output = "capture label variable " + varname + " " + char(34) + varlabel + char(34) if isvarname

	* Add value labels
	quietly replace varname = varname[_n-1] if varname == ""
	quietly gen isvaluelabel = substr(token2,1,1) == "." & value1 != "b", before(value1)
	quietly gen label = substr(input, strpos(input,".") + 1, .)
	quietly replace output = "capture label define " + varname + " " + value1 + " " + ///
		char(34) + label + char(34) + ", add" if isvaluelabel
	quietly replace output = "capture label values " + varname + " " + varname if isvaluelabel[_n-1] & isvarname[_n+1]
	quietly replace output = "" if strmatch(input,"*..*")

	* Add Notes
	quietly replace output = subinstr(input, "Note", "note", 1) if token1 == "Note:"

	* Organize
	quietly keep output input isvarname varname varlabel isvaluelabel
	quietly keep output varname isvarname
	quietly drop if varname == "" | output == ""
	sort varname, stable
	quietly by varname: gen order = _n
	quietly expand 2 if isvarname
	sort varname, stable
	* sort varname order
	quietly replace output = "" if isvarname[_n+1] & isvarname

	* Add final header
	quietly insobs 3, before(1)
	quietly replace output = "* Generated $S_DATE by program 'make_acs_pums_lbls'" in 1
	quietly keep output

	* Export and cleanup ------------------------------------------------------
	
	outfile using "`dest_dir'/lbl_acs_pums_`year'_`sample'yr.do", noquote `replace'
	display as text "Saved as `dest_dir'/lbl_acs_pums_`year'_`sample'yr.do"
	if "`keep_txt'" == "" {
		quietly erase "`dest_file'"
	}
	clear

end