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

  # Still works on longer input with NAs
  expect_identical(
    detect_with_markers(c("*_col1_*", "_col2_", "*_col3_", NA), "*_", "_*"),
    c(TRUE, FALSE, FALSE, FALSE)
  )

})
