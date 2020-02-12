* make help files for cbppstatautils

local pkg_dir "C:\Users\\`c(username)'\Documents\GitHub\cbppstatautils"
di "`pkg_dir'"
cd "`pkg_dir'"

local files_list get_acs_pums.ado make_acs_pums_lbls.ado label_state.ado 

foreach f of local files_list {
	markdoc "`f'", export(sthlp) replace style("simple")
}