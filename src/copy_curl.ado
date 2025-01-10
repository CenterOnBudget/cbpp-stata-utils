*! version 0.2.9

/***
Title
====== 

__copy_curl__ {hline 2} Copy file from URL with curl.


Description
-----------

__copy_curl__ copies file from a URL with [curl](https://curl.se/). 

Users may optionally specify the
[user-agent](https://everything.curl.dev/http/modify/user-agent.html)
to include in the HTTP header. 

Some websites block automated retrieval programs that do not provide a 
user-agent. For example, the Bureau of Labor Statistics website may block 
programs without an email address in the user-agent, per its 
[usage policy](https://www.bls.gov/bls/pss.htm). 

Syntax
------ 

__copy_curl__ _{help filename}1_ _{help filename}2_ [, _options_]

_filename1_ may be a URL. _filename2_ may be a file.

Note: Double quotes may be used to enclose the filenames, and the quotes must be
used if the filename contains embedded blanks.


{synoptset 20}{...}
{synopthdr}
{synoptline}
  {synopt:{opt user_agent(string)}}User agent to provide in the HTTP header.{p_end}
  {synopt:{opt replace}}May overwrite {it:filename2}.{p_end}
{synoptline}


Example(s)
----------

    Download a file from the BLS website.
    
        {bf:. copy_curl "https://www.bls.gov/cpi/research-series/r-cpi-u-rs-allitems.xlsx"  ///}
        {bf:    "r-cpi-u-rs.xlsx", user_agent(username@cbpp.org)}


Website
-------

[centeronbudget.github.io/cbpp-stata-utils](https://centeronbudget.github.io/cbpp-stata-utils/)

***/

* capture program drop copy_curl

program define copy_curl

   syntax anything, [user_agent(string)] [replace]
   
     tokenize `"`anything'"'
     
     // rough check that anything is two things
     if "`2'" == "" | "`3'" != "" {
       display as error "invalid file specification"
       exit 198
     }
     
     local url = "`1'"
     local file = "`2'"
     
     capture confirm file "`file'"
     if _rc == 0 & "`replace'" == "" {
       display as error "file {bf:`file'} already exists"
       exit 602
     }
     
     if "`user_agent'" != "" {
       local user_agent = `"-H "User-Agent: `user_agent'""'
     }
     
    ! curl -o "`file'" "`url'" `user_agent'

end