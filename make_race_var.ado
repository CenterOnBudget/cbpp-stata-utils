*! v 0.1.0	20200124


* TODO add option to create preferred AIAN variable for sub-group analyses


program make_race_var

	syntax name(name = new_varname), CATegories(integer) [DATAset(string)] [replace] [nolabel]
	
	* checks ------------------------------------------------------------------
	
	// check that categories is correctly specified
	if !inlist(`categories', 2, 4, 5, 6, 7, 8) {
		display `"{err}categories(`categories') invalid. Must be one of 2, 4, 5, 6, 7, or 8."'
		exit
	}
	
	if `categories' == 8 & "`dataset'" == "cps" {
		display `"categories(`categories') A maximum of 7 categories are available when using the CPS. Using 7 categories."'
	}
	
	// check that dataset is correctly specified
	local dataset = cond("`dataset'" == "", "acs", "`dataset'")
	if !(inlist("`dataset'", "acs", "cps")){
		display `"{err}dataset(`dataset') invalid. Must be one of acs or cps."'
		exit
	}
	
	// check that needed variable exist
	local needed_vars = cond("`dataset'" == "acs", "rac1p hisp", "prdtrace pehspnon")
	foreach var in `needed_vars' {
		capture confirm variable `var'
		if _rc != 0 {
			display `"{err}Variable `var' needed but not found."'
			exit
		}
	}
	
	// (optionally) drop new_varname if it already exists
	if "`replace'" != "" {
		capture drop `new_varname'
	}
	
	* acs ------------------------------------------------------------------

	if "`dataset'" == "acs" {
		quietly generate `new_varname' = 1 if rac1p == 1
		if `categories' == 2 {
			quietly replace `new_varname' = 2 if rac1p != 1 | hisp != 1
		}
		if `categories' >= 4 {
			quietly replace `new_varname' = 2 if rac1p == 2
			quietly replace `new_varname' = 4 if !inlist(rac1p, 1, 2)
		}
		if `categories' >= 5 {
			quietly replace `new_varname' = . if `new_varname' == 4
			quietly replace `new_varname' = 4 if rac1p == 6 
			quietly replace `new_varname' = 5 if !inlist(rac1p, 1, 2, 6)
		}
		if `categories' >= 6 {
			quietly replace `new_varname' = . if `new_varname' == 5
			quietly replace `new_varname' = 5 if inrange(rac1p, 3, 5) 
			quietly replace `new_varname' = 6 if !inrange(rac1p, 1, 6) 
		}
		if `categories' >= 7 {
			quietly replace `new_varname' = . if `new_varname' == 6
			quietly replace `new_varname' = 6 if rac1p == 7
			quietly replace `new_varname' = 7 if !inrange(rac1p, 1, 7)
		}
		
		if `categories' == 8 {
			quietly replace `new_varname' = . if `new_varname' == 7
			quietly replace `new_varname' = (rac1p - 1) if inlist(rac1p, 8, 9)
		}
		if `categories' > 2 {
			quietly replace `new_varname' = 3 if hisp != 1
		}
	}
	
	* cps ------------------------------------------------------------------

	if "`dataset'" == "cps" {
	
		generate `new_varname' = 1 if prdtrace == 1
		
		if `categories' == 2 {
			replace `new_varname' == 2 if prdtrace != 1 | pehspnon == 1
		}
		if `categories' >= 4 {
			replace `new_varname' = 2 if prdtrace == 2
			replace `new_varname' = 4 if !inlist(rac1p, 1, 2)
		}
		if `categories' >= 5 {
			replace `new_varname' = . if `new_varname' == 4
			replace `new_varname' = 4 if prdtrace == 4
			replace `new_varname' = 5 if !inlist(prdtrace, 1, 2, 4)
		}
		if `categories' >= 6 {
			replace `new_varname' = . if `new_varname' == 5
			replace `new_varname' = 5 if prdtrace == 3
			replace `new_varname' = 6 if !inrange(prdtrace, 1, 5)
		}
		if `categories' >= 7 {
			replace `new_varname' = . if `new_varname' == 6
			replace `new_varname' = 6 if prdtrace == 5
			replace `new_varname' = 7 if !inrange(prdtrace, 1, 5)
		}
		if `categories' > 2 {
			replace `new_varname' = 3 if pehspnon == 1
		}
	}
	
	* create label ------------------------------------------------------------
	
	if "`nolabel'" == "" {
	
		capture label drop `new_varname'_lbl
		
		label define `new_varname'_lbl 	1 "White Non-Hisp."
		
		if `categories' == 2 {
			label define `new_varname'_lbl 2 "Not White Non-Hisp.", add
		}
		if `categories' >= 4 {
			label define `new_varname'_lbl 2 "Black Non-Hisp.", add
		}
		if `categories' >= 5 {
			label define `new_varname'_lbl 4 "Asian Non-Hisp.", add
		}
		if `categories' >= 6 {
			label define `new_varname'_lbl 5 "AIAN Non-Hisp.", add
		}
		if `categories' >= 7 {
			label define `new_varname'_lbl 6 "NHPI Non-Hisp.", add
		}
		if `categories' == 8 & "`dataset'" == "acs" {
			label define `new_varname'_lbl 7 "Some Other Race Non-Hisp.", add
			label define `new_varname'_lbl 8 "Multiple Races Non-Hisp.", add
		}
		if inrange(`categories', 2, 7) {
			local acs_lbl_mod = cond("`dataset'" == "acs", "Another Race or ", "")
			label define `new_varname'_lbl `categories' "`acs_lbl_mod'Mult. Races Non-Hisp.", add
		}
		if `categories' > 2 {
			label define  `new_varname'_lbl 3 "Hispanic (of any race)", add
		}
		
		label values `new_varname' `new_varname'_lbl
	}
	
end
