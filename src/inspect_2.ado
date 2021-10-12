*! version 0.2.0


/***
Title
====== 

__inspect_2__ {hline 2} Summary statistics for positive, zero, negative, and 
missing values. 


Description
-----------

A cross between {help summarize} and {help inspect}, __inspect_2__ gives the 
frequency of positive, zero, negative, and missing values in a variable, as well
as the mean, minimum, and maximum value of a variable within those categories 
and overall.

Results may be stored in a matrix (or matrices, if _varlist_ is multiple 
variables) by specifying matrix name(s) to __matrix()__.


Syntax
------ 

> __inspect_2__ _{help varlist}_ [_{help if}_] [_{help weight}_], [{opt matrix(names)}]

{bf:fweight}s and {bf:iweight}s are allowed; see {help weight}.


Example(s)
----------
  
		{bf:. inspect_2 thnetworth}
		
		{bf:. inspect_2 pincp pernp if agep >= 18 [fw=pwgtp], matrix(pincp_mat pernp_mat)}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


***/


* capture program drop inspect_2

program define inspect_2

	syntax varlist(numeric) [if] [fweight iweight], 	///
							[matrix(namelist)]
	
	
	display as result "Warning from cbppstatautils developers: command name likely to change"
		
	local matnames "`matrix'"
	

	* checks ------------------------------------------------------------------
	
	if "`matnames'" != "" {
		// check right number of matrix names for number of variables
		local n_vars : word count `varlist'
		local n_mats : word count `matnames'
		if `n_vars' != `n_mats' {
			display as error "{it:varlist} and {it:matrix} mismatch"
			display as error "You specified or implied `n_vars' variables and `n_mats' matrix names"
			exit 198
		}
	}
	
	local i 1	// counter to match with matnames
		
	foreach v of varlist `varlist' {
		
		// create a temporary categorical variable 
		tempvar v_l
		quietly {
			generate `v_l' = .
			replace `v_l' = 1 if `v' < 0		// negative
			replace `v_l' = 2 if `v' == 0		// zero
			replace `v_l' = 3 if `v' > 0		// positive
			replace `v_l' = 4 if missing(`v')	// missing
		}
		
		// define temporary matrices
		tempname percent overall level by_level results
		
		// percent by temp cat
		quietly mean i(1/4).`v_l' `if' [`weight' `exp']
		matrix `percent' = e(b)'
		local pct_nonmiss = 1 - `percent'[4, 1]
		matrix `percent' = `percent' \ `pct_nonmiss'

		// overall
		quietly summarize `v' `if' [`weight' `exp']
		local total_n = cond("`weight'" == "", `r(N)', `r(sum_w)')
		matrix `overall' = `total_n', `r(mean)', `r(min)', `r(max)'
		
		// count, total, min and max by temp cat
		local if_rev = cond("`if'" != "", 					///
							"&" + substr("`if'", 3, .),		///
							"")
		foreach l of numlist 1/4 {
		    quietly summarize `v' if `v_l' == `l' `if_rev' [`weight' `exp']
			if `l' != 4 {
				local total_n = cond("`weight'" == "", `r(N)', `r(sum_w)')
			}
		    if `l' == 4 {
				quietly total i4.`v_l' `if' [`weight' `exp']
				local total_n = e(b)[1, 1]
			}
			foreach s in mean min max {
			    capture confirm scalar r(`s')
				local `s' = cond(_rc == 0, r(`s'), .)
			}
			matrix `level' = `total_n', `mean', `min', `max'
			matrix `by_level' = nullmat(`by_level') \ `level'
		}
		
		// compile results
		
		matrix `results' =  `by_level' \ `overall'
		matrix `results' = `results'[1..., 1] , `percent', `results'[1..., 2...]
		matrix `results' = `results'[1..3, 1...] \ `results'[5, 1...] \ `results'[4, 1...]
						   
		// format and display
		matrix colnames `results' = "Obs" "Percent" "Mean" "Min" "Max"
		matrix rownames `results' = "Negative" "Zero" "Positive" "All Nonmissing" "Missing"
		matlist `results', 	///
				title(`v') 	///
				cspec(& %14s | %11.0fc & %8.4f | %11.0fc & %11.0fc & %11.0fc &) ///
				rspec(&|&&||&)
		display ""
		
		// save as matrix(ces) if specified
		if "`matnames'" != "" {
			local matname : word `i' of `matnames'
			matrix `matname' = `results'
			local i = `i' + 1
		}		
	}
		
end

