
/***
Title
====== 

__get_acs_pums__ {hline 2} Retrieve American Community Survey PUMS files from the Census Bureauy FTP.


Description
-----------

__get_acs_pums__ downloads American Community Survey [public use microdata](https://www.census.gov/programs-surveys/acs/technical-documentation/pums.html) files from the [Census Bureau FTP](https://www.census.gov/programs-surveys/acs/data/data-via-ftp.html) and creates {help dta} versions of the files.  

Data are saved in acs_pums/[year]/[sample]_yr within the current working directory (the default) or in another "destination directory" the user specifies with the __dest_dir__ option. For instance, the command __get_acs_pums, state(vt) year(2018) sample(5) record_type(h) dest_dir(my_data)__ would save files in my_data/acs_pums/2018/5_yr, creating directories as needed.

If the option __state__ is not specified, the program will download the national PUMS files. Note that these files are very large and downloading them can take an hour or more. The national sample comes in several files (e.g. ss18husa, ss18husb). __get_acs_pums__ appends them together into a single .dta file.

State PUMS .dta files will be named the same as the original .csv files: psam_[record_type][state_fips_code] for 2017 and later, and ss[year][record_type][state] for earlier years. In the example above, the filename would be psam_h50.dta (50 is the state FIPS code for Vermont; if the user were retrieving data for 2016 instead of 2018, the file name would be ss16hvt.dta. National PUMS .dta are named psam_[record_type]us for 2017 and later, and ss[year][record_type]us for earlier years.


Syntax
------ 

> __get_acs_pums__, __year(_integer_)__ [_options_]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
	{synopt:{opt year(integer)}}2005 to 2018 for the one-year sample; 2007 to 2018 for the five-year sample.{p_end}
	
{syntab:Optional}
    {synopt:{opt sample(integer)}}5 for the five-year sample or 1 for the one-year sample. Defaults to 1.{p_end}
	{synopt:{opt st:ate(string)}}state postal appreviation (2 characters, case insensitive).{p_end}
    {synopt:{opt dest_dir(string)}}specifies the directory in which the data will be placed. Defaults to the current working directory.{p_end}
	{synopt:{opt rec:ord_type(string)}}record type to retrieve: person, household, or both (the default). Abbreviations _h, hhld, hous, p,_ and _pers_ are also accepted.{p_end}
	{synopt:{opt keep_zip}}.zip files will not be deleted after unzipping. {p_end}
	{synopt:{opt keep_csv}}.csv files will not be deleted after .dta files are created.{p_end}
	{synopt:{opt replace}}existing files will be replaced if they exist.{p_end}


Example(s)
----------

    Retrieve both person and household records from the 2018 one-year sample for the District of Columbia.
        {bf:. get_acs_pums, state(DC) year(2018)}

    Retreive household records from the 2011 five-year sample for Vermont, and keep the original .csv files.
        {bf:. get_acs_pums, state(vt) year(2011) record_type(hhld) sample(5) keep_csv}

    Retreive household records from the 2013 one-year national sample and save the file to my_datasets.  
        {bf:. get_acs_pums, year(2013) record_type(h) dest_dir(my_datasets)}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/


* capture program drop get_acs_pums


program define get_acs_pums

	syntax , year(integer) [STate(string) sample(integer 1) dest_dir(string) 	///
			 RECord_type(string) keep_zip keep_csv replace]
	
	* Checks ------------------------------------------------------------------

	if !inlist(`sample', 1, 5) {
		display as error "sample(`sample') invalid or unsupported. Sample must be 1 or 5."
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
		display as error "Record type must be person, household, their respective supported abbreviations, or both (see the {help get_acs_pums: help file})."
		exit
	}
	
	preserve
	clear
	
	if "`state'" != "" {
		if strlen("`state'") != 2 {
			display as error "state(`state') must be a two-character postal abbreviation (ex. VT)."
			exit
		}
		// check state abbreviation is valid
		local state = lower("`state'")
		sysuse state_fips, clear  // comes with cbppstatautils package
		// ACS does not cover territories other than PR
		quietly drop if inlist(state_abbrv, "AS", "	GU", "MP", "UM", "VI")  
		quietly levelsof state_abbrv, local(state_abbrvs) clean
		local state_abbrvs = lower("`state_abbrvs'")
		if !regexm("`state_abbrvs'", "`state'") {
			display as error "state(`state') invalid or unsupported."
			exit
		}
		clear
	}
	
	// Set directory ----------------------------------------------------------
	
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
	
	// Create sub-directory for year and sample -------------------------------
	
	capture mkdir "acs_pums"
	capture mkdir "acs_pums/`year'"
	local sub_dir "acs_pums/`year'/`sample'_yr"
	capture mkdir "`sub_dir'"
	quietly cd "`sub_dir'"
	
	// Determine the desired record type --------------------------------------
	
	local rec_type_h = cond("`record_type'" == "" | regexm("`record_type'", "h|hh|hhld|hous|household|both"), "h", "")
	local rec_type_p = cond("`record_type'" == "" | regexm("`record_type'", "p|pers|person|both"), "p", "")
	local rec_type "`rec_type_h' `rec_type_p'"
	
	// Retrieve files ---------------------------------------------------------
	
	// for constructing the URL
	local geo = cond("`state'" != "", lower("`state'"), "us")
	local smpl = cond(`year' < 2007, "", "`sample'-Year/")
	
	foreach rt of local rec_type {
	
		local rec_type_message = cond("`rt'" == "h", "household", "person")
		
		// Download ------------------------------------------------------------
		
		capture confirm file  "csv_`rt'`geo'.zip"
		
		if _rc != 0 | "`replace'" != "" {
			local ftp_url "https://www2.census.gov/programs-surveys/acs/data/pums/`year'/`smpl'csv_`rt'`geo'.zip"
			display as result "Downloading `rec_type_message' files..."
			capture noisily copy "`ftp_url'" "csv_`rt'`geo'.zip", `replace'
			if _rc != 0 {
				display as error "Files could not be downloaded from the Census Bureau FTP." 
				quietly cd "`start_dir'"  
				exit _rc
			}
		}
		
		// Unzip --------------------------------------------------------------
		
		display as result "Unzipping `rec_type_message' files..."
		quietly unzipfile "csv_`rt'`geo'.zip", `replace'
		if "`keep_zip'" == "" {
			display as result "Deleting `rec_type_message' .zip file..."
			erase "csv_`rt'`geo'.zip"
		}
		
		// Create .dta file(s) ------------------------------------------------
		
		local yr = substr(string(`year'), 3, 2)
						
		if "`state'" != "" {
			if `year' < 2017 {
				local csv_file "ss`yr'`rt'`state'.csv"
			}
			if `year' >= 2017 {
				// look up state FIPS code (in .csv file name 2017 and after)
				sysuse state_fips, clear
				quietly keep if state_abbrv == upper("`state'")  
				local st_fips = state_fips[_n] 
				local csv_file "psam_`rt'`st_fips'.csv"
				clear
			}
		}
		// define "chunked" filenames if national sample
		if "`state'" == "" {
			local prefix = cond(`year' < 2017, "ss`yr'`rt'us", "psam_`rt'us")
			if `sample' == 5 {
				local letters "a b c d"
			}
			if `sample' == 1 {
				local letters "a b"
			}
			local csv_file ""
			local chunked_files ""
			foreach l of local letters {
				local csv_file = "`csv_file'" + "`prefix'" + "`l'" + ".csv "
				local chunked_files = "`chunked_files'" + "`prefix'" + "`l'" + ".dta "
			}
		}
		
		display as result "Creating `rec_type_message' .dta file..."
		foreach f of local csv_file {
			quietly import delimited using "`f'", delimiter(comma) varnames(1) clear
			local dta_file = subinstr("`f'", ".csv", "", .)
			quietly save "`dta_file'", `replace'
		}
		if "`keep_csv'" == "" {
			display as result "Deleting `rec_type_message' .csv file..."
			foreach f of local csv_file {
				quietly erase  "`f'"
			}
		}
		
		// Append chunked files if national sample ----------------------------
		
		if "`state'" == "" {
			display as result "Appending `rec_type_message' .dta files..."
			local appended_file = "`prefix'" + ".dta"
			clear
			tempfile temp
			quietly save `temp', emptyok
			foreach f of local chunked_files {
				use "`f'", clear
				append using `temp'
				quietly save `temp', replace
			}
			use `temp', clear
			quietly save "`appended_file'", replace
			foreach f of local chunked_files {
				erase "`f'"
			}
		}
	}
	
	// Reset to original working directory ------------------------------------
	quietly cd "`start_dir'"  
	clear
	display as result "{bf:Complete.}"
	display as result "Your files can be found in `dest_dir'/`sub_dir'."
	display as result "Your current working directory is `start_dir'."

end
