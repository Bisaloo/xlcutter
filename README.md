
<!-- README.md is generated from README.Rmd. Please edit that file -->

# xlcutter

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/license/mit/)
[![R-CMD-check](https://github.com/Bisaloo/xlcutter/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Bisaloo/xlcutter/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/Bisaloo/xlcutter/branch/main/graph/badge.svg)](https://app.codecov.io/gh/Bisaloo/xlcutter?branch=main)
[![lifecycle-concept](https://raw.githubusercontent.com/reconverse/reconverse.github.io/master/images/badge-concept.svg)](https://www.reconverse.org/lifecycle.html#concept)
<!-- badges: end -->

This package allows you to parse entire folders of non-rectangular
‘xlsx’ files into a single rectangular and tidy ‘data.frame’ based on a
custom template file defining the column names of the output.

## Installation

You can install the latest stable version of this package from CRAN:

``` r
install.packages("xlcutter")
```

or the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("Bisaloo/xlcutter")
```

## Example

Non-rectangular excel files are common in many domains. For a simple
demonstration here, we use the example of the [“Blue
timesheet”](https://templates.office.com/en-us/blue-timesheet-tm77799521)
from <https://templates.office.com/>, where employees can log their
working hours.

A typical use case of xlcutter in this example would be for a manager
who want to get a single rectangular dataset with the timesheets from
different employees.

![Screenshot of timesheets from two fictitious
employees](man/figures/screenshot_timesheets.png)

Your first step to extract the data is to define the various columns you
want in the output in a *template* file. You can mark the data cells to
extract with any custom marker, with the default being
`{{ column_name }}`.

![Screenshot of a template for the timesheet
example](man/figures/screenshot_template.png)

``` r
library(xlcutter)

data_files <- list.files(
  system.file("example", "timesheet", package = "xlcutter"),
  pattern = "\\.xlsx$",
  full.names = TRUE
)

template_file <- system.file(
  "example", "timesheet_template.xlsx",
  package = "xlcutter"
)

xlsx_cutter(
  data_files,
  template_file
)
#>   employee_firstname contract_hours employee_lastname realised_hours
#> 1               Leon             35              Bedu          29.00
#> 2               Paul             35            Dupont          35.00
#> 3           Marianne             35            Lebrun          36.25
#>   manager_firstname manager_lastname period_start period_end
#> 1              <NA>           Dubois   2022-01-03 2022-01-07
#> 2             Lydia           Dubois   2022-01-03 2022-01-07
#> 3             Lydia           Dubois   2022-01-03 2022-01-07
```

## Other example of use cases

Other typical use cases for this package could be:

- an hospital that wants to collate non-rectangular information sheets
  from different patients into a single rectangular dataset
