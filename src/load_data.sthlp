{smcl}

{title:Title}

{p 4 4 2}
{bf:load_data} {hline 2} Load data from CBPP{c 39}s datasets library into memory.



{title:Description}

{p 4 4 2}
{bf:load_data} loads CPS, ACS, ACS SPM, SNAP QC, or Household Pulse Survey microdata from a CBPP datasets library into memory.

{p 4 4 2}
This command is only useful for CBPP staff.

{p 4 4 2}
To use load_data, first:

{p 8 10 2}{c 149} Sync the datasets library to your laptop.

{p 8 10 2}{c 149} Add CBPP{c 39}s global macros to your profile.do with {help make_cbpp_profile}.

{p 4 4 2}
Multiple years of data may be loaded at once by specifying a list of years to 
the {bf:years()} option. Variable and value labels from the maximum year will be 
retained.

{p 4 4 2}
When loading multiple years of ACS data, if the range of {bf:years()} spans the 
introduction of string characters to serialno in 2018, serialno will be edited 
("00" and "01" will be substituted for "HU" and "GQ", respectively) and 
destringed. 



{title:Syntax}

{p 4 4 2}
{bf:load_data} {it:dataset} [{it:{help if}}], {opt y:ears(numlist)} [{it:options}]

{p 4 4 2}
where {it:dataset} is "cps", "acs", "acs-spm", "qc", or "pulse" (case insensitive).


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
{space 2}{synopt:{opth y:ears(numlist)}}Year(s) of data to load. When {it:dataset} is "cps", {bf:years()} refers to the survey (data release) year.{p_end}
{space 2}{synopt:{opth v:ars(varlist)}}Variables to load; default is all.{p_end}
{space 2}{synopt:{opth w:eeks(numlist)}}Alias for {bf:years()}; for use when {it:dataset} is "pulse".{p_end}
{space 2}{synopt:{opth p:eriod(integer)}}With {it:dataset} "qc" and {opt year(2020)}, period of data to load: 1 for the pre-pandemic period or 2 for the waiver period.{p_end}
{space 2}{synopt:{opth saveas(filename)}}Save dataset to file.{p_end}
{space 2}{synopt:{opt replace}}When {bf:saveas()} is specified, replace existing dataset.{p_end}
{space 2}{synopt:{opt clear}}Replace the data in memory, even if the current data have not been saved to disk.{p_end}
{synoptline}



{title:Example(s)}

    Load March 2023 CPS ASEC microdata.  

      {bf:. load_data cps, year(2023)}

    Load a subset of variables from ACS microdata for 2019, 2021, and 2022.  

      {bf:. load_data acs, years(2019 2021/2022) vars(serialno sporder st agep povpip pwgtp)}

    Load SNAP QC microdata for 2019.  

      {bf:. load_data qc, years(2019)}

    Load Household Pulse Survey microdata for weeks 61-63. 

      {bf:. load_data pulse, weeks(61/63)}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




