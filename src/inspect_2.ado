*! version 0.2.0


/***
Title
====== 

__inspect_2__ {hline 2} Summary statistics for positive, zero, negative, and missing values.


Description
-----------

A cross between {help summarize} and {help inspect}, {bf:inspect_2} gives the 
frequency of positive, zero, negative, and missing values in a variable, as well 
as the mean, minimum, and maximum value of a variable within those categories and 
overall.

Results may be stored in a matrix (or matrices, if _varlist_ is multiple 
variables) by specifying matrix name(s) to __matrix()__.


Syntax
------ 

__inspect_2__ {varlist} [_{help if}_] {weight} [, _options_]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
  {synopt:{opt mat:rix(matname)}}Store results in matrix _matname_. If multiple variables are specified in _varlist_, a list of matrix names in which to store the results.{p_end}
{synoptline}


{bf:fweight}s and {bf:iweight}s are allowed; see {help weight}.


Example(s)
----------

    Inspect a single variable.
    
        {bf:. inspect_2 thnetworth}
    
    Inspect multiple variables, storing the results in matrices.
    
        {bf:. inspect_2 pincp_adj pernp_adj, matrix(pincp_mat pernp_mat)}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


***/


* capture program drop inspect_2

program define inspect_2

  syntax varlist(numeric) [if] [fweight iweight], [matrix(namelist)]
  
  local matnames "`matrix'"
  
  * Checks number of matnames matches number of variables
  if "`matnames'" != "" {
    local n_vars : word count `varlist'
    local n_mats : word count `matnames'
    if `n_vars' != `n_mats' {
      display as error "{it:varlist} and {it:matrix} mismatch"
      display as error "You specified or implied `n_vars' variables and `n_mats' matrix names"
      exit 198
    }
  }
  
  * Counter to match with matnames
  local i 1  
  
  foreach v of varlist `varlist' {
    
    * Temporary variable for types of values 
    tempvar v_l
    quietly {
      generate `v_l' = .
      replace `v_l' = 1 if `v' < 0      // Negative
      replace `v_l' = 2 if `v' == 0     // Zero
      replace `v_l' = 3 if `v' > 0      // Positive
      replace `v_l' = 4 if missing(`v') // Missing
    }
    
    * Temporary matrices
    tempname percent overall level by_level results
    
    * Percent of obervations by type of value
    quietly mean i(1/4).`v_l' `if' [`weight' `exp']
    matrix `percent' = e(b)'
    local pct_nonmiss = 1 - `percent'[4, 1]
    matrix `percent' = `percent' \ `pct_nonmiss'

    * Overall count of observations
    quietly summarize `v' `if' [`weight' `exp']
    local total_n = cond("`weight'" == "", `r(N)', `r(sum_w)')
    matrix `overall' = `total_n', `r(mean)', `r(min)', `r(max)'
    
    * Count, total, minimum and maximum by type of value
    local if_rev =  ///
      cond("`if'" != "", "&" + substr("`if'", 3, .), "")
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
    
    * Compile results
    matrix `results' =  `by_level' \ `overall'
    matrix `results' = `results'[1..., 1] , `percent', `results'[1..., 2...]
    matrix `results' = `results'[1..3, 1...] \ `results'[5, 1...] \ `results'[4, 1...]

    * Format and display
    matrix colnames `results' = "Obs" "Percent" "Mean" "Min" "Max"
    matrix rownames `results' = "Negative" "Zero" "Positive" "All Nonmissing" "Missing"
    matlist `results',  ///
      title(`v')  ///
      cspec(& %14s | %11.0fc & %8.4f | %11.0fc & %11.0fc & %11.0fc &) ///
      rspec(&|&&||&)
    display ""
    
    * Save matrixes if specified
    if "`matnames'" != "" {
      local matname : word `i' of `matnames'
      matrix `matname' = `results'
      local i = `i' + 1
    }    
  }
    
end

