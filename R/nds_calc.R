#' Calculate traveled time from the naturalistic data
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
#' @seealso \link{nds_load_data}; \link{nds_calc_dist}
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
      dplyr::filter(.data$VALID_TIME == "Yes")
  }

  return(data)
}

#' Calculate traveled distance from the naturalistic data
#'
#' \code{nds_calc_dist} extracts traveled time from the naturalistic data.
#'
#' This function uses a sf object (\link{nds_create_lines}) as main
#' input and extracts its traveled distance, grouping the results by the
#' attributes of the desired variable (parameter \code{by}). The distance
#' unit can be in "meters" (default) or "kilometers". The \code{geom}
#' parameter is used to identify the column that contains the geometry of the
#' sf object.
#'
#' @param data A sf object with linestring geometry
#' @param geom The geometry column in the sf object
#' @param by A column name to group the results
#' @param units The desired distance unit ("meters", "kilometers")
#'
#' @return A tibble with traveled distance results
#' @export
#'
#' @seealso \link{nds_create_lines}; \link{nds_calc_time}
#'
#' @examples
#' path <- system.file("extdata", package = "ndsbr")
#' nds_data <- nds_load_data("driver", path)
#' nds_lines <- nds_create_lines(nds_data, x = LONG, y = LAT)
#' nds_calc_dist(nds_lines, wkt_lines, DRIVER)
nds_calc_dist <- function(data, geom, by, units = "meters") {

  if (missing(data)) {
    stop("'data' is missing")
  }

  if (missing(by)) {
    stop("'by' is missing")
  }

  if (missing(geom)) {
    stop("'geom' is missing")
  }

  if (!units %in% c("meters", "kilometers")) {
    stop("invalid distance unit")
  }

  data <- data %>%
    dplyr::mutate(
      dist = sf::st_length({{ geom }}),
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

#' Calculate speeding rate from the naturalistic data
#'
#' \code{nds_calc_speeding} extracts the speeding rate from the
#' naturalistic data
#'
#' This function uses the naturalistic data as main
#' input and extracts the speeding rate , grouping the results by the
#' attributes of the desired variable (parameter \code{by}). If \code{type} is
#' set to "distance", \code{data} must be a sf object with linestring geometry.
#' Otherwise, it can be a tibble or data.frame. \code{spd} and \code{exp} sets
#' two thresholds to identify exposure and speeding situations, based on the
#' performed speeds and speed limits. If \code{percentage} is TRUE, these
#' thresholds are set as percentages of the speed limit.
#'
#' @param data Object with naturalistic data (tibble or sf)
#' @param type Character with the type of speeding results
#' ("time" or "distance")
#' @param by A column name to group the results
#' @param spd Numeric value of the speeding threshold
#' @param exp Numeric value of the exposure threshold
#' @param percentage Boolean value establishing if thresholds are percentages
#' (TRUE or FALSE)
#'
#' @return A tibble with speeding rate results
#' @export
#'
#' @examples
#' path <- system.file("extdata", package = "ndsbr")
#' nds_data <- nds_load_data("driver", path)
#' nds_calc_speeding(nds_data, type = "time", by = ID, spd = 5, exp = 10)
nds_calc_speeding <- function(data, type, by, spd, exp, percentage = FALSE) {

  if (missing(data)) {
    stop("'data' is missing")
  }

  if (missing(type)) {
    stop("'data' is missing")
  }

  if (missing(by)) {
    stop("'by' is missing")
  }

  if (missing(spd)) {
    stop("'spd' is missing")
  }

  if (missing(exp)) {
    stop("'exp' is missing")
  }

  if (!type %in% c("distance",  "time")) {
    stop("Invalid 'type'")
  }

  data <- data %>%
    dplyr::filter(.data$LIMITE_VEL != "NPI") %>%
    dplyr::mutate(LIMITE_VEL = as.double(.data$LIMITE_VEL))

  if (percentage) {
    data <- data %>%
      dplyr::mutate(STATUS = dplyr::case_when(
        .data$SPD_KMH >= .data$LIMITE_VEL * (1 - (exp / 100)) &
          .data$SPD_KMH <= .data$LIMITE_VEL * (1 + (spd / 100)) ~ "exposure",
        .data$SPD_KMH > .data$LIMITE_VEL * (1 + (spd / 100)) ~ "speeding",
        TRUE ~ "no_exposure"
      ))
  } else {
    data <- data %>%
      dplyr::mutate(STATUS = dplyr::case_when(
        .data$SPD_KMH >= .data$LIMITE_VEL - exp &
          .data$SPD_KMH <= .data$LIMITE_VEL + spd ~ "exposure",
        .data$SPD_KMH > .data$LIMITE_VEL + spd ~ "speeding",
        TRUE ~ "no_exposure"
      ))
  }

  data <- data %>% dplyr::filter(.data$STATUS != "no_exposure")

  if (type == "distance") {
    data <- data %>%
      dplyr::mutate(
        DIST = sf::st_length(.data$wkt_lines),
        DIST = units::drop_units(.data$DIST)
      ) %>%
      sf::st_drop_geometry() %>%
      dplyr::group_by({{ by }}, .data$STATUS) %>%
      dplyr::summarise(DIST = sum(.data$DIST)) %>%
      tidyr::pivot_wider(
        names_from = .data$STATUS, values_from = .data$DIST
      ) %>%
      dplyr::mutate(SP = .data$speeding / (.data$exposure + .data$speeding)) %>%
      dplyr::select({{ by }}, .data$SP)
  }

  if (type == "time") {
    data <- data %>%
      dplyr::group_by({{ by }}, .data$STATUS) %>%
      dplyr::summarise(TIME = dplyr::n()) %>%
      tidyr::pivot_wider(
        names_from = .data$STATUS, values_from = .data$TIME
      ) %>%
      dplyr::mutate(SP = .data$speeding / (.data$exposure + .data$speeding)) %>%
      dplyr::select({{ by }}, .data$SP)
  }

  return(data)
}
