{smcl}

{title:Title}

{p 4 4 2}
{bf:copy_curl} {hline 2} Copy file from URL with curl.



{title:Description}

{p 4 4 2}
{bf:copy_curl} copies file from a URL with  {browse "https://curl.se/":curl}. 

{p 4 4 2}
Users may optionally specify the
{browse "https://everything.curl.dev/http/modify/user-agent.html":user-agent}
to include in the HTTP header. 

{p 4 4 2}
Some websites block automated retrieval programs that do not provide a 
user-agent. For example, the Bureau of Labor Statistics website may block 
programs without an email address in the user-agent, per its 
{browse "https://www.bls.gov/bls/pss.htm":usage policy}. 


{title:Syntax}

{p 4 4 2}
{bf:copy_curl} {it:{help filename}1} {it:{help filename}2} [, {it:options}]

{p 4 4 2}
{it:filename1} may be a URL. {it:filename2} may be a file.

{p 4 4 2}
Note: Double quotes may be used to enclose the filenames, and the quotes must be
used if the filename contains embedded blanks.


{synoptset 20}{...}
{synopthdr}
{synoptline}
{space 2}{synopt:{opt user_agent(string)}}User agent to provide in the HTTP header.{p_end}
{space 2}{synopt:{opt replace}}May overwrite {it:filename2}.{p_end}
{synoptline}



{title:Example(s)}

    Download a file from the BLS website.

        {bf:. copy_curl "https://www.bls.gov/cpi/research-series/r-cpi-u-rs-allitems.xlsx"  ///}
        {bf:    "r-cpi-u-rs.xlsx", user_agent(username@cbpp.org)}



{title:Website}

{p 4 4 2}
{browse "https://centeronbudget.github.io/cbpp-stata-utils/":centeronbudget.github.io/cbpp-stata-utils}



