* make help files for cbppstatautils

local pkg_dir "${ghpath}/cbpp-stata-utils/src"
cd "`pkg_dir'"

capture which markdoc
if _rc != 0 {
	net install github, from("https://haghish.github.io/github/") replace
	github install haghish/markdoc, stable
}

local files_list : dir . files "*.ado"
foreach f of local files_list {
  if "`f'" != "_cbpp_profile.ado" {
	  markdoc "`f'", export(sthlp) replace style("simple")
  }
}
