*! v 0.1.0

/***
Title
====== 

__generate_acs_adj_vars__ {hline 2} Generate versions of ACS microdata's income and housing variables appropriately adjusted by 'adjinc' or 'adjhsg'.


Description
-----------

__generate_acs_adj_vars__ generates adjusted versions of all of the income or housing variables needing adjustment that are found in the user's dataset.
 
Adjusted versions of variables are named as the original with the suffix "_adj" by default (e.g. __pincp_adj__), or users may supply a prefix or suffix. 

See the [ACS PUMS data dictionary](https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/PUMSDataDict16.pdf?#) for a list of variables to which 'adjinc' or 'adjhsg' are applied. In the 2005-2007 PUMS samples, a single adjustment factor, 'adjust', is used for both income and housing variables. If using PUMS samples from those years, use the __pre_2008__ option to specify that variables should be adjusted using 'adjust'.


Syntax
------ 

> __generate_acs_adj_vars__ , [__prefix(_string_) suffix(_string_) pre_2008__]

{synopt:{opt pre:fix(string)}}prefix to prepend to the variable name.{p_end}
{synopt:{opt suf:fix(string)}}suffix to append to the or variable name. Defaults to "_adj".{p_end}


Example(s)
----------

    Create adjusted versions of all relevant ACS variables.  
        {bf:. generate_acs_adj_vars}

    Create adjusted versions of all relevant ACS variables, prefixed with "adj", in a pre-2008 PUMS sample.  
        {bf:. generate_acs_adj_vars, prefix(adj) pre_2008}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -
This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/


* capture program drop generate_acs_adj_vars


program define generate_acs_adj_vars

	syntax , [PREfix(string) SUFfix(string) pre_2008]
		
	* checks ------------------------------------------------------------------
	
	if "`prefix'" != "" & "`suffix'" != "" {
		display as error "Either a prefix or suffix can be supplied, not both."
		exit
	}
	
	if "`prefix'" == "" & "`suffix'" == "" {
		local prefix ""
		local suffix "_adj"
	}
	
	local adj_inc = cond("`pre_2008'" == "", adjinc, adjust)
	local adj_hsg = cond("`pre_2008'" == "", adjhsg, adjust)
		
	local inc_vars "pincp pernp wagp ssp ssip intp pap oip retp semp fincp hincp"
	local hous_vars "conp elep fulp gasp grntp insp mhp mrgp smocp rntp smp watp"
	
	foreach var in `inc_vars' {
		capture confirm variable `var'
		if !_rc != 0 {
			// redundant to confirm `adj_*' every loop, but how else to do it without 
			// asking the user to specify the record type of data in memory...
			confirm variable `adj_inc'  
			quietly generate `prefix'`var'`suffix' = `var' * `adj_inc' / 1000000 
		}
	}
	
	foreach var in `hous_vars' {
			capture confirm variable `var'
		if !_rc != 0 {
			confirm variable `adj_hsg'  
			quietly generate `prefix'`var'`suffix' = `var' * `adj_hsg' / 1000000 
		}
	}

end
