
/***
Title
====== 

__generate_acs_major_group__ {hline 2} Generate categorical variable for major industry and/or occupation groups in American Community Survey PUMS data.


Description
-----------

__generate_acs_major_group__ generates a categorical variable for major industry and major occupation groups in American Community Survey [public use microdata](https://www.census.gov/programs-surveys/acs/technical-documentation/pums.html) by recoding 'occp' and 'indp'. 

The program takes the value labels for 'occp' and 'indp' from the ACS PUMS [data dictionaries](https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/) and uses them to recode these variables into major groups. For instance, 'occp' values 9370 through 9590 are recoded to 1 and labelled "ADM", values 0170 through 0290 are recoded to 2 and labelled "AGR", and so on. 

Generated major group variables are named as the original with the prefix "maj_" by default. Users may supply another prefix to the _prefix_ option.

By default, the program will attempt to confirm and generate a major group variable for both 'indp' and 'occp'. Users wishing to use only one the variables should pass its name to _varname_.

The program automatically caches the ACS PUMS data dictionary. Users can load cached data by specifying the _use_cache_ option (recommended).

More information on the Census Bureau's industry and occupation codes, including comparability over time and to NAICS and SOC codes, respectively, can be found in the Code List section of the [ACS PUMS technical documentation](https://www.census.gov/programs-surveys/acs/technical-documentation/pums.html) and on the [Guidance for Industry & Occupation Data Users](https://www.census.gov/topics/employment/industry-occupation/guidance.html) page on the Census Bureau website.


Syntax
------ 

> __generate_acs_major_group__ __[_{help varname}_]__, __year(_integer_)__ [_options_]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
	{synopt:{opt year(integer)}}2013 to 2018.{p_end}
	
{syntab:Optional}
    {synopt:{opt sample(integer)}}5 for the five-year sample or 1 for the one-year sample; default is {bf:sample(1)}.{p_end}
	{synopt:{opt pre:fix(string)}}prefix to prepend to the variable name; default is {bf:prefix(maj_)}.{p_end}
	{synopt:{opt use_cache}}use cached data dictionary file (recommended).{p_end}


Example(s)
----------

    Generate categorical variables for major industry and occupation groups 
	in the 2018 one-year sample.
        {bf:. generate_acs_major_group, year(2018) use_cache}

   Generate a categorical variable for major industry groups named 'grouped_indp' 
   in the 2016 five-yer sample.
        {bf:. generate_acs_major_group indp, year(2016) sample(5) prefix(grouped_) use_cache}

		
Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -
{it:This help file was dynamically produced by {browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package}.}
***/


* TODO:
* use a series of replace instead of recode, which is very slow.


* capture program drop generate_acs_major_group


program define generate_acs_major_group

	syntax [varlist(default=none)], year(integer) [sample(integer 1) PREfix(string) use_cache]

    
	* prep --------------------------------------------------------------------
	
	if !inrange(`year', 2013, 2018){
		display as error "{bf:year()} must be between 2013 and 2018 inclusive"
		exit 198
	}
	if "`prefix'" == "" {
		local prefix "maj_"
	}
	if "`varlist'" != "" & !inlist("`varlist'", "indp", "occp", "indp occp", "occop indp"){
		display as error "Invalid `varlist'. Must be indp, occp, or both (in any order)."
		exit
	}
	if "`varlist'" == "" {
		local varlist indp occp
	}	
	
	confirm variable `varlist'

    
	* set up cache directory --------------------------------------------------
    
	local cache_dir = cond("`c(os)'" == "Windows", 				///
						   "~/AppData/Local/cbppstatautils",	///
						   "~/Library/Application Support/cbppstatautils")
	capture mkdir "`cache_dir'"		
	
    
	* decide whether to download file -----------------------------------------
	
    local data_dict "acs_pums_dict_`year'_`sample'yr.txt"
    
	// download if use_cache is not specified, 
	// or if use_cache is specified but the file does not exist
	capture confirm file "`cache_dir'/`data_dict'"
	local download = (_rc != 0 ) | ("`use_cache'" == "")
	
    
	* download if needed ------------------------------------------------------
	
	if `download' {
		if `sample' == 1 {
			local yr = substr("`year'", 3, 4)
			local dict_url_file = cond(`year' > 2016,						///
									   "PUMS_Data_Dictionary_`year'", 		///
									   "PUMSDataDict`yr'")
		}
		if `sample' == 5 {
			local start_year = `year' - 4
			local dict_url_file "PUMS_Data_Dictionary_`start_year'-`year'"
		}
		quietly copy "https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/`dict_url_file'.txt"	///
                     "`cache_dir'/`data_dict'", replace	
	}
	
    
	* import and parse data dictionary ----------------------------------------
	
	preserve
	
	quietly {
		infix str500 input 1-500  using "`cache_dir'/`data_dict'", clear
		replace input = strtrim(stritrim(input))
		split input, generate(value) parse(".")		// split by value definition (.)
		split input, generate(token)				// split by word
		// detect variable name rows
		// after 2017, data type was added to the variable name line of the 
		// data dictionary text file
		local varname_row_wordcount = cond(`year' < 2017, 2, 3) 	
		local varname_row_token = cond(`year' < 2017, "token3", "token4")
		generate is_varname = input[_n-1] == ""	&								///		
							  wordcount(input) == `varname_row_wordcount' & 	///
							  `varname_row_token' == "",						///
							  after(input)
		generate varname = lower(token1) if is_varname, after(is_varname)
		replace varname = varname[_n-1] if varname == ""	// fill down 				

		keep if !is_varname & value2 != "" &		/// 	/* not variable name rows 	*/
				inlist(varname, "occp", "indp") & 	///		/* is row for indp or occp 	*/
				!regexm(value1, "^b") & 			///		/* not missing value label 	*/
				!ustrregexm(input, "note", 1)				/* not a  note row 			*/
		split value2, generate(code) parse("-")
		rename (value1 code1) (value group)
		replace group = strtrim(stritrim(group))
		// deal with a few instances where group was left out of value label
		replace group = "" if strlen(group) > 4 & !ustrregexm(group, "unemployed", 1)
		replace group = group[_n-1] if group == ""
		keep varname group value
		compress
	}
	
    
	* make recode statement(s) ------------------------------------------------
	
	foreach var of local varlist {
		quietly levelsof group if varname == "`var'", local(groups)
		local recode_var "recode `var' "
		local i = 1
		foreach grp of local groups {
			local grp_name = cond(ustrregexm(`"`grp'"', "unemployed", 1), 		///
								  "unemp", 										///
								  lower("`grp'"))
			quietly levelsof value if group == `"`grp'"' & varname == "`var'", 	///
					 clean local("grp_codes")
			local ++i
			local level = `i' - 1
			local recode_var= `"`recode_var'"' + "(" + "`grp_codes'" + 		///
								"= " + "`level' " + `"""' + "`grp'" + `"""' + ") "
		}
		local recode_var = `"`recode_var'"' + ", prefix(`prefix')"
		local recode_`var' = `"`recode_var'"'
	}
	
    
	* run recode(s) -----------------------------------------------------------
	
	restore
	foreach var of local varlist {
		display as result "Recoding {bf:`var'} to {bf:`prefix'`var'} (this may take a few moments)..."
	}
	
end


