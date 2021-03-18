
/***
Title
====== 

__get_cpiu__ {hline 2} Retrieve annual inflation data series.


Description
-----------

__get_cpiu__ retreives annual CPI-U (the default) or CPI-U-RS data series from the [Bureau of Labor Statistics](https://www.bls.gov/cpi/home.htm). The series may be loaded as a variable joined to existing data in memory, as a matrix, or as a new dataset replacing data in memory. 

Optionally, users can request inflation adjustment factors {hline 1} used to adjust nominal dollars to real dollars {hline 1} pegged to a given base year. For instance, __get_cpiu, base_year(2018) clear__ loads the CPI-U data series as variable 'cpiu' and also creates another variable, 'cpiu_2018_adj'. Multiplying nominal dollar amounts by 'cpiu_2018_adj' will yield 2018 inflation-adjusted dollar amounts. 

The program automatically caches the retreived data series. Users can load cached data by specifying __use_cache__; __get_cpiu__ will display the date when cached data was originally downloaded. To refresh the cached data with the latest available from the BLS, run __get_cpiu__ without __use_cache__ (you must be connected to the internet). 

__get_cpiu__ supports annual (calendar year) average inflation series from 1978 to the latest available year.


Syntax
------ 

> __get_cpiu__, [__merge__ __clear__ __{cmdab:mat:rix}(_matname_)__] [_options_]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required: At least one of the following options must be specified}
	
	{synopt:{opt merge}}merge the inflations series into data in memory.{p_end}
	{synopt:{opt clear}}replace data in memory with the inflation series; cannot be combined with {bf:merge}.{p_end}
	{synopt:{opt mat:rix(matname)}}load the inflation series into a matrix.{p_end}
	
{syntab:Optional}
    {synopt:{opt rs}}load the CPI-U-RS, the preferred series for inflation-adjusting Census data.{p_end}
    {synopt:{opt base_year(integer)}}requests that inflation-adjustment factors be included, and specifies the base year.{p_end}
	{synopt:{opt yearvar:name}}if __merge__ is specified, the variable on which to merge the inflation data into data in memory; default is {opt yearvar(year)}.{p_end}
	{synopt:{opt nolab:el}}if __merge__ or __replace__ is specified, do not label inflation variables.{p_end}
	{synopt:{opt use_cache}}load cached inflation series data.{p_end}


Example(s)
----------

    Merge CPI-U data series into data in memory.
        {bf:. get_cpiu, merge}

    Load CPI-U-RS and inflation-adjustment factors for 2018 dollars into memory, 
	clearing existing data in memory.
        {bf:. get_cpiu, rs base_year(2018) clear}

    Load cached CPI-U data series into a matrix named 'inflation'.
        {bf:. get_cpiu, matrix(inflation) use_cache}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -
{it:This help file was dynamically produced by {browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package}.}
***/


/* for debugging:
	sysuse uslifeexp2.dta, clear
	replace year = year + 79
**/

* capture program drop get_cpiu

program define get_cpiu

	syntax , [merge clear MATrix(name) YEARVARname(string) base_year(integer 0) rs use_cache NOLABel]

	* checks ------------------------------------------------------------------
	
	if "`merge'" == "" & "`clear'" == "" & "`matrix'" == "" {
		display as error "must specify one of {bf:merge}, {bf:clear}, or {bf:matrix()}"
		exit 198
	}
	
	if "`merge'" != "" & "`clear'" != "" {
		display as error "{bf:merge} and {bf:clear} may not be combined"
		exit 184
	}
	if "`merge'" == "" & "`yearvarname'" != "" {
    	display as error "{bf:yearvarname()} may only be specified with {bf:merge}"
		exit 198
    }
    
	if "`merge'" != "" {
    	if "`yearvarname'" != "" {
		confirm variable `yearvarname'
        }
        if "`yearvarname'" == "" {
        	local yearvarname "year"
        }
	}
	
	local series = cond("`rs'" == "", "cpiu", "cpiu_rs")
	
	
	* set up cache directory --------------------------------------------------
	
	local cache_dir = cond("`c(os)'" == "Windows", 				///
						   "~/AppData/Local/cbppstatautils",	///
						   "~/Library/Application Support/cbppstatautils")
	capture mkdir "`cache_dir'"	
	
	local cache_path = "`cache_dir'/`series'.dta"
	
	
	* decide whether to download file -----------------------------------------
	
	// download if use_cache is not specified, 
	// or if use_cache is specified but the file does not exist
    
    capture confirm file "`cache_dir'/`series'.dta"
    local download = (_rc != 0) | ("`use_cache'" == "")
	
	
	* download if needed, then load -------------------------------------------

	if "`clear'" == "" {
		preserve
	}
	
	if !`download' {
		use "`cache_dir'/`series'.dta", clear
	}
	
	if `download' {
    	
    	quietly {
		
            tempfile data // tempfile for retrieved data
            
            if "`rs'" != "" {
                // CPI-U RS 1978-latest available
                copy "https://www.bls.gov/cpi/research-series/allitems.xlsx" `data'
                // cell range will need to be updated each year when a new row is added
                import excel using `data', cellrange(A6:N49) firstrow case(lower) clear
                rename avg `series'
                keep year `series'
                drop if missing(`series')
            }
            
            if "`rs'" == "" {
                // CPI-U 
                copy "https://download.bls.gov/pub/time.series/cu/cu.data.1.AllItems" `data'
                import delimited using `data', clear
                keep if regexm(series_id, "CUUR0000SA0")
                keep if year >= 1978 & period == "M13"
                label variable value  // remove variable label of mysterious origin
                rename value `series'
                keep year `series'
            }
            
            // labelling the data has the nice side effect of displaying the 
            // downloaded date when the user loads cached data
            label data "Inflation series `series' last downloaded `c(current_date)'."
			note : Inflation series `series' last downloaded `c(current_date)'.
            save "`cache_dir'/`series'.dta", replace
        }
	}	

	
	* if base year provided, calculate adjustment factor ----------------------
	
	if `base_year' != 0 {
	
		// check that base year is present in series
		quietly levelsof year, local(years) separate("|")
		if !ustrregexm("`base_year'", "`years'") {
			display as error "{bf:base_year()} invalid or unavailable"
			exit 198
		}
		// create adj fact variable
		quietly generate val_if_base_year = `series' if year == `base_year'
		egen val_of_base_year = max(val_if_base_year)
		quietly generate `series'_`base_year'_adj =  val_of_base_year / `series'
		drop val_*_base_year

	}
	
	// label variables
	if "`nolabel'" == "" {
		local series_nm = cond("`rs'" == "", "CPI-U", "CPI-U-RS")
		local lbl = 												///
			cond("`merge'" != "",									///
				 "`series_nm' for observation year '`yearvarname''",	///
				 "`series_nm'")
		label variable `series' "`lbl'"
		if `base_year' != 0 {
			local lbl = 														///
				cond("`merge'" != "", 											///
					 "`series_nm' inflator for observation year `yearvarname'' to `base_year'",	///
					 "`series_nm' inflator to `base_year'")
			label variable `series'_`base_year'_adj "`lbl'"
		}
	}
	
	// prep for next step
	tempfile temp
	quietly save `temp'
	

	* create matrix and restore if matrix() specified -------------------------
	
	if "`matrix'" != "" {
		local mat_vars = cond(`base_year' != 0, 						///
							  `"`series' `series'_`base_year'_adj"', 	///
							  "`series'")
		mkmat `mat_vars', matrix("`matrix'") rownames(year)
		restore
	}
	
	* restore and merge if merge specified ----------------------------------
	
	if "`merge'" != "" {
		if "`matrix'" == "" {
			restore
		}
        if "`yearvarname'" != "year" {
        	quietly generate year = `yearvarname'
        }
		merge m:1 year using `temp', nogenerate keep(master match) nolabel noreport
        if "`yearvarname'" != "year" {
        	quietly drop year
        }
	}
	
end


