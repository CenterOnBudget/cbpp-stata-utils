{smcl}

{title:Title}

{p 4 4 2}
{bf:get_cpiu} {hline 2} Retrieve annual inflation data series.



{title:Description}

{p 4 4 2}
{bf:get_cpiu} retreives annual CPI-U (the default) or CPI-U-RS data series from 
the  {browse "https://www.bls.gov/cpi/home.htm":Bureau of Labor Statistics}. The series 
may be loaded as a variable joined to existing data in memory, as a matrix, or 
as a new dataset replacing data in memory. 

{p 4 4 2}
Optionally, users can request inflation adjustment factors {hline 1} used to 
adjust nominal dollars to real dollars {hline 1} pegged to a given base year. 
For instance, {bf:get_cpiu, base_year(2018) clear} loads the CPI-U data series as
variable {c 39}cpiu{c 39} and also creates another variable, {c 39}cpiu_2018_adj{c 39}. Multiplying 
nominal dollar amounts by {c 39}cpiu_2018_adj{c 39} will yield 2018 inflation-adjusted 
dollar amounts. 

{p 4 4 2}
The program automatically caches the retreived data series. Users can load 
cached data by specifying {bf:use_cache}; {bf:get_cpiu} will display the date when
cached data was originally downloaded. To refresh the cached data with the 
latest available from the BLS, run {bf:get_cpiu} without {bf:use_cache} (you must
be connected to the internet). 

{p 4 4 2}
{bf:get_cpiu} supports annual (calendar year) average inflation series from 1978
to the latest available year.



{title:Syntax}

{p 8 8 2} {bf:get_cpiu}, [{bf:merge} {bf:clear} {bf:{cmdab:mat:rix}({it:matname})}] [{it:options}]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required: At least one of the following options must be specified}
	
	{synopt:{opt merge}}merge the inflations series into data in memory.{p_end}
	{synopt:{opt clear}}replace data in memory with the inflation series; cannot be combined with {bf:merge}.{p_end}
	{synopt:{opt mat:rix(matname)}}load the inflation series into a matrix.{p_end}
	
{syntab:Optional}
    {synopt:{opt rs}}load the CPI-U-RS, the preferred series for inflation-adjusting Census data.{p_end}
    {synopt:{opt b:ase_year(integer)}}requests that inflation-adjustment factors be included, and specifies the base year.{p_end}
	{synopt:{opt yearvar:name}}if {bf:merge} is specified, the variable on which to merge the inflation data into data in memory; default is 
	{opt yearvar(year)}.{p_end}
	{synopt:{opt nolab:el}}if {bf:merge} or {bf:replace} is specified, do not label inflation variables.{p_end}
	{synopt:{opt use_cache}}load cached inflation series data.{p_end}
{space 2}{synopt:{opt user_agent(string)}}email address to provide in the header of the HTTP request to the BLS website; passed to {help copy_curl}.{p_end} 



{title:Example(s)}

    Merge CPI-U data series into data in memory.
        {bf:. get_cpiu, merge}

    Load CPI-U-RS and inflation-adjustment factors for 2018 dollars into memory, clearing existing data in memory.
        {bf:. get_cpiu, rs base_year(2018) clear}

    Load cached CPI-U data series into a matrix named 'inflation'.
        {bf:. get_cpiu, matrix(inflation) use_cache}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




