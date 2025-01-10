*! version 0.2.0


/***
Title
====== 

__acs_relshipp_to_relp__ {hline 2} Recode __relshipp__ to __relp__ in ACS microdata.


Description
-----------

__acs_relshipp_to_relp__ converts __relshipp__, the household relationship 
variable in ACS microdata from 2019 to present, to __relp__, the relationship 
variable in earlier samples.

In a dataset containing only __relshipp__, __acs_relshipp_to_relp__ will recode 
__relshipp__ to generate __relp__.

In a dataset containing both __relshipp__ and __relp__ (for example, a dataset 
formed by appending 2019 or later and 2018 or earlier samples), 
__acs_relshipp_to_relp__ will, for observations where __relp__ is missing and 
__relshipp__ is not, populate __relp__ with recoded values of __relshipp__.

By default, __acs_relshipp_to_relp__ will create a value label for __relp__ if 
one does not already exist.

Syntax
------ 

__acs_relshipp_to_relp__ [, {opt nolab:el}]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
  {synopt:{opt nolab:el}}Do not assign value labels to __relp__.{p_end}
{synoptline}


Website
-------

[centeronbudget.github.io/cbpp-stata-utils](https://centeronbudget.github.io/cbpp-stata-utils/)

***/


* capture program drop acs_relshipp_to_relp
* capture program drop relshipp_to_relp

program define acs_relshipp_to_relp

  syntax , [NOLABel]
  
  confirm variable relshipp

  tempvar placeholder
  
  quietly recode relshipp ///
    (20    =  0)  ///
    (21 23 =  1)  ///
    (22 24 = 13)  ///
    (25    =  2)  ///
    (26    =  3)  ///
    (27    =  4)  ///
    (28    =  5)  ///
    (29    =  6)  ///
    (30    =  7)  ///
    (31    =  8)  ///
    (32    =  9)  ///
    (33    = 10)  ///
    (34    = 12)  ///
    (35    = 14)  ///
    (36    = 15)  ///
    (37    = 16 ) ///
    (38    = 17), ///
    generate(`placeholder')
  
  capture confirm variable relp
  if _rc == 0 {
    quietly count if !missing(relp) & !missing(relshipp)
    if `r(N)' != 0 {
      display as error "some observations have non-missing values of both {bf:relp} and {bf:relshipp}" 
      exit 110
    }
    replace relp = `placeholder' if !missing(`placeholder')
    local relp_lbl : value label relp
  }
  if _rc != 0 {
    generate relp = `placeholder'
  }
  
  if "`nolabel'" == "" & "`relp_lbl'" == "" {
    capture label drop relp_lbl
    label define relp_lbl             ///
       0 "Reference person"           ///
       1 "Husband/wife"               ///
      13 "Unmarried partner"          ///
       2 "Biological son or daughter" ///
       3 "Adopted son or daughter"    ///
       4 "Stepson or stepdaughter"    ///
       5 "Brother or sister"          ///
       6 "Father or mother"           ///
       7 "Grandchild"                 ///
       8 "Parent-in-law"              ///
       9 "Son-in-law or daughter-in-law"  ///
      10 "Other relative"             ///
      12 "Roommate or housemate"      ///
      14 "Foster child"               ///
      15 "Other nonrelative"          ///
      16 "Institutionalized group quarters population"  ///
      17 "Noninstitutionalized group quarters population" 
    label values relp relp_lbl
  }

end

* Alias
program define relshipp_to_relp
  syntax , [NOLABel]
  acs_relshipp_to_relp, `nolabel'
end
