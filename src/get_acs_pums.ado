
/***
Title
====== 

__get_acs_pums__ {hline 2} Retrieve American Community Survey PUMS files from the Census Bureauy FTP.


Description
-----------

__get_acs_pums__ downloads American Community Survey [public use microdata](https://www.census.gov/programs-surveys/acs/technical-documentation/pums.html) files from the [Census Bureau FTP](https://www.census.gov/programs-surveys/acs/data/data-via-ftp.html) and creates {help dta} versions of the files.  

Data are saved in "acs_pums/[year]/[sample]_yr" within the current working directory (the default) or in another directory the user specifies with the __dest_dir__ option. For instance, __get_acs_pums, state(vt) year(2018) sample(5) record_type(h) dest_dir(my_data)__ would save files in "my_data/acs_pums/2018/5_yr", creating directories as needed.

If _state_ is not specified, the program will download the national PUMS files. Note that these files are very large and downloading them can take an hour or more. The national sample comes in several files (e.g. "ss18husa", "ss18husb"). __get_acs_pums__ appends them together into a single .dta file.

State PUMS .dta files will be named the same as the original .csv files: "psam_[record_type][state_fips_code]" for 2017 and later, and "ss[year][record_type][state]" for earlier years. In the example above, the filename would be "psam_h50.dta" (the state FIPS code for Vermont is 50). If the user were retrieving data for 2016 instead of 2018, the file name would be "ss16hvt.dta". National PUMS .dta are named "psam_[record_type]us.dta" for 2017 and later, and "ss[year][record_type]us.dta" for earlier years.

Note that data for Puerto Rico is not available prior to 2005.


Syntax
------ 

> __get_acs_pums__, __year(_integer_)__ [_options_]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
	{synopt:{opt year(integer)}}2000 to 2018 for the one-year sample; 2007 to 2018 for the five-year sample.{p_end}
	
{syntab:Optional}
    {synopt:{opt sample(integer)}}5 for the five-year sample or 1 for the one-year sample; default is {bf:sample(1)}.{p_end}
	{synopt:{opt st:ate(string)}}state postal appreviation (2 characters, case insensitive).{p_end}
    {synopt:{opt dest_dir(string)}}specifies the directory in which the data will be placed; default is current working directory.{p_end}
	{synopt:{opt rec:ord_type(string)}}record type to retrieve: person, household, or both; default is {bf:record_type(both)}. Abbreviations h, hhld, hous, p, and pers are also accepted.{p_end}
	{synopt:{opt keep_zip}}.zip files will not be deleted after unzipping.{p_end}
	{synopt:{opt keep_all}}neither .zip nor .csv files will be deleted after .dta files are created.{p_end}
	{synopt:{opt replace}}existing files will be replaced if they exist.{p_end}


Example(s)
----------

    Retrieve both person and household records from the 2018 one-year sample for 
	the District of Columbia.
        {bf:. get_acs_pums, state(DC) year(2018)}

    Retreive household records from the 2011 five-year sample for Vermont, and 
	keep the original .zip and .csv files.
        {bf:. get_acs_pums, state(vt) year(2011) sample(5) record_type(hhld) keep_all}

    Retreive household records from the 2013 one-year national sample and save 
	the file to my_datasets.  
        {bf:. get_acs_pums, year(2013) record_type(h) dest_dir(my_datasets)}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -
{it:This help file was dynamically produced by {browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package}.}
***/


capture program drop get_acs_pums

program define get_acs_pums

	syntax , year(integer) [STate(string) sample(integer 1) dest_dir(string) 	///
			 RECord_type(string) keep_zip keep_all replace]
	
	
	if "`keep_all'" != "" & "`keep_zip'" == "" {
	    local keep_zip "keep_zip"
	}
	
	preserve
	
	
	* checks ------------------------------------------------------------------

	// check year, sample, and combination
	if !inlist(`sample', 1, 5) {
		display as error "{bf:sample()} must be 1 or 5"
		exit 198
	}
	if !inrange(`year', 2000, 2018){
		display as error "{bf:year()} must be between 2000 and 2018 inclusive"
		exit 198
	}
	if `year' < 2009 & `sample' == 5 {
		display as error "{bf:sample(`sample')} data unavailable for {bf:year(`year')}"
		exit 198
	}
	
	// check valid record type
	if "`record_type'" != "" & !inlist("`record_type'", "p", "pers", "person", "h", "hh", "hous", "hhld", "household") {
		display as error "{bf:record_type()} must be person, household, their respective supported abbreviations, or both"
		exit 198
	}
	
	// check valid state

	if "`state'" != "" {
		if ustrlen("`state'") != 2 {
			display as error "{bf:state()} must be a two-character postal abbreviation"
			exit
		}
		// check state abbreviation is valid
		sysuse state_fips, clear  // comes with cbppstatautils package
		// ACS does not cover territories other than PR
		quietly drop if inlist(state_abbrv, "AS", "	GU", "MP", "UM", "VI")  
		quietly levelsof state_abbrv, local(state_abbrvs) clean
		if !ustrregexm("`state_abbrvs'", "`state'", 1) {
			display as error "{bf:state()} invalid or unsupported"
			exit 198
		}
		// get state fips code if year is after 2016, needed for filename
		if `year' >= 2017 {
		    quietly levelsof state_fips 									///
							 if ustrregexm(state_abbrv, "`state'", 1), 		///
							 local(st_fips) clean
		}

		if "`state'" == "pr" & `year' < 2005 {
			display as error "{bf:state(`state')} data unavailable for {bf:year(`year')}"
			exit 198
		}
	}
	
	
	* set directory -----------------------------------------------------------
	
	// save current working directory for reset later
	local start_dir = c(pwd)  	
	
	// create dest dir if it does not exist
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
	
	
	* create sub-directory for year and sample --------------------------------
	
	capture mkdir "acs_pums"
	capture mkdir "acs_pums/`year'"
	local sub_dir "acs_pums/`year'/`sample'_yr"
	capture mkdir "`sub_dir'"
	quietly cd "`sub_dir'"
	
	
	* determine the desired record type ---------------------------------------
	
	local rec_type_h = cond("`record_type'" == "" | ustrregexm("`record_type'", "h|hh|hhld|hous|household|both"), "h", "")
	local rec_type_p = cond("`record_type'" == "" | ustrregexm("`record_type'", "p|pers|person|both"), "p", "")
	local rec_type "`rec_type_h' `rec_type_p'"
	
	
	* retreive files ----------------------------------------------------------
	
	// for constructing the URL
	local geo = cond("`state'" != "", lower("`state'"), "us")
	local smpl = cond(`year' < 2007, "", "`sample'-Year/")
	
	foreach rt of local rec_type {
	
		local rec_type_message = cond("`rt'" == "h", "household", "person")
		
		* download ------------------------------------------------------------
		
		capture confirm file  "csv_`rt'`geo'.zip"
		
		if _rc != 0 | "`replace'" != "" {
			local ftp_url "https://www2.census.gov/programs-surveys/acs/data/pums/`year'/`smpl'csv_`rt'`geo'.zip"
			display as result "Downloading `rec_type_message' files..."
			capture noisily copy "`ftp_url'" "csv_`rt'`geo'.zip", `replace'
			if _rc != 0 {
				display as error "Unable to download files from the Census Bureau FTP" 
				quietly cd "`start_dir'"  
				exit _rc
			}
		}
		
		* unzip ---------------------------------------------------------------
		
		display as result "Unzipping `rec_type_message' files..."
		quietly unzipfile "csv_`rt'`geo'.zip", `replace'
		if "`keep_zip'" == "" {
			display as result "Deleting `rec_type_message' .zip file..."
			erase "csv_`rt'`geo'.zip"
		}
		
		* create .dta file(s) -------------------------------------------------
		
		local yr = substr(string(`year'), 3, 2)
					
		// define .csv file names
		if "`state'" != "" | ("`state'" == "" & `year' > 2005) {
		    if `year' == 2000 {
			    local csv_file "c2ss`rt'`state'.csv"
			}
			if inrange(`year', 2001, 2017) {
				local csv_file "ss`yr'`rt'`state'.csv"
			}
			if `year' >= 2017 {
				local csv_file "psam_`rt'`st_fips'.csv"
				clear
			}
		}
		if "`state'" == ""  & `year' == 2000 {
		    local csv_file "c2ss`rt'us.csv"
		}
		if "`state'" == "" & inrange(`year', 2001, 2005) {
			local csv_file "ss`yr'`rt'us.csv"
		}
		
		// define "chunked" filenames if national sample 2006 or later
		if "`state'" == "" & `year' > 2005 {
			local prefix = cond(`year' < 2017, "ss`yr'`rt'us", "psam_`rt'us")
			local letters = cond(`sample' == 1, "a b", "a b c d")
			local csv_file ""
			local chunked_files ""
			foreach l of local letters {
				local csv_file = "`csv_file'" + "`prefix'" + "`l'" + ".csv "
				local chunked_files = "`chunked_files'" + "`prefix'" + "`l'" + ".dta "
			}
		}
		
		// import .csv files and save as .dta
		display as result "Creating `rec_type_message' .dta file..."
		foreach f of local csv_file {
			quietly import delimited using "`f'", delimiter(comma) varnames(1) clear
			local dta_file = subinstr("`f'", ".csv", "", .)
			quietly save "`dta_file'", `replace'
		}
		if "`keep_all'" == "" {
			display as result "Deleting `rec_type_message' .csv file..."
			foreach f of local csv_file {
				quietly erase  "`f'"
			}
		}
		
		* append chunked files if national sample -----------------------------
		
		if "`state'" == "" & `year' > 2005 {
			display as result "Appending `rec_type_message' .dta files..."
			clear
			foreach f of local chunked_files {
			    append using "`f'"
			}
			local appended_file = "`prefix'" + ".dta"
			quietly save "`appended_file'", replace
			clear
			foreach f of local chunked_files {
				erase "`f'"
			}
		}
	}
	
	* reset to original working directory -------------------------------------
	
	quietly cd "`start_dir'"  
	local dest_dir_disp = subinstr("`dest_dir'", "\", "/", .)	
	local start_dir_disp = subinstr("`start_dir'", "\", "/", .)

	display as result "{bf:Complete.}"
	display as result `"Your files can be found in {browse "`dest_dir_disp'/`sub_dir'"}"'
	display as result `"Your current working directory is {browse "`start_dir_disp'"}"'
	
	restore

end


