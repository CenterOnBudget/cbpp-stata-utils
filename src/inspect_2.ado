
/***
Title
====== 

__inspect_2__ {hline 2} Summary statistics for positive, zero, negative, and missing values. 


Description
-----------

A cross between {help summarize} and {help inspect}, __inspect_2__ gives the frequency of positive, zero, negative, and missing values in a variable, as well as the mean, minimum, and maximum value of a variable within those categories and overall.

Results may be stored in a matrix (or matrices, if _varlist_ is multiple variables) by specifying matrix name(s) in the _matrix()_ option.


Syntax
------ 

> __inspect_2__ _{help varlist}_ [_{help if}_] [_{help weight}_], [__matrix(names)__]

{bf:fweight}s, {bf:iweight}s, and {bf:pweight}s are allowed; see {help weight}.


Example(s)
----------
  
		{bf:. inspect_2 pincp pearnp if agep >= 18 [fw=pwgtp]}
		 
		{bf:. inspect_2 thnetworth, save}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -
{it:This help file was dynamically produced by {browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package}.}
***/


* capture program drop inspect_2

program define inspect_2

	syntax varlist(numeric) [if] [fweight pweight iweight], 	///
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
		tempname percents overall compiled results
		
		// percent by temp cat
		quietly mean i.`v_l' `if' [`weight' `exp']
		matrix `percents' = e(b)'
		
		// overall
		quietly summarize `v' `if' [`weight' `exp']
		matrix `overall' = `r(N)', `r(sum_w)', 1, `r(mean)', `r(min)', `r(max)'
		
		// count, total, min and max by temp cat
		
		quietly levelsof `v_l' `if', local(levels)

		foreach l of local levels {
			
			local if_rev = cond("`if'" != "", 					///
								"&" + substr("`if'", 3, .),		///
								"")
								
			if `l' != 4 {
				quietly summarize `v' [`weight' `exp'] if `v_l' == `l' `if_rev'
				matrix v_`l'_mat = `r(N)', `r(sum_w)', `r(mean)', `r(min)', `r(max)'
			}
			
			if `l' == 4 {
				quietly count if `v_l' == `l' `if_rev'
				local n = `r(N)'
				if "`weight'" != "" {
					tempvar obs
					capture generate `obs' = 1
					quietly total `obs' [`weight' `exp'] if `v_l' == `l' `if_rev'
					local n_w = e(b)[1, 1]
				}
				if "`weight'" == "" {
					local n_w .
				}
				matrix v_`l'_mat = `n', `n_w', ., ., .
			}
			
			matrix `compiled' = nullmat(`compiled') \ v_`l'_mat
			
			capture matrix drop v_`l'_mat
		}
		
		// compile results
		
		if "`weight'" != "" {
			matrix `results' = `compiled'[1..., 2] , 		///
							   `percents'[1..., 1] , 		///
							   `compiled'[1..., 3...] \		///
							   `overall'[1..., 2...]
		}

		if "`weight'" == "" {
			matrix `results' = `compiled'[1..., 1] , 		///
							   `percents'[1..., 1] , 		///
							   `compiled'[1..., 3...] \		///
							   `overall'[1..., 1], 			///
							   `overall'[1..., 3...]
		}
		
		// display formatted results
		
		matrix colnames `results' = Total Percent Mean Min Max
		
		tempname temp_lbl
		label define `temp_lbl' 1 "Negative" 2 "Zero" 3 "Positive" 4 "Missing", replace
		local results_rownames ""
		foreach l of local levels {
			local l_lbl : label `temp_lbl' `l'
			local results_rownames = "`results_rownames'" + " " + "`l_lbl'"
		}
		local results_rownames = "`results_rownames'" + " " + "Overall"
		label drop `temp_lbl'
		matrix rownames `results' = `results_rownames'

		local rand = "&" * (rowsof(`results') - 2)
		
		matlist `results', 	///
				title(`v') 	///
				cspec(& %14s | %11.0fc & %8.4f | %11.0fc & %11.0fc & %11.0fc &) ///
				rspec(&|`rand'|&)
		display ""
		
		// save as matrix(ces) if specified
		if "`matnames'" != "" {
			local matname : word `i' of `matnames'
			matrix `matname' = `results'
			local i = `i' + 1
		}		
	}
		
end

