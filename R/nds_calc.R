#' Calculate traveled time of the naturalistic data
#'
#' \code{nds_calc_time} extracts traveled time from the naturalistic data.
#'
#' This function uses a naturalistic data sample (\link{nds_load_data}) as main
#' input and extracts its traveled time, grouping the results by the attributes
#' of the desired variable (parameter \code{by}). The time unit can be in
#' "seconds" (default), "minutes" or "hours". It is possible to filter only
#' valid time data using the \code{valid} parameter. In it's default, the
#' function uses all data, including invalid times.
#'
#' @param data A tibble or data.frame object containing naturalistic data
#' @param by A column name to group the results
#' @param units The desired time unit ("seconds", "minutes" or "hours")
#' @param valid Option to select all data or valid data ("all", "yes").
#'
#' @return A tibble with traveled time results.
#' @export
#'
#' @seealso \link{nds_load_data}
#'
#' @examples
#' path <- system.file("extdata", package = "ndsbr")
#' df <- nds_load_data("driver", path)
#' nds_calc_time(df, "DRIVER")
nds_calc_time <- function(data, by, units = "seconds", valid = "all") {

  if (missing(data)) {
    stop("'data' is missing")
  }

  if (missing(by)) {
    stop("'by' is missing")
  }

  if (!units %in% c("seconds", "minutes", "hours")) {
    stop("invalid time unit")
  }

  data <- data %>%
    dplyr::group_by({{ by }}) %>%
    dplyr::summarise(TIME = dplyr::n())

  if (units == "hours") {
    data <- data %>% dplyr::mutate(TIME = .data$TIME / 3600)
  }

  if (units == "minutes") {
    data <- data %>% dplyr::mutate(TIME = .data$TIME / 60)
  }

  if (valid == "yes") {
    data <- data %>%
      dplyr::filter(.data$VALID_TIME == "Yes" & .data$NOME_RUA != "NPI")
  }

  return(data)
}

nds_calc_dist <- function(data, by, units = "meters") {

  if (missing(data)) {
    stop("'data' is missing")
  }

  if (missing(by)) {
    stop("'by' is missing")
  }

  if (!units %in% c("meters", "kilometers")) {
    stop("invalid distance unit")
  }
  data <- data %>%
    dplyr::mutate(
      dist = sf::st_length(.data$wkt_lines),
      dist = units::drop_units(.data$dist)
    ) %>%
    sf::st_drop_geometry() %>%
    dplyr::group_by({{ by }}) %>%
    dplyr::summarise(DIST = sum(.data$dist))

  if (units == "kilometers") {
    data <- data %>%
      dplyr::mutate(DIST = .data$DIST / 1000)
  }

  return(data)
}
