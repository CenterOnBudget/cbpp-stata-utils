*! version 0.2.9

capture program drop  _cbppstatautils_cache

program define _cbppstatautils_cache, sclass

  if "`c(os)'" == "Windows" local cache_dir "~/AppData/Local/cbppstatautils"
  if "`c(os)'" == "MacOSX" local cache_dir "~/Library/Application Support/cbppstatautils"
  if "`c(os)'" == "Unix" local cache_dir "~/.local/share/cbppstatautils"
  capture mkdir "`cache_dir'" 
  
  sreturn local cache_dir = "`cache_dir'"

end
