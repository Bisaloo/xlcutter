data_folder <- system.file("example", "timesheet", package = "xlcutter")
template_file <- system.file(
  "example", "timesheet_template.xlsx",
  package = "xlcutter"
)

test_that("xlsx_cutter() works", {

  expect_snapshot_value(
    xlsx_cutter(data_folder, template_file),
    style = "json2"
  )

})
