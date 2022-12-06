test_that("escape_markers() works", {

  # No action
  expect_identical(escape_markers(letters), letters)

  # Escape special regex characters
  expect_identical(escape_markers("\\"), "\\\\")
  expect_identical(escape_markers("^"), "\\^")
  expect_identical(escape_markers("$"), "\\$")
  expect_identical(escape_markers("."), "\\.")
  expect_identical(escape_markers("|"), "\\|")
  expect_identical(escape_markers("?"), "\\?")
  expect_identical(escape_markers("*"), "\\*")
  expect_identical(escape_markers("+"), "\\+")
  expect_identical(escape_markers("("), "\\(")
  expect_identical(escape_markers(")"), "\\)")
  expect_identical(escape_markers("["), "\\[")
  expect_identical(escape_markers("]"), "\\]")
  expect_identical(escape_markers("{"), "\\{")
  expect_identical(escape_markers("}"), "\\}")

  # Multiple markers are escaped correctly
  expect_identical(escape_markers("{{"), "\\{\\{")

})

test_that("detect_with_markers() works", {

  # Detect accurately with markers which are not regex special symbols
  expect_true(detect_with_markers("_mycol_", "_", "_"))
  expect_false(detect_with_markers("mycol", "_", "_"))

  # Detect accurately with markers which are regex special symbols
  expect_true(detect_with_markers("*mycol*", "*", "*"))
  expect_false(detect_with_markers("mycol", "*", "*"))

  # Detect accurately with repeated markers
  expect_true(detect_with_markers("__mycol__", "__", "__"))
  expect_false(detect_with_markers("mycol", "__", "__"))
  expect_false(detect_with_markers("_mycol_", "__", "__"))

  # Detect accurately with complex markers
  expect_true(detect_with_markers("*_mycol_*", "*_", "_*"))
  expect_false(detect_with_markers("mycol", "*_", "_*"))
  expect_false(detect_with_markers("_mycol_", "*_", "_*"))

  # Still works on longer input
  expect_identical(
    detect_with_markers(c("*_col1_*", "_col2_", "*_col3_"), "*_", "_*"),
    c(TRUE, FALSE, FALSE)
  )

})

test_that("remove_markers() works", {

  # Remove markers which are not regex special symbols
  expect_identical(
    remove_markers("_mycol_", "_", "_"),
    "mycol"
  )

  # Remove markers which are regex special symbols
  expect_identical(
    remove_markers("*mycol*", "*", "*"),
    "mycol"
  )

  # Remove repeated markers
  expect_identical(
    remove_markers("__mycol__", "__", "__"),
    "mycol"
  )

  # Do not remove too many markers
  expect_identical(
    remove_markers("__mycol__", "_", "_"),
    "_mycol_"
  )

  # Remove complex markers
  expect_identical(
    remove_markers("*_mycol_*", "*_", "_*"),
    "mycol"
  )

  # Still works on longer input
  expect_identical(
    remove_markers(c("*_col1_*", "*__col2__*", "*col3*"), "*_", "_*"),
    c("col1", "_col2_", "*col3*")
  )

})
