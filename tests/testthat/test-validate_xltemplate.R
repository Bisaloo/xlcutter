test_that("valid and invalid templates are indentified", {

  expect_true(
    validate_xltemplate(
      system.file("example", "timesheet_template.xlsx", package = "xlcutter")
    )
  )

  expect_warning(
    expect_false(
      validate_xltemplate(
        system.file("example", "template_duped_var.xlsx", package = "xlcutter")
      )
    )
  )

  expect_true(
    validate_xltemplate(
      system.file("example", "template_fluff.xlsx", package = "xlcutter")
    )
  )


  expect_warning(
    expect_false(
      validate_xltemplate(
        system.file("example", "template_fluff.xlsx", package = "xlcutter"),
        minimal = TRUE
      )
    )
  )

})

test_that("error argument works", {

  expect_no_error(
    expect_warning(
      validate_xltemplate(
        system.file("example", "template_duped_var.xlsx", package = "xlcutter")
      )
    )
  )

  expect_error(
    expect_warning(
      validate_xltemplate(
        system.file("example", "template_duped_var.xlsx", package = "xlcutter"),
        error = TRUE
      )
    )
  )

})

test_that("plural works in message", {

  expect_warning(
    validate_xltemplate(
      system.file("example", "template_duped_var.xlsx", package = "xlcutter")
    ),
    "is duplicated"
  )

  expect_warning(
    validate_xltemplate(
      system.file("example", "template_duped_vars.xlsx", package = "xlcutter")
    ),
    "are duplicated"
  )

})
