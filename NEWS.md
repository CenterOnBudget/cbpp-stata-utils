
## v 0.1.4

This release includes breaking changes (*).

- **Help files**: Formatting fixes and minor edits.
- **Error messages**: More consistent with Stata's base error messages and less verbose.
- ***Syntax change to `svyset_acs`**: User must specify _not_ to use replicate weights instead of the reverse (`nosdrweights` option replaces `rep_weights`).
- ***Syntax change to `get_acs_pums`**: Option `keep_all` replaces `keep_csv`; is equivalent to `keep_zip` plus `keep_csv`. 
- **Enhancement to `get_acs_pums`**: Results messages now include hyperlinks to the file paths so users can click to open the directory in File Explorer/Finder.
- **Bug fix to `load_data`**: Does not attempt to destring serialno for 2018 file if user specifies `vars()` that do not include serialno. 
- **Change to `cbppstatautils, update`**: Runs `ado update` instead of `net install` to avoid potential double-installation.
- ***Enhancement and bug fix to `inspect_2`**: For users specifying multiple variables, allows specifying the names of results matrix for each in `matrix()`, which replaces the `save` option. If a category (negative, zero, positive, missing) does not appear in the data, it will be shown as a row containing 0 in frequency and percent, and missing in mean, min, and max.
- **Enhancement to `get_cpiu`**: For users specifying the `merge` option, allow user to specify name of variable in memory that contains the year in `yearvarname()` option. 
- **Enhancement to `etotal`**: Allow user to specify confidence level in `level()` option.
- ***Replace `make_acs_pums_lbls` with `label_acs_pums`**: New command generates label `.do` file, places it in the package cache files, and runs it on data in memory. Previous command required user to choose where to place the label `.do` file and then proactively run it.
- **New command `make_cbpp_profile`**: Sets up standard data team `profile.do`. 

