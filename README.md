<img align="right" width="150" src="https://www.cbpp.org/sites/all/themes/custom/cbpp/logo.png">

# CBPP Stata Utility Programs

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

## About

`cbppstatautils` contains Stata utility programs created by and for researchers at the [Center on Budget and Policy Priorities](https://www.cbpp.org). Most of the programs are for working with American Community Survey or Current Population Survey microdata.

## Disclaimer

This repository is under active development and contents are subject to change. Programs are being developed with Stata version 16. None have yet been tested for compatibility with other Stata versions.

## Installation

To install the `cbppstatautils` package, run:
```
net install cbppstatautils, from(https://raw.githubusercontent.com/CenterOnBudget/cbpp-stata-utils/master/src) replace
```
To update your installation to the latest version, run:
```
ado update cbppstatautils, update
```

## License
View the [license](https://github.com/CenterOnBudget/cbpp-stata-utils/blob/master/LICENSE).


## Contents

### Programs

| Program | Description |
|---------|-------------|
|`get_acs_pums` | Retrieve ACS PUMS files from the Census Bureau FTP. |
|`make_acs_pums_lbls` | Generate .do files to label ACS PUMS data. | 
|`generate_acs_adj_vars` | Generate adjusted versions of ACS PUMS income and housing variables using 'adjinc' and 'adjhsg'. |
|`generate_acs_major_group` | Generate categorical variable for major industry and/or occupation groups in ACS PUMS data. |
| `generate_race_var` | Generate categorical variable for race/ethnicity in CPS or ACS microdata. |
| `label_state` | Label a numeric state FIPS code variable with state names or postal abbreviations. |
|`get_cpiu` | Retrieve annual CPI-U or CPI-U-RS series as a dataset, variable, or matrix. |


### Data

| Dataset | Description |
|---------|-------------|
|`state_fips` | State names, FIPS codes, and postal abbreviations. |


