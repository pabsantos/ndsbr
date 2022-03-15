#' Title
#'
#' @param data
#' @param x
#' @param y
#' @param valid
#'
#' @return
#' @export
#'
#' @examples
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
