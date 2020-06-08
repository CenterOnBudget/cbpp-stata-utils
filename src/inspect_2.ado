
/***
Title
====== 

__inspect_2__ {hline 2} Summary statistics for positive, zero, negative, and missing values. 


Description
-----------

A cross between {help summarize} and {help inspect}, __inspect_2__ gives the frequency of positive, zero, negative, and missing values in a variable, as well as the mean, minimum, and maximum value of a variable within those categories and overall.

Users may specify the _save_ option to store the results in a matrix. The matrix (or matrices, if passing a {help varlist}) will be named _inspect_[varname]_.

{bf:fweight}s, {bf:iweight}s, and {bf:pweight}s are allowed; see {help weight}.


Syntax
------ 

> __inspect_2__ _{help varlist}_ [_{help if}_] [_{help weight}_], [__save__]


Example(s)
----------
  
		{bf:. inspect_2 pincp pearnp if agep >= 18 [fw=pwgtp]}
		 
		{bf:. inspect_2 thnetworth, save}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/


* capture program drop inspect_2

program define inspect_2

	syntax varlist [if] [fweight pweight iweight], [save]
	
	display "Warning from cbppstatautils developers: command name likely to change"
		
	foreach v of varlist `varlist' {
		
		tempvar v_l
		quietly {
			generate `v_l' = .
			replace `v_l' = 1 if `v' < 0		// negative
			replace `v_l' = 2 if `v' == 0		// zero
			replace `v_l' = 3 if `v' > 0		// positive
			replace `v_l' = 4 if missing(`v')	// missing
		}
		
		local if_rev = cond("`if'" != "", 			///
					"&" + substr("`if'", 3, .),		///
					"")
		
		tempname percents overall compiled results
		
		quietly mean i.`v_l' `if' [`weight' `exp']
		matrix `percents' = e(b)'
		
		quietly summarize `v' `if' [`weight' `exp']
		matrix `overall' = `r(N)', `r(sum_w)', 1, `r(mean)', `r(min)', `r(max)'
		
		quietly levelsof `v_l' `if', local(levels)
		
		foreach l of local levels {
			
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
				cspec(& %14s | %13.0fc & %8.4f | %13.0fc & %13.0fc & %13.0fc &) ///
				rspec(&|`rand'|&)
				
		if "`save'" != "" {
			matrix inspect_`v' = `results'
		}		
	}
		
end

