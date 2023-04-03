#' Validate an xlsx template file to use in [xlsx_cutter()]
#'
#' @inheritParams xlsx_cutter
#' @param minimal Logical (default to `FALSE`) saying whether the template
#'   should contain only variables delimited by markers and nothing else, or
#'   if extra text can be included (and ignored)
#' @param error Logical (defaults to `TRUE`) saying whether failed validations
#'   should result in an error (`TRUE`) or a warning (`FALSE`)
#'
#' @returns `TRUE` if the template is valid, `FALSE` otherwise
#'
#' @export
#'
#' @examples
#' # Valid template
#' validate_xltemplate(
#'   system.file("example", "timesheet_template.xlsx", package = "xlcutter")
#' )
#'
#' # Invalid templates
#' validate_xltemplate(
#'   system.file("example", "template_duped_vars.xlsx", package = "xlcutter")
#' )
#'
#' validate_xltemplate(
#'   system.file("example", "template_fluff.xlsx", package = "xlcutter"),
#'   minimal = TRUE
#' )
validate_xltemplate <- function(
  template_file,
  template_sheet = 1,
  marker_open = "{{", marker_close = "}}",
  minimal = FALSE,
  error = FALSE
) {

  cnd_msg <- NULL

  template <- tidyxl::xlsx_cells(template_file, template_sheet)

  template_minimal <- template[
    detect_with_markers(template$character, marker_open, marker_close),
  ]

  has_fluff <- nrow(template_minimal) < nrow(template)

  if (has_fluff && minimal) {
    cnd_msg <- c(
      cnd_msg,
      sprintf(
        ngettext(
          nrow(template) - nrow(template_minimal),
          "%s and includes %d field not defining any variable",
          "%s and includes %d fields not defining any variable"
        ),
        "The provided template is not minimal",
        nrow(template) - nrow(template_minimal)
      )
    )
  }

  noms <- trimws(
    substr(
      template_minimal$character,
      nchar(marker_open) + 1,
      nchar(template_minimal$character) - nchar(marker_close)
    )
  )

  has_dups <- anyDuplicated(noms) > 0

  if (has_dups > 0) {
    noms_duplicated <- unique(noms[duplicated(noms)])
    cnd_msg <- c(
      cnd_msg,
      sprintf(
        ngettext(
          length(noms_duplicated),
          "%s variable is duplicated in template: %s",
          "%s variables are duplicated in template: %s"
        ),
        length(noms_duplicated),
        toString(noms_duplicated)
      )
    )
  }

  if (error) {
    stop(
      "This template is not valid:\n",
      paste(sprintf("- %s", cnd_msg), collapse = "\n"),
      call. = FALSE
    )
  }

  lapply(cnd_msg, warning, call. = FALSE)

  # This is an unnecessary copy for now but may be useful as we add more checks
  valid <- !has_dups && (!has_fluff || !minimal)

  return(valid)

}
