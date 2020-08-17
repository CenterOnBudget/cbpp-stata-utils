
/***
Title
====== 

__svyset_acs__ {hline 2} Declare the survey design for ACS PUMS.


Description
-----------

__svyset_acs__ is a shortcut program to declare the survey design for ACS PUMS.

When used with _record_type(person)_, it is the equivalent to typing:

>	svyset [iw=pwgtp], vce(sdr) sdrweight(pwgtp1-pwgtp80) mse


Syntax
------ 

> __svyset_acs__, __{cmdab:rec:ord_type}(_string_)__ [_options_]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
	{synopt:{opt rec:ord_type(string)}}record type weight to use: person or household. Abbreviations h, hhld, hous, p, and pers are also accepted.{p_end}
	
{syntab:Optional}
    {synopt:{opt nosdr:weights}}do not declare SDR replicate weights in the survey design.{p_end}


Example(s)
----------

	Survey set household-level ACS PUMS data.  
		{bf:. svyset_acs, record_type(hhld)}

	Survey set person-level ACS PUMS data without replicate weights.  
		{bf:. svyset_acs, record_type(person) nosdrweights}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -
{it:This help file was dynamically produced by {browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package}.}
***/


* capture program drop svyset_acs

program svyset_acs

	syntax , RECord_type(string) [NOSDRweights]
	
	if !inlist("`record_type'", "p", "pers", "person", "h", "hh", "hous", "hhld", "household") {
		display as error "{bf:record_type()} must be person, household, their respective supported abbreviations, or both"
		exit 198
	}
	
	local record_type = cond(inlist("`record_type'", "p", "pers", "person"), "p", "h")
	local weight = cond("`record_type'" == "p", "pwgtp", "wgtp")
	
	confirm variable `weight'
	
	if "`nosdrweights'" == "" {
		capture {
			forvalues r = 1/80 {
				confirm variable `weight'`r'
			}
		}
		if _rc != 0 {
			display as error "one or more replicate weight variables (`weight'1-`weight'80) not found"
			exit 111
		}
		svyset [iw=`weight'], vce(sdr) sdrweight(`weight'1-`weight'80) mse
	}
	
	if "`nosdrweights'" != "" {
		svyset [iw=`weight']
	}

end



