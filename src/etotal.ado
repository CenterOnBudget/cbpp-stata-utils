
/***
Title
====== 

__etotal__ {hline 2} Flexible counts and totals.


Description
-----------

An extension of {help total}, __etotal__ produces either totals or counts, depending on what the user has specified. If weights are specified, standard errors and confidence intervals are included.


Syntax
------ 

Count of observations

> __etotal__ [_{help if}_] [_{help weight}_], _options_

Total of existing variable

> __etotal__ [_{help varname}_] [_{help if}_] [_{help weight}_], _options_

Total of expression

> __etotal__ [_{help exp}_] [_{help if}_] [_{help weight}_], _options_


{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
    {synopt:{opth over(varname)}}group over subpopulations defined by {it:varname}.{p_end}
    {synopt:{opt level(#)}}set confidence level; default is {bf:level(95)}.{p_end}
	{synopt:{opt mat:rix(string)}}save results in matrix named _string_.{p_end}
{synoptline}

{bf:fweight}s, {bf:iweight}s, and {bf:pweight}s are allowed; see {help weight}.


Example(s)
----------

    Weighted count of observations  
        {bf:. etotal [iw=wgtp]}

    Total of existing variable  
        {bf:. etotal hincp [iw=wgtp]}

    Total of expression, saving results in matrix  
        {bf:. etotal hincp / 1000 [iw=wgtp], matrix(tot_hh_inc_thous)}

Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -
{it:This help file was dynamically produced by {browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package}.}
***/


capture program drop etotal

program define etotal

	syntax [anything] [if] [fweight pweight iweight], 	                   ///
		   [level(cilevel)] [over(varname numeric)] [MATrix(name)]
    
    
	* if over is specified, get value labels for results matrix ---------------
	
	if "`over'" != "" {
	    local over_lbl_nm : value label `over'
		if "`over_lbl_nm'" != "" {
			quietly levelsof `over' `if', local(over_lvls)
			local over_lbls ""
			foreach l of local over_lvls {
				local lbl : label `over_lbl_nm' `l'
				local over_lbls = `"`over_lbls'"' + " " + `"""' + "`lbl'" + `"""'
			}
			local over_lbls = `"`over_lbls'"' + `""Overall""'
		}
	}
	
	
	* define temporary matrices -----------------------------------------------
	
	tempname results tally_all tally_by
	
	
	* 1. user wants a total of something: -------------------------------------
	
	if "`anything'" != "" {
	    
		* 1.1. an expression -> tally_var evaluates to that expression --------
		
		local rx_arithm "(\+)|(-)|(\*)|(/)|(\^)"
		local rx_logic "(\&)|(\|)|(\!)|(~)"
		local rx_rel "(>)|(<)|(<=)|(>=)|(==)|(!=)|(~=)"
		
		local rxm_arithm = ustrregexm("`anything'", "`rx_arithm'")
		local rxm_if = ustrregexm("`anything'", "`rx_logic'|`rx_rel'")
		
		if `rxm_if' == 1 {
			display as yellow "Next time, put logical or relational expressions in [{bf:if}]."
		}
		
		if `rxm_arithm' == 1 | `rxm_if' == 1 {
			tempvar tally_var
			generate `tally_var' = `anything'
		}
		
		* 1.2. a preexisting variable -> tally_var is that variable -----------
		
		capture confirm variable `anything'
		if _rc == 0 {
		    local tally_var `anything'
		}
		
		* 1.3. create results for totals --------------------------------------
		
	    quietly total `tally_var' `if' [`weight' `exp'], level(`level')
		matrix `tally_all' = r(table)'
		
		if "`over'" == "" {
		    matrix `results' = `tally_all'
		}
		
		if "`over'" != "" {
		    quietly total `tally_var' `if' [`weight' `exp'],    ///
                          over(`over') level(`level')
			matrix `tally_by' = r(table)'
			matrix `results' = `tally_by' \ `tally_all'
		}
	}
	
	
	* 2. user wants a count: --------------------------------------------------
	
	if "`anything'" == "" {
	    
		* 2.1. an unweighted count -> use count -------------------------------
		
		if "`weight'" == ""  {
			
			if "`over'" == "" {
			    quietly count `if'
				matrix `results' = `r(N)'
			}
			
			if "`over'" != "" {
			    quietly tabulate `over' `if', matcell(`tally_by')
				matrix `results' = `tally_by' \ `r(N)'
			}
		}
		
		// 2.2. a weighted count -> tally_var is 1 ----------------------------
		
		if "`weight'" != "" {
		    
			tempvar tally_var
			quietly generate `tally_var' = 1
			quietly total `tally_var' `if' [`weight' `exp'], level(`level')
			matrix `tally_all' = r(table)'
			
			if "`over'" == "" {
			    matrix `results' = `tally_all'
			}
			
			if "`over'" != "" {
			    quietly total i.`over' `if' [`weight' `exp'], level(`level')
				matrix `tally_by' = r(table)'
				matrix `results' = `tally_by' \ `tally_all'
			}
		}
	}
	
    
	* format results ----------------------------------------------------------
	
	if "`weight'" == "" {
	    matrix `results' = `results'[1..., 1]
		local first_colname = cond("`anything'" == "", "Count:", "Total:")
		matrix colnames `results' = "`first_colname'" 
		local cspec "& %14s | %15.0fc &"
	}
	
	if "`weight'" != "" {
		local first_colname = cond("`anything'" == "", 			        ///
								   "Weighted Count:", 			        ///
								   "Total:")
		matrix `results' = `results'[1..., 1..2] , 				        ///
						   `results'[1..., 5..6]
		matrix colnames `results' = "`first_colname'" 			        ///
									"Std. Err.:" 				        ///
									"[`level'% Conf. Interval]:lb"  	///
									"[`level'% Conf. Interval]:ub" 
		local cspec "& %14s | %15.0fc | %13.0fc | %13.0fc & %13.0fc &"
	}
	
	if "`over'" == "" {
	    local rspec "&|&"
		if "`anything'" != "" {
		    if `rxm_arithm' == 1 | `rxm_if' == 1 {
				matrix rownames `results' = "`anything'"
			}
		}
		if "`anything'" == "" {
		    matrix rownames `results' = "obs"
		}
	}
	
	if "`over'" != "" {
	    local rand = "&" * (rowsof(`results') - 2)
		local rspec "&|`rand'|&"
		if "`over_lbls'" != "" {
			matrix rownames `results' = `over_lbls'
		}
	}
	
	
	* display and save --------------------------------------------------------
	
	matlist `results', showcoleq(combined) coleqonly  		///
					   rspec("`rspec'") cspec("`cspec'")
	display ""
		
	if "`matrix'" != "" {
	    matrix `matrix' = `results'
	}
	
end


