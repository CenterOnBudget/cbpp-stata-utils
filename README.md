<img align="right" width="150" src="https://www.cbpp.org/sites/all/themes/custom/cbpp/logo.png">

# CBPP Stata Utility Programs

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

## About

`cbppstatautils` contains Stata utility programs created by and for researchers at the [Center on Budget and Policy Priorities](https://www.cbpp.org). Most of the programs are for working with American Community Survey or Current Population Survey microdata.

## Disclaimer

This repository is under active development and contents are subject to change. Programs are being developed with Stata version 16. None have yet been tested for compatibility with other Stata versions.

Breaking changes will be noted in the [changelog](https://github.com/CenterOnBudget/cbpp-stata-utils/blob/master/NEWS.md).

## Installation

To install the `cbppstatautils` package, run:
```
net install cbppstatautils, from("https://centeronbudget.github.io/cbpp-stata-utils/src")

```
To update your installation to the latest version, run:
```
cbppstatautils, update
```

## License
View the [license](https://github.com/CenterOnBudget/cbpp-stata-utils/blob/master/LICENSE).


## Contents

### Programs

| Program | Description |
|---------|-------------|
| `categorize` | Generate a categorical variable. |
| `etotal` | Flexible counts and totals. |
| `generate_acs_adj_vars` | Generate adjusted versions of ACS PUMS income and housing variables using 'adjinc' and 'adjhsg'. |
| `generate_aian_var` | Generate categorical AI/AN variable for CPS or ACS microdata. |
| `generate_race_var` | Generate categorical variable for race/ethnicity in CPS or ACS microdata. |
| `get_acs_pums` | Retrieve ACS PUMS files from the Census Bureau FTP. |
| `get_cpiu` | Retrieve annual CPI-U or CPI-U-RS series as a dataset, variable, or matrix. |
| `inspect_2` | Summary statistics for positive, zero, negative, and missing values. |
| `label_acs_pums` | Label American Community Survey PUMS data. |
| `label_state` | Label a numeric state FIPS code variable with state names or postal abbreviations. |
| `labeller` | Define and apply variable and value labels in one step. |
| `load_data` | Load microdata from the CBPP datasets library into memory. |
| `make_cbpp_profile` | Set up CBPP's standard profile.do. |
| `svyset_acs` | Declare the survey design for ACS PUMS. |

### Data

| Dataset | Description |
|---------|-------------|
| `state_fips` | State names, FIPS codes, and postal abbreviations. |


