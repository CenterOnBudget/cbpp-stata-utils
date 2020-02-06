*! v 0.1.0 	20200127
*! description Apply adjustment factors 'adjinc' and 'adjhsg' to ACS microdata.

program apply_acs_adj_factors

	syntax [anything], [PREfix(string)] [SUFFix(string)]
	
	if "`prefix'" != "" & "`suffix'" != "" {
		display `"{err}Either a prefix or suffix can be supplied, not both."'
		exit
	}
	
	if "`prefix'" == "" & "`suffix'" == "" {
		local prefix ""
		local suffix "_adj"
	}

	local inc_vars "pincp pernp wagp ssp ssip intp pap oip retp semp fincp hincp"
	local hous_vars "conp elep fulp gasp grntp insp mhp mrgp smocp rntp smp watp"
	
	foreach var in `inc_vars' {
		capture confirm variable `var'
		if !_rc != 0 {
			quietly generate `prefix'`var'`suffix' = `var' * adjinc / 1000000 
		}
	}
	
	foreach var in `hous_vars' {
			capture confirm variable `var'
		if !_rc != 0 {
			quietly generate `prefix'`var'`suffix' = `var' * adjhsg / 1000000 
		}
	}


end
