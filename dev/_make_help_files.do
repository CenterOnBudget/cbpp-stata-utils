* make help files for cbppstatautils

local pkg_dir "${ghpath}\cbpp-stata-utils\src"
cd "`pkg_dir'"

capture which markdoc
if _rc != 0 {
	net install github, from("https://haghish.github.io/github/") replace
	github install haghish/markdoc, stable
}

local files_list 	get_acs_pums.ado 				///
					make_acs_pums_lbls.ado 			///
					label_state.ado 				///
					get_cpiu.ado					///
					generate_race_var.ado			///
					generate_acs_adj_vars.ado		///
					generate_acs_major_group.ado	///
					svyset_acs.ado					///
					load_data.ado					///
					inspect_2.ado					///
					labeller.ado					///
					etotal.ado						///
					generate_aian_var.ado			///
					cbppstatautils.ado

foreach f of local files_list {
	markdoc "`f'", export(sthlp) replace style("simple")
}
