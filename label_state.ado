*! v 1.0.2 	20200124
*! description Label state FIPS code variable with state names.


* TODO 
* instead of specifying variable name, specify dataset acs or cps? 
*	then var is st if acs and gestfips if cps?

program label_state

	version 8
	
	// default to 'st', the ACS state FIPS code variable, otherwise user input
	if ("`1'" == "") local state_var = "st"		
	else local state_var = "`1'"
	
	// confirm state variable exists
	capture confirm variable `state_var'
	if _rc {
			display `"{err}Variable `state_var' needed but not found."'
			exit
	}
	
	// destring in case variable is string with leading zeros
	qui destring `state_var', replace 	
	
	// drop state_lbl if it exists
	cap label drop state_lbl			
	
	// define label
	#delimit ;							
	label define state_lbl	 
	1	"Alabama"
	2	"Alaska"
	4	"Arizona"
	5	"Arkansas"
	6	"California"
	8	"Colorado"
	9	"Connecticut"
	10	"Delaware"
	11	"District of Columbia"
	12	"Florida"
	13	"Georgia"
	15	"Hawaii"
	16	"Idaho"
	17	"Illinois"
	18	"Indiana"
	19	"Iowa"
	20	"Kansas"
	21	"Kentucky"
	22	"Louisiana"
	23	"Maine"
	24	"Maryland"
	25	"Massachusetts"
	26	"Michigan"
	27	"Minnesota"
	28	"Mississippi"
	29	"Missouri"
	30	"Montana"
	31	"Nebraska"
	32	"Nevada"
	33	"New Hampshire"
	34	"New Jersey"
	35	"New Mexico"
	36	"New York"
	37	"North Carolina"
	38	"North Dakota"
	39	"Ohio"
	40	"Oklahoma"
	41	"Oregon"
	42	"Pennsylvania"
	44	"Rhode Island"
	45	"South Carolina"
	46	"South Dakota"
	47	"Tennessee"
	48	"Texas"
	49	"Utah"
	50	"Vermont"
	51	"Virginia"
	53	"Washington"
	54	"West Virginia"
	55	"Wisconsin"
	56	"Wyoming"
	72	"Puerto Rico" ;
	#delimit cr
	
	// apply label
	label values `state_var' state_lbl		

end
