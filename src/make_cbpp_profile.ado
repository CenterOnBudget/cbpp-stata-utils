
/***
Title
====== 

__make_cbpp_profile__ {hline 2} Set up CBPP's standard profile.do.


Description
-----------

__make_cbpp_profile__ retreives CBPP's standard [profile.do](https://www.stata.com/support/faqs/programming/profile-do-file/) and places it in the user's home directory. This command is only useful for CBPP staff. 

CBPP's standard profile.do defines global macros that serve as shortcuts to synched SharePoint and OneDrive folders and cloned GitHub repositories. It also defines a global macro named 'censuskey' that contains the user's Census Bureau API key. Users may specify their API key to __censuskey()__ to insert it into the profile.do. If this option is not specified, the _censuskey_ global will contain placeholder text.


Syntax
------ 

> __make_cbpp_profile__, [_options_]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
	{synopt:{opt censuskey(string)}}Census Bureau API key.{p_end}
	{synopt:{opt replace}}replace existing profile.do with standard profile.do.{p_end}


Website
-------

[github.com/CenterOnBudget/cbppstatautils](https://github.com/CenterOnBudget/cbppstatautils)


- - -
{it:This help file was dynamically produced by {browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package}.}
***/


* capture program drop make_cbpp_profile

program define make_cbpp_profile

	syntax, [censuskey(string)] [replace]
	
	
	* set up cache and file paths ---------------------------------------------
	
	local cache_dir = cond("`c(os)'" == "Windows", 							///
						   "~/AppData/Local/cbppstatautils",				///
						   "~/Library/Application Support/cbppstatautils")
	capture mkdir "`cache_dir'"	
	
	local remote_path "https://raw.githubusercontent.com/CenterOnBudget/cbpp-stata-utils/master/ancillary"
	local standard_do_path "`remote_path'/cbpp_profile.do"

	local root = cond("`c(os)'" == "Windows", "C:", "")
	local profile_do_path "`root'/Users/`c(username)'/profile.do" 

	/* debug
	local standard_do_path "${ghpath}/cbpp-stata-utils/ancillary/cbpp_profile.do"
	local profile_do_path "`c(pwd)'/profile.do"
	**/
	
	* customize with provided API key -----------------------------------------

	if "`censuskey'" != "" {
		quietly {
			copy "`standard_do_path'" "`cache_dir'/cbpp_profile.do", replace
			tempfile profile_do_path_with_key
			preserve
			infix str500 line 1-500  using "`cache_dir'/cbpp_profile.do", clear
			replace line = `"global censuskey "`censuskey'""' in 14
			outfile using `profile_do_path_with_key', noquote replace
			restore
			local standard_do_path "`profile_do_path_with_key'"
		}
	}
	
	
	* copy into user home directory -------------------------------------------
	
	quietly copy "`standard_do_path'" "`profile_do_path'", `replace'
	display as result `"created {bf:{browse "`profile_do_path'"}}"'

end


