*! version 0.2.0


/***
Title
====== 

__generate_race_var__ {hline 2} Generate categorical race-ethnicity variable for
CPS or ACS microdata.


Description
-----------

__generate_race_var__ generates a categorial variable for race-ethnicity. It can
be used with CPS or ACS microdata. Users may specify the desired number of 
categories: 2, 4-7 for CPS and 2, 4-8 for ACS.


Syntax
------ 

__generate_race_var__ _{help newvar}_, __{cmdab:cat:egories}(_integer_)__ __{cmdab:data:set}(_string_)__ [_options_]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Required}
	{synopt:{opt cat:egories(integer)}}number of values for the categorical variable to be generated.{p_end}
	{synopt:{opt data:set(string)}}CPS or ACS (case insensitive).{p_end}
	
{syntab:Optional}
    {synopt:{opt nolab:el}}{it:newvar} will not be labelled.{p_end}


Category Definitions / Labels
-----------------------------

{p2colset 4 22 22 2}
{p2col:{bf}categories({it:2}){sf}}1 	White, not Latino
								  2 	Not White, not Latino{p_end}

{p2col:{bf}categories({it:4}){sf}}1 	White, not Latino		
								  2 	Black, not Latino
								  3 	Latino (of any race)
								  4 	Another Race or Mult. Races, not Latino{p_end}

{p2col:{bf}categories({it:5}){sf}}1 	White, not Latino		
								  2 	Black, not Latino
								  3 	Latino (of any race)
								  4		Asian, not Latino
								  5 	Another Race or Mult. Races, not Latino{p_end}

{p2col:{bf}categories({it:6}){sf}}1 	White, not Latino		
								  2 	Black, not Latino
								  3 	Latino (of any race)
								  4		Asian, not Latino
								  5 	AIAN, not Latino
								  6 	Another Race or Mult. Races, not Latino{p_end}

{p2col:{bf}categories({it:7}){sf}}1 	White, not Latino		
								  2 	Black, not Latino
								  3 	Latino (of any race)
								  4		Asian, not Latino
								  5 	AIAN, not Latino
								  6 	NHOPI, not Latino
								  7 	 __ACS:__ Another Race or Mult. Races, not Latino 
								  7		 __CPS:__ Mult. Races, not Latino{p_end}

{p2col:{bf}categories({it:8}){sf}}1 	White, not Latino{p_end}
{p2col:{it:ACS only}}2 	Black, not Latino
								  3 	Latino (of any race)
								  4		Asian, not Latino
								  5 	AIAN, not Latino
								  6 	NHOPI, not Latino
								  7 	Some Other Race, not Latino 
								  8		Mutliple Races{p_end}
{p2colreset}{...}

	
Example(s)
----------

   Generate a 5-category race-ethnicity variable 'race_5' for ACS microdata.
        {bf:. generate_race_var race_5, categories(5) dataset(acs)}

    Generate an unlabeled 2-category (person of color/white, not Latino) race-ethnicity variable for CPS microdata.
        {bf:. generate_race_var person_of_color, categories(2) dataset(cps) nolabel}

		
Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


***/


* capture program drop generate_race_var

program generate_race_var

	syntax newvarname, CATegories(integer) DATAset(string) [NOLABel replace]
    
    
    local newvar `varlist'
	
    
	* checks ------------------------------------------------------------------
	
    // check that dataset is correctly specified
	local dataset = lower("`dataset'")
	if !(inlist("`dataset'", "acs", "cps")){
		display as error "{bf:dataset()} must be acs or cps (case insensitive)"
		exit 198
	}
    
    // check that categories-dataset combination is valid
    local max_categories = cond("`dataset'" == "acs", 8, 7)
    numlist "2 4(1)`max_categories'"
    local valid_categories = ustrregexra("`r(numlist)'", " ", ", ")
    if !inlist(`categories', `valid_categories'){
        display as error "{bf:categories()} must be one of `valid_categories' if {bf:dataset()} is `dataset'"
		exit 198
    }	
 
	// check that needed variable exist
	local needed_vars = cond("`dataset'" == "acs", "rac1p hisp", "prdtrace pehspnon")
    confirm variable `needed_vars'
	
	
	* generate variables ------------------------------------------------------

	if "`dataset'" == "acs" {
        quietly {
			generate `newvar' = 1 if rac1p == 1
			if `categories' == 2 {
				replace `newvar' = 2 if rac1p != 1 | hisp != 1
			}
			if `categories' >= 4 {
				replace `newvar' = 2 if rac1p == 2
				replace `newvar' = 4 if !inlist(rac1p, 1, 2)
			}
			if `categories' >= 5 {
				replace `newvar' = . if `newvar' == 4
				replace `newvar' = 4 if rac1p == 6 
				replace `newvar' = 5 if !inlist(rac1p, 1, 2, 6)
			}
			if `categories' >= 6 {
				replace `newvar' = . if `newvar' == 5
				replace `newvar' = 5 if inrange(rac1p, 3, 5) 
				replace `newvar' = 6 if !inrange(rac1p, 1, 6) 
			}
			if `categories' >= 7 {
				replace `newvar' = . if `newvar' == 6
				replace `newvar' = 6 if rac1p == 7
				replace `newvar' = 7 if !inrange(rac1p, 1, 7)
			}
			
			if `categories' == 8 {
				replace `newvar' = . if `newvar' == 7
				replace `newvar' = (rac1p - 1) if inlist(rac1p, 8, 9)
			}
			if `categories' > 2 {
				replace `newvar' = 3 if hisp != 1
			}
			replace `newvar' = . if missing(rac1p) | missing(hisp)
		}
    }

	if "`dataset'" == "cps" {
		quietly {
			generate `newvar' = 1 if prdtrace == 1
			if `categories' == 2 {
				replace `newvar' = 2 if prdtrace != 1 | pehspnon == 1
			}
			if `categories' >= 4 {
				replace `newvar' = 2 if prdtrace == 2
				replace `newvar' = 4 if !inlist(prdtrace, 1, 2)
			}
			if `categories' >= 5 {
				replace `newvar' = . if `newvar' == 4
				replace `newvar' = 4 if prdtrace == 4
				replace `newvar' = 5 if !inlist(prdtrace, 1, 2, 4)
			}
			if `categories' >= 6 {
				replace `newvar' = . if `newvar' == 5
				replace `newvar' = 5 if prdtrace == 3
				replace `newvar' = 6 if !inrange(prdtrace, 1, 4)
			}
			if `categories' >= 7 {
				replace `newvar' = . if `newvar' == 6
				replace `newvar' = 6 if prdtrace == 5
				replace `newvar' = 7 if !inrange(prdtrace, 1, 5)
			}
			if `categories' > 2 {
				replace `newvar' = 3 if pehspnon == 1
			}
			replace `newvar' = . if missing(prdtrace) | missing(pehspnon)
		}
	}
	
    
	* create labels -----------------------------------------------------------
	
	if "`nolabel'" == "" {
	
		capture label drop `newvar'_lbl
		
		label define `newvar'_lbl 	1 "White, not Latino"
		
		if `categories' == 2 {
			label define `newvar'_lbl 2 "Not White, not Latino", add
		}
		if `categories' >= 4 {
			label define `newvar'_lbl 2 "Black, not Latino", add
		}
		if `categories' >= 5 {
			label define `newvar'_lbl 4 "Asian, not Latino", add
		}
		if `categories' >= 6 {
			label define `newvar'_lbl 5 "AIAN, not Latino", add
		}
		if `categories' >= 7 {
			label define `newvar'_lbl 6 "NHOPI, not Latino", add
		}

		if inrange(`categories', 3, 6) {
			label define `newvar'_lbl `categories' "Another Race or Mult. Races, not Latino", add
		}
		
		if `categories' == 7 {
			local acs_mod = cond("`dataset'" == "acs", "Another Race or ", "")
			label define `newvar'_lbl 7 "`acs_mod'Mult. Races, not Latino.", add
		}
		
		if `categories' == 8 & "`dataset'" == "acs" {
			label define `newvar'_lbl 7 "Some Other Race, not Latino.", add
			label define `newvar'_lbl 8 "Multiple Races, not Latino.", add
		}
		
		if `categories' > 2 {
			label define  `newvar'_lbl 3 "Latino (of any race)", add
		}
		
		label values `newvar' `newvar'_lbl
	}
	
end


