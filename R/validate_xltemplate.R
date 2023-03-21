#' Validate an xlsx template file to use in [xlsx_cutter()]
#'
#' @inheritParams xlsx_cutter
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
#' # Invalid template
#' validate_xltemplate(
#'   system.file("example", "template_duped_vars.xlsx", package = "xlcutter")
#' )
#'
validate_xltemplate <- function(
    template_file,
    template_sheet = 1,
    marker_open = "{{", marker_close = "}}",
    error = FALSE
) {

  template <- tidyxl::xlsx_cells(template_file, template_sheet)

  template <- template[
    detect_with_markers(template$character, marker_open, marker_close),
  ]

  noms <- remove_markers(template$character, marker_open, marker_close)

  if (error) {
    raise <- stop
  } else {
    raise <- warning
  }

  has_dups <- anyDuplicated(noms) > 0

  if (has_dups > 0) {
    noms_duplicated <- unique(noms[duplicated(noms)])
    raise(
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

  # This is an unnecessary copy for now but may be useful as we add more checks
  valid <- !has_dups

  return(valid)

}
