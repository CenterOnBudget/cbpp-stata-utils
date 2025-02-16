*! version 0.2.0


/***
Title
====== 

__etotal__ {hline 2} Flexible counts and totals.


Description
-----------

An extension of {help total}, __etotal__ produces either totals or counts, 
depending on what the user has specified.

If weights are specified, or if data are {help svyset} and the __svy__ option 
is specified, standard errors and confidence intervals are included.


Syntax
------ 

Count of observations

> __etotal__ [_{help if}_] {weight} [, _options_]

Total of existing variable

> __etotal__ [_{varname}_] [_{help if}_] {weight} [, _options_]

Total of expression

> __etotal__ [_{help exp}_] [_{help if}_] {weight} [, _options_]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
  {synopt:{opth over(varname)}}Group over subpopulations defined by {it:varname}.{p_end}
  {synopt:{opt svy}}Adjust the results for survey settings identified by {bf:{help svyset}}.{p_end}
  {synopt:{opt level(#)}}Set confidence level; default is {opt level(95)}.{p_end}
  {synopt:{opth cformat(%fmt)}}Specifies how to format estimates, standard errors, and confidence limits; deftault is {opt cformat(%14.0fc)}.{p_end}
  {synopt:{opt mat:rix(matname)}}Save results in matrix _matname_.{p_end}
{synoptline}


{bf:fweight}s, {bf:iweight}s, and {bf:pweight}s are allowed; see {help weight}.


Example(s)
----------

    Weighted count of observations  
    
        {bf:. etotal [iw=wgtp]}

    Total of existing variable  
    
        {bf:. etotal hincp if relp == 0 [iw=wgtp]}
  
    Total of existing variable, data is svyset  
    
        {bf:. etotal hincp, svy}

    Total of expression, saving results in matrix  
    
        {bf:. etotal hincp / 1000 [iw=wgtp], matrix(tot_hh_inc_thous)}


Website
-------

[centeronbudget.github.io/cbpp-stata-utils](https://centeronbudget.github.io/cbpp-stata-utils/)

***/


* capture program drop etotal

program define etotal

  syntax [anything] [if] [fweight pweight iweight], ///
    [svy] [level(cilevel)] [over(varname numeric)] ///
    [MATrix(name)] [cformat(string)]


  if "`svy'" != "" {
    local is_svyset = `"`r(settings)'"' != ", clear"
    if !`is_svyset' {
      display as error "data not set up for svy, use {help svyset}"
      exit 119
    }
    if "`weight'" != "" {
      display as error "weights not allowed with {bf:svy}"
      exit 184
    }
    local svy "svy:"
  }

  tempname results tally_all tally_by


  **# Value labels for matrix (if over is specified -------------------------
  
  if "`over'" != "" {
    local over_lbl_nm : value label `over'
    if "`over_lbl_nm'" != "" {
      quietly levelsof `over' `if', local(over_lvls)
      local over_lbls ""
      foreach l of local over_lvls {
        local lbl : label `over_lbl_nm' `l'
        local lbl = ustrregexra("`lbl'", "\.", "")
        local lbl = usubstr("`lbl'", 1, 32)
        local over_lbls = `"`over_lbls'"' + " " + `"""' + "`lbl'" + `"""'
      }
      local over_lbls = `"`over_lbls'"' + `""Overall""'
    }
  }

  
  **# Total -----------------------------------------------------------------
  
  if "`anything'" != "" {
    
    **## Total of an expression --------------------------------------------

    local rx_arithm "(\+)|(-)|(\*)|(/)|(\^)"
    local rx_logic "(\&)|(\|)|(\!)|(~)"
    local rx_rel "(>)|(<)|(<=)|(>=)|(==)|(!=)|(~=)"
    
    local rxm_arithm = ustrregexm("`anything'", "`rx_arithm'")
    local rxm_if = ustrregexm("`anything'", "`rx_logic'|`rx_rel'")
    
    if `rxm_arithm' == 1 | `rxm_if' == 1 {
      tempvar tally_var
      generate `tally_var' = `anything'
    }
    
    **## Total of an existing variable --------------------------------------

    capture confirm variable `anything'
    if _rc == 0 {
      local tally_var `anything'
    }
    
    **## Compute total ------------------------------------------------------
    
    quietly `svy' total `tally_var' `if' [`weight' `exp'], level(`level')
    matrix `tally_all' = r(table)'
    
    if "`over'" == "" {
      matrix `results' = `tally_all'
    }
    
    if "`over'" != "" {
      quietly `svy' total `tally_var' `if' [`weight' `exp'],  ///
        over(`over') level(`level')
      matrix `tally_by' = r(table)'
      matrix `results' = `tally_by' \ `tally_all'
    }
  }
  
  
  **# Count -----------------------------------------------------------------
  
  if "`anything'" == "" {

    **## Unweighted count ---------------------------------------------------
    
    if ("`weight'" == "") & ("`svy'" == "")  {
      
      if "`over'" == "" {
        quietly count `if'
        matrix `results' = `r(N)'
      }
      
      if "`over'" != "" {
        quietly tabulate `over' `if', matcell(`tally_by')
        matrix `results' = `tally_by' \ `r(N)'
      }
    }
    
    **## Weighted count -----------------------------------------------------
    
    if ("`weight'" != "") | ("`svy'" != "") {
      
      tempvar tally_var
      quietly generate `tally_var' = 1
      quietly `svy' total `tally_var' `if' [`weight' `exp'], level(`level')
      matrix `tally_all' = r(table)'
      
      if "`over'" == "" {
        matrix `results' = `tally_all'
      }
      
      if "`over'" != "" {
        quietly `svy' total i.`over' `if' [`weight' `exp'], level(`level')
        matrix `tally_by' = r(table)'
        matrix `results' = `tally_by' \ `tally_all'
      }
    }
  }
  
    
  **# Format results --------------------------------------------------------
  
  local cformat = cond("`cformat'" == "", "%14.0fc", "`cformat'")
  
  if ("`weight'" == "") & ("`svy'" == "") {
    matrix `results' = `results'[1..., 1]
    local first_colname = cond("`anything'" == "", "Count:", "Total:")
    matrix colnames `results' = "`first_colname'" 
    local cspec "& %14s | `cformat' &"
  }
  
  if ("`weight'" != "") | ("`svy'" != "") {
    local first_colname =   ///
      cond("`anything'" == "", "Weighted Count:", "Total:")
    matrix `results' = `results'[1..., 1..2] , `results'[1..., 5..6]
    matrix colnames `results' = ///
      "`first_colname'"  ///
      "Std. Err.:"  ///
      "[`level'% Conf. Interval]:lb"  ///
      "[`level'% Conf. Interval]:ub" 
    local cspec "& %14s | `cformat' | `cformat' | `cformat' & `cformat' &"
  }
  
  if "`over'" == "" {
    local rspec "&|&"
    local names "columns"
    local cspec = ustrregexra("`cspec'", "%14s \|", "")
  }
  
  if "`over'" != "" {
    local rand = "&" * (rowsof(`results') - 2)
    local rspec "&|`rand'|&"
    if `"`over_lbls'"' != "" {
      matrix rownames `results' = `over_lbls'
    }
  }
  
  
  **# Display results -------------------------------------------------------
  
  local title = cond("`anything'" != "", "{bf:`anything'}", "{bf:observations}")
  local title = cond("`over'" != "", "`title'" + " over {bf:`over'}", "`title'")
            
  matlist `results',  ///
    title("`title'") tindent(3) names("`names'")  ///
    showcoleq(combined) coleqonly ///
    rspec("`rspec'") cspec("`cspec'")
  
  if "`e(vcetype)'" != "" {
    display _newline _skip(3) "note: `e(vcetype)' variance estimation"
  }
  
  if "`matrix'" != "" {
    matrix `matrix' = `results'
  }
  
end


