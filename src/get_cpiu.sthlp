{smcl}

{title:Title}

{p 4 4 2}
{bf:get_cpiu} {hline 2} Load CPI-U or R-CPI-U-RS price index data series into memory or a matrix.



{title:Description}

{p 4 4 2}
get_cpiu retrieves annual average CPI-U (the default) or
{browse "https://www.bls.gov/cpi/research-series/r-cpi-u-rs-home.htm":R-CPI-U-RS} 
(formerly CPI-U-RS) data series from the Bureau of Labor Statistics. The series 
may be loaded as a variable joined to existing data in memory, as a matrix, or as 
a new dataset replacing data in memory.

{p 4 4 2}
Users may request inflation adjustment factors based on the retrieved price index 
be generated. Inflation adjustment factors are used to convert current (nominal) 
dollars into constant (real) dollars. The {bf:base_year()} option specifies which 
year to use as the base year for the inflation adjustment factor. For example, 
{bf:get_cpiu, base_year(2022)} clear will load into memory the CPI-U data series 
as variable {bf:cpiu} and generate {bf:cpiu_2022_adj}. Users may then multiply a 
variable containing nominal dollar values by {bf:cpiu_2022_adj} to obtain the 
values in 2022 constant dollars.

{p 4 4 2}
Data series are automatically cached. Users can load the cached data rather than 
re-downloading it by specifying {bf:use_cache}. Note that price indices are 
occasionally back-revised. When loading cached data, {bf:get_cpiu} will display 
the date when the was originally downloaded. To refresh the cached data with the 
latest available data, run {bf:get_cpiu} without the {bf:use_cache} option.



{title:Syntax}

{p 4 4 2}
{bf:get_cpiu}, { {bf:merge} | {opt mat:rix(matname)} | {bf:clear} } [{it:options}]


{synoptset 20}{...}
{synopthdr:options}
{synoptline}
{space 2}{synopt:{opt merge}}Merge the data into the dataset in memory.{p_end}
{space 2}{synopt:{opt mat:rix(matname)}}Load data into matrix {it:matname}.{p_end}
{space 2}{synopt:{opt clear}}Load the data into memory, replacing the dataset currently in memory. Cannot be combined with {bf:merge}.{p_end}
{space 2}{synopt:{opt rs}}Retrieve the R-CPI-U-RS. If unspecified, the CPI-U will be retrieved.{p_end}
{space 2}{synopt:{opt b:ase_year(integer)}}Create inflation-adjustment factors from nominal dollars to real dollars, using the specified base year.{p_end}
{space 2}{synopt:{opt yearvar}}If {bf:merge} is specified, the key variable on which to merge the data into the dataset in memory. Default is {opt yearvar(year)}.{p_end}
{space 2}{synopt:{opt nolab:el}}Do not attach variable labels to the retrieved data. May only be specified with {bf:merge} or {bf:clear}.{p_end}
{space 2}{synopt:{opt use_cache}}Use data from the cache if it exists. An internet connection is required to retrieve data when {bf:use_cache} is not specified or cached data does not exist.{p_end}
{space 2}{synopt:{opt user_agent(string)}}Email address to provide in the header of the HTTP request to the BLS website; passed to {help copy_curl}.{p_end} 
{synoptline}



{title:Example(s)}

    Merge the CPI-U into the dataset in memory.

        {bf:. get_cpiu, merge}

    Load CPI-U-RS and inflation-adjustment factors to 2022 constant dollars into memory, replacing the dataset currently in memory.

        {bf:. get_cpiu, rs base_year(2022) clear}

    Load cached CPI-U data series into matrix {bf:inflation}.

        {bf:. get_cpiu, matrix(inflation) use_cache}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}




