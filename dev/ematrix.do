
load_data acs, year(2018) var(st pincp sex rac1p pwgtp) clear
keep if st == 11 

mean pincp, over(sex rac1p)
matrix results = e(b)'
matlist results



local n_var : word count `e(varlist)'
if `n_var' > 1 {
	display as error "too many var"
}
local n_over : word count `e(over)'
if `n_over' > 2 {
	display as error "too many over"
}

local over_var_1 : word 1 of `e(over)'
local over_var_2 : word 2 of `e(over)'

quietly levelsof `over_var_1' if e(sample), local(over_lvls_1) clean
quietly levelsof `over_var_2' if e(sample), local(over_lvls_2) clean

local exportexcel 1

local over_lbls ""
foreach lvl_1 of local over_lvls_1 {
	local lbl_1: label (`over_var_1') `lvl_1' 
	foreach lvl_2 of local over_lvls_2 {
		local lbl_2: label (`over_var_2') `lvl_2'
		if `exportexcel' == 0 {
			local lbl_1 = substr("`lbl_1'", 1, 16)
			local lbl_2 = substr("`lbl_2'", 1, 16)
		}
		local over_lbl = `"""' + "`lbl_1', `lbl_2'" + `"""'
		local over_lbls = `"`over_lbls'"' + " " + `"`over_lbl'"'

	}
}

display `"`over_lbls'"'

if `exportexcel' == 0 {
	matrix rownames results = `over_lbls'
}

if `exportexcel' == 1 {

local cell = "A1"
local col = ustrregexra("`cell'", "\d", "")
local row = ustrregexra("`cell'", "[^\d]", "")

if "`names'" != "" | "`rownames'" != "" {
	local r = `row' + 1
	foreach l of local over_lbls {
		putexcel `col'`r' = "`l'"
		local r = `r' + 1
	}
}

if "`title'" != "" {
	local title = strupper(substr("`e(cmdline)'", 1, 1)) + 	///
				  substr("`e(cmdline)'", 2, .)
	putexcel `cell' = "`title'"
	}
}




putexcel set "test.xlsx", replace
putexcel A1 = matrix(results), names




foreach l of local lvls_rac1p {
			local lab2: label sex_lbl `l2'
	foreach l2 of local lvls_sex {
		local lab1: label rac1p_lbl `l'

		di "`lab2' `lab1'"
	}
}


decode rac1p, generate(rac1p_str)
decode sex, generate(sex_str)
generate label = sex_str + ", " + rac1p_str
sort sex rac1p


local n_rows_1 : rowsof lvls_sex
local n_rows_2 : rowsof lvls_rac1p
forvalues r = 1/`n_rows_1' {
    matrix lvls_sex_`r' = J(`n_rows_2', 1, lvls_sex[`r', 1])
	matrix lvls = 
}




egen test = group(sex rac1p), label lname()

local rownames : rownames results
local n_rownames : rowsof results
forvalues n = 1/`n_rownames' {
    local rowname : word `n' of `rownames'
	local varname = substr("`rowname'", 					///
						   (strpos("`rowname'", ".") + 1), 	///
						   (strpos("`rowname'", "@") - 3))

	di "`varname'"
	local nums = ustrregexra("`rowname'", "(bn\.)|([A-Za-z])|((?<=\.)(.*)$)", "")
	di "`nums'"

}


local varnames = ustrregexra("c.pincp@2.sex#5.rac1p", "", "")
di "`varnames'"



capture program drop ematrix

program define ematrix

	syntax name, [COLumns(string)]
	
	capture confirm matrix r(table)
	if _rc != 0 {
		display as error "Estimation results not found."
		exit 301
	}
	
	capture confirm matrix `namelist'
	if _rc == 0 {
		display as error "Matrix `name' already exists."
	}
	
	if "`columns'" == "" {
		local columns "b se ll ul cv moe n"
		
	}
	foreach c of local columns {
		local `c' "`c'"
	}	
	
	tempname table
	
	matrix `table' = r(table)'
	
	if "`moe'" != "" {
		local colnames: colnames `table'
		matrix `table' = `table' , ((`table'[1..., "ul"] - `table'[1..., "ll"]) / 2)
		matrix colnames `table' = `colnames' "moe"
	}
	
	if "`cv'" != "" {

		local colnames : colnames `table'
		
		if "`e(prefix)'" == "svy" {
			estat cv
			matrix `table' = `table' , r(cv)'
		}
		else {
			local nrows : rowsof(`table')
			local ncols : colsof(`table')		
			local newcol = `ncols' + 1		
			matrix `table' = `table' , (J(`nrows', 1, .))
			forvalues r = 1/`nrows' {
				local cv = (`table'[`r', "se"] / `table'[`r', "b"]) * 100
				matrix `table'[`r', `newcol'] = `cv'
			}
		}	
		matrix colnames `table' = `colnames' "cv"
	}
	
	if "`n'" != "" {
		local colnames : colnames `table'
		matrix `table' = `table' , e(_N)'
		matrix colnames `table' = `colnames' "n"
	}

	foreach c of local columns {
		matrix `namelist' = nullmat(`namelist') , `table'[1..., "`c'"]
	}
	

end

matrix drop _all
set trace off
use "${spdatapath}HPS/hps_wk7.dta", clear
svyset [iw=pweight], vce(sdr) sdrweight(pweight1-pweight80) mse
svy: total income, over(rrace)
set trace on
ematrix results, columns(b se moe z)
set trace off

