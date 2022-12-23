data_folder <- system.file("example", "timesheet", package = "xlcutter")

data_files <- list.files(
  data_folder,
  pattern = "\\.xlsx$",
  full.names = TRUE
)

template_file <- system.file(
  "example", "timesheet_template.xlsx",
  package = "xlcutter"
)

test_that("xlsx_cutter() works", {

  expect_snapshot_value(
    xlsx_cutter(data_files, template_file),
    style = "json2"
  )

})
