#' Load naturalistic data stored in \code{.csv} files
#'
#' This function loads one or more \code{.csv} files containing the NDS-BR data.
#'
#' \code{nds_load_data} considers that data inside the \code{.csv} files
#' are separated by ';', and decimals are expressed by comma (','). The
#' \code{pattern} argument is used to identify a common initial text among the
#' files. If only one file is to be loaded, \code{pattern} can be the full name
#' of the file. In the \code{folder} argument it is possible to insert a path
#' of the folder in which the files are included. If this field is left empty,
#' the function considers that the files are present in the working directory
#' of the project (\code{getwd()}).
#'
#' @param pattern A \code{character} object with a common initial text among
#' the files to be read.
#' @param folder A \code{character} object of the path to the folder containing
#' the files.
#'
#' @return A tibble of the NDS-BR dataset.
#' @export
#'
#' @examples
#' ## Considering driver_A.csv, driver_B.csv and driver_C.csv:
#' path <- system.file("extdata", package = "ndsbr")
#' df <- nds_load_data("driver", path)
nds_load_data <- function(pattern, folder = NULL) {

  if (missing(pattern)) {
    stop("Pattern is missing")
  }

  pattern_init <- paste0("^", pattern)

  column_types <- readr::cols(
    DRIVER = readr::col_character(),
    LONG = readr::col_double(),
    LAT = readr::col_double(),
    DAY = readr::col_character(),
    DAY_CORRIGIDO = readr::col_character(),
    `03:00:00` = readr::col_character(),
    TRIP = readr::col_number(),
    ID = readr::col_character(),
    PR = readr::col_character(),
    H = readr::col_number(),
    M = readr::col_number(),
    S = readr::col_number(),
    TIME_ACUM = readr::col_number(),
    SPD_MPH = readr::col_double(),
    SPD_KMH = readr::col_double(),
    ACEL_MS2 = readr::col_double(),
    HEADING = readr::col_double(),
    ALTITUDE_FT = readr::col_number(),
    VALID_TIME = readr::col_character(),
    TIMESTAMP_GPS = readr::col_character(),
    CPOOL = readr::col_character(),
    CPOOLING_CHECKED = readr::col_character(),
    WSB = readr::col_character(),
    UMP_YN = readr::col_character(),
    UMP = readr::col_character(),
    PICK_UP = readr::col_character(),
    ACTION = readr::col_character(),
    GPS_FILE = readr::col_character(),
    CIDADE = readr::col_character(),
    BAIRRO = readr::col_character(),
    NOME_RUA = readr::col_character(),
    HIERARQUIA_CWB = readr::col_character(),
    HIERARQUIA_CTB = readr::col_character(),
    LIMITE_VEL = readr::col_character()
  )

  if (is.null(folder)) {
    files_path <- list.files(pattern = pattern_init)

    if (identical(files_path, character(0))) {
      stop("Files not found")
    }

  } else {
    files_names <- list.files(path = folder, pattern = pattern_init)

    if (identical(files_names, character(0))) {
      stop("Files not found")
    }

    files_path <- paste0(folder, "/", files_names)
  }

  files <- vector(length = length(files_path))
  files <- purrr::map(
    files_path, ~readr::read_csv2(.x, col_types = column_types)
  )

  purrr::reduce(files, dplyr::bind_rows)
}
