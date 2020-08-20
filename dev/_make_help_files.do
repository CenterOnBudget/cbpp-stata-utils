* make help files for cbppstatautils

local pkg_dir "${ghpath}\cbpp-stata-utils\src"
cd "`pkg_dir'"

capture which markdoc
if _rc != 0 {
	net install github, from("https://haghish.github.io/github/") replace
	github install haghish/markdoc, stable
}

local files_list 	categorize.ado					///
					cbppstatautils.ado				///
					etotal.ado						///
					generate_acs_adj_vars.ado		///
					generate_acs_major_group.ado	///
					generate_aian_var.ado			///
					generate_race_var.ado			///
					get_acs_pums.ado 				///
					get_cpiu.ado					///
					inspect_2.ado					///
					label_state.ado 				///
					labeller.ado					///
					label_acs_pums.ado 				///
					load_data.ado					///
					make_cbpp_profile.ado			///
					svyset_acs.ado					


foreach f of local files_list {
	markdoc "`f'", export(sthlp) replace style("simple")
}
