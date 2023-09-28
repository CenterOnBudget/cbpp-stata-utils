*! version 0.2.8


/***
Title
====== 

__make_cbpp_profile__ {hline 2} Set up CBPP's standard profile.do.


Description
-----------

__make_cbpp_profile__ creates CBPP's standard
[profile.do](https://www.stata.com/support/faqs/programming/profile-do-file/)
in the user's home directory. This command is only useful for CBPP staff. 

CBPP's standard profile.do defines global macros that serve as shortcuts to 
synched SharePoint and OneDrive folders and cloned GitHub repositories. 

Users may also add the following to the standard profile.do:

{p 8 8 2}{c 149}  Census Bureau API key to for use by the [getcensus](https://centeronbudget.github.io/getcensus/) package, stored as a global macro named 'censuskey'{p_end}
  
{p 8 8 2}{c 149}  Path to the user's Rscript excutable for use by the [rscript](https://github.com/reifjulian/rscript) package, stored as a global macro named 'RSCRIPT_PATH'{p_end}


Syntax
------ 

> __make_cbpp_profile__, [_options_]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
	{synopt:{opt censuskey(string)}}Census Bureau API key.{p_end}
  {synopt:{opt rscript(string)}}Path to the user's Rscript executable.{p_end}
	{synopt:{opt replace}}replace existing profile.do.{p_end}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


***/


* capture program drop make_cbpp_profile

program define make_cbpp_profile

	syntax, [censuskey(string)] [rscript(string)] [replace]
  
  preserve
  
  quietly {
    findfile "_cbpp_profile.ado"
    * findfile "_cbpp_profile.ado", path(`c(pwd)') // for debugging
    infix str text 1-100 using "`r(fn)'", clear
    replace text =  ///
      cond("`censuskey'" != "", `"global censuskey "`censuskey'""', "") ///
      in 12
    replace text =  ///
      cond("`rscript'" != "", `"global RSCRIPT_PATH "`rscript'""', "")  ///
      in 15
    compress
  }
  
  local root = cond("`c(os)'" == "Windows", "C:", "")
	local profile_do_path "`root'/Users/`c(username)'/profile.do"
  * local profile_do_path "`c(pwd)'/profile.do" // for debugging
  
  outfile using `profile_do_path', noquote `replace'
	display as result `"created {bf:{browse "`profile_do_path'"}}"'
  
  restore

end

