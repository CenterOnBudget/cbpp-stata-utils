
## v 0.2.2

- `load_data` messages and help file are clearer about the year for CPS ASEC files [#17](https://github.com/CenterOnBudget/cbpp-stata-utils/issues/17)
- Bug fixes: [#18](https://github.com/CenterOnBudget/cbpp-stata-utils/issues/18), [#19](https://github.com/CenterOnBudget/cbpp-stata-utils/issues/19), 


## v 0.2.1

- Bug fixes: [#16](https://github.com/CenterOnBudget/cbpp-stata-utils/issues/16)

## v 0.2.0

- `load_data` supports loading the March 2021 CPS.
- Bug fixes: [#9](https://github.com/CenterOnBudget/cbpp-stata-utils/issues/9), [#13](https://github.com/CenterOnBudget/cbpp-stata-utils/issues/13)


## v 0.1.9

This release includes breaking changes.

__Enhancements__

- `get_acs_pums` now uses `label_acs_pums` to label data by default. It also displays an error message to the user if unzipping the retrieved files fails.
- `load_data` now supports `if` and `datasets(pulse)`. When `dataset(acs)`, _serialno_ is de-stringed only when loading data for a range of years that spans the variable type change. Previously, _serialno_ was de-stringed if any of the years in `years()` were 2018 and later. De-stringing is now faster; it is implemented with `real()` instead of `destring`.
- `get_cpiu` labels variables (if `merge` or `replace` is specified).
- `svyset_acs_pums` now supports multi-year average weights for use in a dataset of multiple 1-year ACS samples appended together.

__Breaking changes__

- `generate_acs_major_group` has been __removed__ from the package. 


## v 0.1.8

Support for 2020 March CPS in `load_data`.

## v 0.1.7

Bug fixes to `get_acs_pums` and `make_cbpp_profile`.


## v 0.1.6

Enhancement to `load_data`: Support SNAP QC datasets.


## v 0.1.5

Bug fixes to `load_data` and `generate_aian_var`.


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

