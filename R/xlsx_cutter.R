#' Create a data.frame from a folder of non-rectangular excel files
#'
#' Create a data.frame from a folder of non-rectangular excel files based on a
#' defined custom template
#'
#' @param data_files vector of paths to the xlsx files to parse
#' @param template_file path to the template file to use as a model to parse the
#'   xlsx files in `data_folder`
#' @param data_sheet sheet id to extract from the xlsx files
#' @param template_sheet sheet id of the template file to use as a model to
#'   parse the xlsx files in `data_folder`
#' @param marker_open,marker_close character marker to mark the variables to
#'   extract in the `template_file`
#'
#' @returns A rectangular `data.frame` with columns as defined in the template.
#' Column types are determined automatically by `type.convert()`
#'
#' @importFrom stats setNames
#' @importFrom utils type.convert
#'
#' @export
#'
#' @examples
#'
#' data_files <- list.files(
#'   system.file("example", "timesheet", package = "xlcutter"),
#'   pattern = "\\.xlsx$",
#'   full.names = TRUE
#' )
#'
#' template_file <- system.file(
#'   "example", "timesheet_template.xlsx",
#'   package = "xlcutter"
#' )
#'
#' xlsx_cutter(
#'   data_files,
#'   template_file
#' )
#'
xlsx_cutter <- function(
  data_files, template_file,
  data_sheet = 1, template_sheet = 1,
  marker_open = "{{", marker_close = "}}"
) {

  template <- tidyxl::xlsx_cells(
    template_file,
    template_sheet,
    include_blank_cells = FALSE
  )

  template <- template[
    detect_with_markers(template$character, marker_open, marker_close),
  ]

  coords <- template[, c("row", "col")]
  # We used to have a dedicated remove_markers() function which specifically
  # removed the markers with a regex.
  # BUT, since we already extracted strings with the markers, we can more simply
  # and more efficiently remove the markers based on nchar
  noms <- trimws(
    substr(
      template$character,
      nchar(marker_open) + 1,
      nchar(template$character) - nchar(marker_close)
    )
  )

  res <- lapply(
    data_files,
    single_xlsx_cutter,
    template_file, data_sheet, coords, noms
  )

  res <- as.data.frame(do.call(rbind, res))

  type.convert(res, as.is = TRUE)

}

single_xlsx_cutter <- function(
  data_file, template_file, data_sheet,
  coords, noms
) {

  d <- tidyxl::xlsx_cells(
    data_file,
    sheets = data_sheet
  )
  # FIXME: this is not ideal because we'd rather not read blank cells at all
  # by setting `include_blank_cells = FALSE` in `tidyxl::xlsx_cells()`. But
  # this is currently failing in the case where we have blank cells with
  # comments: https://github.com/nacnudus/tidyxl/issues/91
  d <- d[!d$is_blank, ]

  d <- merge(coords, d, all = FALSE, all.x = TRUE)
  d <- d[order(d$row, d$col), ]

  # Present in template but not in file. Introduced by merge(all.x = TRUE)
  d$data_type[is.na(d$data_type)] <- "missing"

  d$res[d$data_type %in% c("error", "missing")] <- NA_character_
  d$res[d$data_type == "logical"]   <- d$logical[d$data_type == "logical"]
  d$res[d$data_type == "numeric"]   <- d$numeric[d$data_type == "numeric"]
  d$res[d$data_type == "date"]      <- format(d$date[d$data_type == "date"])
  d$res[d$data_type == "character"] <- d$character[d$data_type == "character"]

  setNames(
    d$res,
    noms
  )

}
