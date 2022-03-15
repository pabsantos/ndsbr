#' Download spatial data
#'
#' \code{nds_download_sf} downloads spatial data in \code{.zip} format and
#' extracts into a \code{sf} object.
#'
#' @param url Download url.
#'
#' @return A \code{sf} object.
#' @export
#'
#' @examples
#' url <- "https://ippuc.org.br/geodownloads/SHAPES_SIRGAS/EIXO_RUA_SIRGAS.zip"
#' road <- nds_download_sf(url)
nds_download_sf <- function(url) {
  temp <- tempfile()
  temp2 <- tempfile()
  utils::download.file(url, destfile = temp)
  utils::unzip(zipfile = temp, exdir = temp2)
  file <- sf::st_read(temp2)
  unlink(c(temp, temp2))
  return(file)
}
