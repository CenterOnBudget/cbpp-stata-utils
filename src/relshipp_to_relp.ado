*! version 0.2.0


/***
Title
====== 

__relshipp_to_relp__ {hline 2} Convert ACS microdata variable 'relshipp' to 'relp'.


Description
-----------

__relshipp_to_relp__ converts 'relshipp', the ACS microdata relationship 
variable in 2019 and later samples, to 'relp', the relationship variable in 
earlier samples. 

In a dataset containing only 'relshipp', __relshipp_to_relp__ will recode 
'relshipp' to generate 'relp'. In a dataset containing both 'relshipp' and 
'relp' (e.g., a dataset formed by appending 2019 or later and 2018 or earlier 
samples), __relshipp_to_relp__ will invisibly recode 'relshipp' and, for 
observations where 'relshipp' is not missing, copy the contents into 'relp'. 

By default, __relshipp_to_relp__ will create a value label for 'relp' if it does
not already exist.

Syntax
------ 

> __relshipp_to_relp__ , [{cmdab:nolab:el}]


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


***/


capture program drop relshipp_to_relp

program define relshipp_to_relp

	syntax , [NOLABel]
	
	confirm variable relshipp

	tempvar placeholder
	
	quietly recode relshipp 	///
		   (20 = 0)		///
		   (21 23 = 1)	///
		   (22 24 = 13)	///
		   (25 = 2)		///
		   (26 = 3)		///
		   (27 = 4)		///
		   (28 = 5)		///
		   (29 = 6)		///
		   (30 = 7)		///
		   (31 = 8)		///
		   (32 = 9)		///
		   (33 = 10)	///
		   (34 = 11)	///
		   (35 = 14)	///
		   (36 = 15)	///
		   (37 = 16 )	///
		   (38 = 17),	///
		   generate(`placeholder')
			   
	capture confirm variable relp
	if _rc == 0 {
	    quietly count if !missing(relp) & !missing(relshipp)
		if `r(N)' != 0 {
		    display as error "some observations have non-missing values of both {bf:relp} and {bf:relshipp}" 
			exit 110
		}
		replace relp = `placeholder' if !missing(`placeholder')
		local relp_lbl : value label relp
	}
	if _rc != 0 {
	    generate relp = `placeholder'
	}
	
	if "`nolabel'" == "" & "`relp_lbl'" == "" {
	    capture label drop relp_lbl
		label define relp_lbl 						///
			   0 "Reference person"					///
			   1 "Husband/wife"						///
			   13 "Unmarried partner"				///
			   2 "Biological son or daughter"		///
			   3 "Adopted son or daughter"			///
			   4 "Stepson or stepdaughter"			///
			   5 "Brother or sister"				///
			   6 "Father or mother"					///
			   7 "Grandchild"						///
			   8 "Parent-in-law"					///
			   9 "Son-in-law or daughter-in-law"	///
			   10 "Other relative"					///
			   11 "Roommate or housemate"			///
			   14 "Foster child"					///
			   15 "Other nonrelative"				///
			   16 "Institutionalized group quarters population"	///
			   17 "Noninstitutionalized group quarters population" 
		label values relp relp_lbl
	}

end


