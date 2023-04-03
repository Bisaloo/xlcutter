escape_markers <- function(marker) {

  gsub("(\\[|\\]|[{}*?+()\\.|()^$])", "\\\\\\1", marker)

}

detect_with_markers <- function(x, marker_open, marker_close) {

  !is.na(x) & startsWith(x, marker_open) & endsWith(x, marker_close)

}
