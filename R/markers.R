escape_markers <- function(marker) {

  gsub("(\\[|\\]|[{}*?+()\\.|\\(\\)^$\\])", "\\\\\\1", marker)

}

remove_markers <- function(x, marker_open, marker_close) {

  esc_markers <- escape_markers(c(marker_open, marker_close))

  trimws(gsub(
    paste0("^", esc_markers[1], "(.*)", esc_markers[2], "$"),
    "\\1",
    x
  ))

}

detect_with_markers <- function(x, marker_open, marker_close) {

  esc_markers <- escape_markers(c(marker_open, marker_close))

  grepl(
    paste0("^", esc_markers[1], ".*", esc_markers[2], "$"),
    x
  )

}
