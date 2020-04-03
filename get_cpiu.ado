*! v 0.1.0


/***
Title
====== 

__get_cpiu__ {hline 2} Retrieve annual inflation data series.


Description
-----------

__get_cpiu__ retreives annual CPI-U (the default) or CPI-U-RS data series from the [Bureau of Labor Statistics](https://www.bls.gov/cpi/home.htm). The series may be loaded as a variable joined to existing data in memory, as a matrix, or as a new dataset replacing data in memory. 

Optionally, users can request inflation adjustment factors--used to adjust nominal dollars to real dollars--pegged to a given base year. For instance, __get_cpiu, base_year(2018) clear__ loads the CPI-U data series as variable _cpiu_ and also creates another variable, _cpiu_2018_adj_ (clearing existing data in mnemory). Multiplying nominal dollar amounts by _cpiu_2018_adj_ yields 2018 inflation-adjusted dollar amounts. 

The program automatically caches the retreived data series. Users can load cached data by specifying the _use_cache_ option; __get_cpiu__ will display the date when cached data was originally downloaded. To refresh the cached data with the latest available from the BLS, run __get_cpiu__ without the _use_cache_ option.

__get_cpiu__ supports annual (calendar year) average inflation series from 1978 to the latest available year.


Syntax
------ 

> __get_cpiu__, [__merge__ __clear__ __matrix(_matname_)__] [_options_]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required: At least one of the following options must be specified}
	
	{synopt:{opt merge}}merge the inflations series into existing data in memory. Data in memory must have a variable named 'year'.{p_end}
	{synopt:{opt clear}}replace data in memory with the inflation series. Cannot be combined with 'merge'.{p_end}
	{synopt:{opt mat:rix(matname)}}load the inflation series into a matrix.{p_end}
	
{syntab:Optional}
    {synopt:{opt rs}}load the CPI-U-RS, the preferred series for inflation-adjusting Census data.{p_end}
    {synopt:{opt base_year(integer)}}requests that inflation-adjustment factors be included, and specifies the base year.{p_end}
	{synopt:{opt use_cache}}load cached inflation series data.{p_end}


Example(s)
----------

    Merge CPI-U data series into data in memory.
        {bf:. get_cpiu, merge}

    Load CPI-U-RS and inflation-adjustment factors for 2018 dollars into memory, clearing existing data in memory.
        {bf:. get_cpiu, rs base_year(2018) clear}

    Load cached CPI-U data series into a matrix named "inflation".
        {bf:. get_cpiu, matrix(inflation) use_cache}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/


* TODO enhancement: make sure this would work if used multiple times on the 
* same data i.e. generating inf factors for more than one year
* get_cpiu, base_year(2010)
* get_cpiu, base_year(2011)
* or would there even be a use case for that?

/* for debugging:
	capture program drop get_cpiu
	sysuse uslifeexp2.dta, clear
	replace year = year + 79
**/


program define get_cpiu

	syntax , [merge clear MATrix(name) base_year(integer 0) rs use_cache]

	* checks ------------------------------------------------------------------
	
	if "`merge'" == "" & "`clear'" == "" & "`matrix'" == "" {
		display as error "One of merge, clear, or matrix must be specified."
		exit
	}
	
	if "`merge'" != "" & "`clear'" != "" {
		display as error "Can't specify both 'merge' and 'clear'."
		exit
	}
	
	if "`merge'" != "" {
		capture confirm variable year
		if _rc != 0 {
			display as error "Data must contain a variable named 'year' in order to use the 'merge' option."
			exit
		}
	}
	
	local series = cond("`rs'" == "", "cpiu", "cpiu_rs")
	
	
	* set up cache directory --------------------------------------------------
	
	local cache_dir = cond("`c(os)'" == "Windows", 				///
						   "~/AppData/Local/cbppstatautils",	///
						   "~/Library/Application Support/cbppstatautils")
	capture mkdir "`cache_dir'"		
	local cache_path = "`cache_dir'//`series'.dta"
	
	
	* decide whether to download file -----------------------------------------
	
	// download if use_cache is not specified, 
	// or if use_cache is specified but the file does not exist
	
	if "`use_cache'" != "" {
		capture confirm file `"`cache_path'"'  // can't get fileexists to work...
	}
	
	local download = cond(_rc != 0 | "`use_cache'" == "", 1, 0)
	
	
	* download if needed, then load -------------------------------------------

	if "`clear'" == "" {
		preserve
	}
	
	if !`download' {
		use "`cache_dir'//`series'.dta", clear
	}
	
	if `download' { 

		if "`rs'" != "" {
			// CPI-U RS 1978-latest available
			copy "https://www.bls.gov/cpi/research-series/allitems.xlsx" 	///
				 "cpiu_rs.xlsx", replace
			// cell range will need to be updated each year when a new row is added
			quietly import excel using "cpiu_rs.xlsx", cellrange(A6:N49) firstrow case(lower) clear
			rename avg `series'
			keep year `series'
			quietly drop if missing(`series')
		}
		
		if "`rs'" == "" {
			// CPI-U 
			copy "https://download.bls.gov/pub/time.series/cu/cu.data.1.AllItems" 	///
				 "cpiu_current.txt", replace
			quietly import delimited using "cpiu_current.txt", clear
			quietly keep if regexm(series_id, "CUUR0000SA0")
			quietly keep if year >= 1978 & period == "M13"
			label variable value  // remove variable label of mysterious origin
			rename value `series'
			keep year `series'
		}
		
		// labelling the data has the nice side effect of displaying the 
		// downloaded date when the user loads cached data
		label data "Inflation series `series' last downloaded `c(current_date)'."
		quietly save "`cache_dir'//`series'.dta", replace
	}	

	
	* if base year provided, calculate adjustment factor ----------------------
	
	if `base_year' != 0 {
	
		// check that base year is present in series
		quietly levelsof year, local(years) separate("|")
		if !regexm("`base_year'", "`years'") {
			display as error "base_year(`base_year') invalid or unavailable."
			exit
		}
		// create adj fact variable
		quietly generate val_if_base_year = `series' if year == `base_year'
		egen val_of_base_year = max(val_if_base_year)
		quietly generate `series'_`base_year'_adj =  val_of_base_year / `series'
		drop val_*_base_year

	}
	
	// prep for next step
	tempfile temp
	quietly save `temp'
	

	* create matrix and restore if matrix() specified -------------------------
	
	if "`matrix'" != "" {
		local mat_vars = cond("`base_year'" != "", 						///
							  `"`series' `series'_`base_year'_adj"', 	///
							  "`series'")
		mkmat `mat_vars', matrix("`matrix'") rownames(year)
		restore
	}
	
	* restore and merge if 'merge' specified ----------------------------------
	
	if "`merge'" != "" {
		restore
		merge m:1 year using `temp', nogenerate keep(master match) nolabel noreport
	}
	
	
end
