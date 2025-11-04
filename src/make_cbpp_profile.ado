*! version 0.2.12


/***
Title
====== 

__make_cbpp_profile__ {hline 2} Set up CBPP's standard profile.do.


Description
-----------

make_cbpp_profile creates CBPP's standard [profile.do](https://www.stata.com/support/faqs/programming/profile-do-file/) 
in the user's home directory.

This command is only useful for CBPP staff.

CBPP's standard profile.do defines global macros that serve as shortcuts to 
synced cloud folders and cloned GitHub repositories:

{p 8 10 2}{c 149} __odpath__ – Path to the user's OneDrive, "C:/Users/{username}/OneDrive - Center on Budget and Policy Priorities".

{p 8 10 2}{c 149} __sppath__ – Path to the directory for synced SharePoint folders, "C:/Users/{username}/Center on Budget and Policy Priorities".

{p 8 10 2}{c 149} __spdatapath__ – Start of path to a synced datasets libraries, "C:/Users/{username}/Center on Budget and Policy Priorities/Datasets - ".

{p 8 10 2}{c 149} __ghpath__ – Path to cloned GitHub repositories, "C:/Users/{username}/Documents/GitHub".

It also contains global macros for use by other cbppstatautils commands:

{p 8 10 2}{c 149} __BLS_USER_AGENT__ User's CBPP email address, "{username}@cbpp.org", to enable {help get_cpiu} to download from the BLS website.

Users may optionally add the following to the standard profile.do:

{p 8 10 2}{c 149} Census Bureau API key to for use by the [getcensus](https://centeronbudget.github.io/getcensus/) package, to be stored as global macro __censuskey__.

{p 8 10 2}{c 149} Path to the user's Rscript excutable for use by the [rscript](https://github.com/reifjulian/rscript) package, to be stored as global macro __RSCRIPT_PATH__.

The standard profile.do includes __set more off, permanently__.


Syntax
------ 

__make_cbpp_profile__ [, _options_]


{synoptset 16}{...}
{synopthdr:options}
{synoptline}
  {synopt:{opt censuskey(string)}}Census Bureau API key.{p_end}
  {synopt:{opt rscript(string)}}Path to the Rscript executable; typically "C:/Users/{username}/AppData/Local/Programs/R/R-{version}/bin/Rscript.exe".{p_end}
  {synopt:{opt replace}}Replace existing profile.do.{p_end}
{synoptline}


Website
-------

[centeronbudget.github.io/cbpp-stata-utils](https://centeronbudget.github.io/cbpp-stata-utils/)

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
  
  local userprofile : env USERPROFILE
  local profile_do_path "`userprofile'/profile.do"
  * local profile_do_path "`c(pwd)'/profile.do" // for debugging
  
  outfile using "`profile_do_path'", noquote `replace'
  display as result `"created {bf:{browse "`profile_do_path'"}}"'
  
  restore

end

