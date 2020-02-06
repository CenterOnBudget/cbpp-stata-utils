*! v 0.1.0

/***
Title
====== 

__label_state__ {hline 2} Label state FIPS code variable with state names.


Description
-----------

__label_state__ labels state [FIPS code](https://www.census.gov/geographies/reference-files/2018/demo/popest/2018-fips.html) variables with the full state name.   
The 50 states, District of Columbia, and Puerto Rico are supported.


Syntax
------ 

> __label_state__ {it}{help varname}{sf}

If __varname__ is a string variable, it will be destringed.  
Defaults to _st,_ the American Community Survey PUMS variable for state FIPS codes.{p_end}


Example(s)
----------

    Label 'gestfips', the variable for state FIPS code in the CPS, with state names.
        {bf:. label_state gestfips}

Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -

This help file was dynamically produced by 
[MarkDoc Literate Programming package](http://www.haghish.com/markdoc/) 
***/

* capture program drop label_state


program label_state

	syntax varname

	version 8

	// confirm state variable exists
	confirm variable `varlist'
	
	// destring in case variable is string with leading zeros
	capture confirm string `varlist' 
	if _rc != 0 {
		quietly destring `varlist', replace 
	}
	
	// drop state_lbl if it exists
	capture label drop state_lbl			
	
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
	label values `varlist' state_lbl		
	

end
