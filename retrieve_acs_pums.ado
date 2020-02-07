*! v 0.1.0


/***
Title
====== 

__retrieve_acs_pums__ {hline 2} Retrieve American Community Survey PUMS files from the Census Bureauy FTP.


Description
-----------
6
__retrieve_acs_pums__ downloads American Community Survey [public use microdata](https://www.census.gov/programs-surveys/acs/technical-documentation/pums.html) files from the [Census Bureau FTP](https://www.census.gov/programs-surveys/acs/data/data-via-ftp.html) and creates {help dta} versions of the files.  

Data are saved in acs_pums/[year]/[sample]_yr within the current working directory (the default) or in another "destination directory" the user specifies with the __dest_dir__ option. For instance, the command {bf:retrieve_acs_pums, state(vt) year(2018) sample(5) record_type(h) dest_dir(my_data)} would save files in my_data/acs_pums/2018/5_yr, creating directories as needed.

The .dta files will be named the same as the original .csv files: psam_[record_type][state_fips_code] for 2017 and later, and ss[year][record_type][state] for earlier years. In the example above, the filename would be psam_h50.dta (50 is the state FIPS code for Vermont; if the user were retrieving data for 2016 instead of 2018, the file name would be ss16hvt.dta.


Syntax
------ 

> __retrieve_acs_pums__, __state(_string_)__ __year(_integer_)__ [_options_]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
	{synopt:{opt st:ate(string)}}state postal appreviation (2 characters, case insensitive).{p_end}
	{synopt:{opt year(integer)}}2005 to 2018 for the one-year sample; 2007 to 2018 for the five-year sample.{p_end}
	
{syntab:Optional}
    {synopt:{opt sample(integer)}}5 for the five-year sample or 1 for the one-year sample. Defaults to 1.{p_end}
    {synopt:{opt dest_dir(string)}}specifies the directory in which the data will be placed. Defaults to the current working directory.{p_end}
	{synopt:{opt rec:ord_type(string)}}record type to retrieve: person, household, or both (the default). Abbreviations _h, hhld, hous, p,_ and _pers_ are also accepted.{p_end}
	{synopt:{opt keep_zip}}.zip files will not be deleted after unzipping.{p_end}
	{synopt:{opt keep_csv}}.csv files will not be deleted after .dta files are created.{p_end}
	{synopt:{opt replace}}existing files will be replaced if they exist.{p_end}


Example(s)
----------

    Retrieve both person and household records from the 2018 one-year sample for the District of Columbia.
        {bf:. retrieve_acs_pums, state(DC) year(2018)}

    Retreive household records from the 2011 five-year sample for Vermont, and keep the original .csv files.
        {bf:. retrieve_acs_pums, state(vt) year(2011) record_type(hhld) sample(5) keep_csv}

	Retreive household records from the 2013 one-year sample for Arizona, and save the files to my_datasets.
        {bf:. retrieve_acs_pums, state(az) year(2013) record_type(h) dest_dir(my_datasets)}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/


capture program drop retrieve_acs_pums


program define retrieve_acs_pums

	syntax , STate(string) year(integer) [sample(integer 1) dest_dir(string) RECord_type(string) keep_zip keep_csv replace]

	* Checks ------------------------------------------------------------------
	
	if _N != 0 {
		display as result "Warning: {bf:retrieve_acs_pums} will clear dataset in memory."
		display as result "To proceed anyway, type {bf:y} then Enter. To exit, press any other key then Enter." _request(_y)"
		if "`y'" != "y" {
			exit
		}
	}
	
	
	if !inlist(`sample', 1, 5) {
		display as error "sample(`sample') invalid or unsupported. Sample must be 1 or 5."
		exit
	}
	if strlen("`state'") != 2 {
		display as error "state(`state') must be a two-character postal abbreviation (ex. VT)."
		exit
	}
	if !inrange(`year', 2005, 2018){
		display as error "year(`year') invalid. Year must be between 2005 and 2018."
		exit
	}
	if `year' < 2009 & `sample' == 5 {
		display as error "sample(`sample') unavailable for year(`year'). The 5-year sample is available for 2009 and later."
		exit
	}
	if "`record_type'" != "" & !regexm("`record_type'", "p|pers|person|h|hh|hhld|hous|household|both") {
		display as error "Record type must be person, household, their respective supported abbreviations, or both (see help file)."
		exit
	}
	// check state abbreviation is valid
	local state = lower("`state'")
	sysuse state_fips, clear  // comes with cbppstatautils package
	quietly drop if inlist(state_abbrv, "AS", "	GU", "MP", "UM", "VI")  // ACS does not cover territories other than PR
	quietly levelsof state_abbrv, local(state_abbrvs) clean
	local state_abbrvs = lower("`state_abbrvs'")
	if !regexm("`state_abbrvs'", "`state'") {
		display as error "state(`state') invalid or unsupported."
		exit
	}
	
	// set directory
	local start_dir = c(pwd)  	// save current working directory for reset later
	if "`dest_dir'" != "" {
		capture cd  "`dest_dir'"
		if _rc != 0 {
			capture mkdir "`dest_dir'"
			display as result "`dest_dir' not found. Creating `dest_dir'..."
			quietly cd "`dest_dir'"
		}
	} 
	if "`destdir'" == "" {
		local dest_dir = c(pwd)
	}
	
	// create sub-directory for year and sample
	capture mkdir "acs_pums"
	capture mkdir "acs_pums/`year'"
	local sub_dir "acs_pums/`year'/`sample'_yr"
	capture mkdir "`sub_dir'"
	quietly cd "`sub_dir'"

	// for constructing the URL
	local st = lower("`state'")
	local smpl = cond(`year' < 2007, "", "`sample'-Year/")
	
	// determine the desired record type
	local rec_type_h = cond("`record_type'" == "" | regexm("`record_type'", "h|hh|hhld|hous|household|both"), "h", "")
	local rec_type_p = cond("`record_type'" == "" | regexm("`record_type'", "p|pers|person|both"), "p", "")
	local rec_type "`rec_type_h' `rec_type_p'"
	
	// retrieve files
	foreach rt of local rec_type {
	
		local rec_type_message = cond("`rt'" == "h", "household", "person")
		
		// download
		local ftp_url "https://www2.census.gov/programs-surveys/acs/data/pums/`year'/`smpl'csv_`rt'`st'.zip"
		display as result "Downloading `rec_type_message' files..."
		capture copy "`ftp_url'" "csv_`rt'`st'.zip", `replace' 
		if _rc != 0 {
			display as error "Files could not be downloaded from the Census Bureau FTP." 
			quietly cd "`start_dir'"  
			exit
		}
		
		// unzip
		display as result "Unzipping `rec_type_message' files..."
		quietly unzipfile "csv_`rt'`st'.zip", `replace'
		if "`keep_zip'" == "" {
			display as result "Deleting `rec_type_message' .zip file..."
			erase "csv_`rt'`st'.zip"
		}
		
		// create .dta file(s)
		if `year' < 2017 {
			local csv_file  "ss`yr'`rt'`state'.csv"
		}
		if `year' >= 2017 {
			// look up state FIPS code (in .csv file name 2017 and after)
			local state vt
			quietly keep if state_abbrv == upper("`state'")  // remember state_fips is still in memory
			local st_fips = state_fips[_n] 
			local csv_file "psam_`rt'`st_fips'.csv"
		}
		preserve
		display as result "Creating `rec_type_message' .dta file..."
		quietly import delimited using "`csv_file'", delimiter(comma) varnames(1) clear
		local dta_file = subinstr("`csv_file'", ".csv", "", .)
		quietly save "`dta_file'", `replace'
		if "`keep_csv'" == "" {
			display as result "Deleting `rec_type_message' .csv file..."
			quietly erase  "`csv_file'"
		}
		restore
	}
	
	// reset to original working directory
	quietly cd "`start_dir'"  
	clear
	display as result "{bf:Complete.}"
	display as result "Your files can be found in `dest_dir'/`sub_dir'."
	display as result "Your current working directory is `start_dir'."

end
