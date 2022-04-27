#' Create a sf object using the linestring geometry
#'
#' This function creates a sf object using the linestring geometry, based on
#' the NDS-BR naturalistic data (see \link{nds_load_data}).
#'
#' \code{nds_create_lines} takes the naturalistic data as input and creates a
#' linestring spatial object. \code{x} and \code{y} arguments considers
#' longitude and latitude, respectively. It is possible to filter only valid
#' time data using the \code{valid} parameter, based on the \code{VALID_TIME}
#' attribute. In it's default, the function transforms all data,
#' including invalid times.
#'
#' @param data A data.frame or tibble object with coordinates.
#' @param x Data attribute with x coordinates.
#' @param y Data attribute with y coordinates.
#' @param valid Option to select all data or valid data ("all", "yes").
#'
#' @return A sf object with linestring geometry.
#' @export
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @seealso \link{nds_create_points}
#'
#' @examples
#' path <- system.file("extdata", package = "ndsbr")
#' nds_data <- nds_load_data("driver", path)
#' nds_create_lines(nds_data, x = LONG, y = LAT)
#'
nds_create_lines <- function(data, x, y, valid = "all") {

  if (missing(data)) {
    stop("'data' is missing")
  }

  if (missing(x)) {
    stop("'x' coordinate is missing")
  }

  if (missing(y)) {
    stop("'y' coordinate is missing")
  }

  if (valid == "yes") {
    data <- data %>%
      dplyr::filter(.data$VALID_TIME == "Yes")
  }

  data %>%
    tidyr::drop_na({{x}}, {{y}}) %>%
    dplyr::filter({{x}} != 0, {{y}} != 0) %>%
    dplyr::arrange(.data$DRIVER, .data$ID, .data$TIME_ACUM) %>%
    dplyr::mutate(
      time_lag = .data$TIME_ACUM - dplyr::lag(.data$TIME_ACUM),
      wkt_lines = dplyr::case_when(
        .data$time_lag == 1 ~ paste0(
          "LINESTRING (", dplyr::lag({{x}}), " ", dplyr::lag({{y}}),
          ", ", {{x}}, " ", {{y}}, ")"
        ),
        .data$time_lag > 1 ~ "0",
        .data$time_lag < 1 ~ "0",
        TRUE ~ NA_character_
      )
    ) %>%
    dplyr::filter(.data$wkt_lines != "0") %>%
    sf::st_as_sf(wkt = "wkt_lines") %>%
    dplyr::select(-.data$time_lag, -.data$wkt_lines) %>%
    sf::st_set_crs(4674)
}

#' Create a sf object with point geometry
#'
#' This function creates a sf object using the point geometry, based on
#' the NDS-BR naturalistic data (see \link{nds_load_data}).
#'
#' \code{nds_create_points} takes the naturalistic data as input and creates a
#' point spatial object. \code{x} and \code{y} arguments considers
#' longitude and latitude, respectively. It is possible to filter only valid
#' time data using the \code{valid} parameter. In it's default, the function
#' transforms all data, including invalid times.
#'
#' @param data A data.frame or tibble object with coordinates.
#' @param x Data attribute with x coordinates.
#' @param y Data attribute with y coordinates.
#' @param valid Option to select all data or valid data ("all", "yes").
#'
#' @return A sf object with point geometry
#' @export
#'
#' @seealso \link{nds_create_lines}
#'
#' @examples
#' path <- system.file("extdata", package = "ndsbr")
#' nds_data <- nds_load_data("driver", path)
#' nds_create_points(nds_data, x = LONG, y = LAT)
nds_create_points <- function(data, x, y, valid = "all") {
  if (missing(data)) {
    stop("'data' is missing")
  }

  if (missing(x)) {
    stop("'x' coordinate is missing")
  }

  if (missing(y)) {
    stop("'y' coordinate is missing")
  }

  if (valid == "yes") {
    data <- data %>%
      dplyr::filter(.data$VALID_TIME == "Yes") %>%
      dplyr::filter(.data$NOME_RUA != "NPI")
  }

  data %>%
    tidyr::drop_na({{ x }}, {{ y }}) %>%
    dplyr::filter({{ x }} != 0, {{ y }} != 0) %>%
    dplyr::rename(long = {{ x }}, lat = {{ y }}) %>%
    sf::st_as_sf(
      coords = c("long", "lat"),
      crs = 4674
    )
}
