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

#' Title
#'
#' @return
#' @export
#'
#' @examples
nds_download_cwb_osm <- function() {
  message("Downloading OSM data...")
  cwb_bbox <- osmdata::getbb("Curitiba, Brazil")
  values <- c(
    "motorway", "trunk", "primary", "secondary", "tertiary", "road",
    "residential", "motorway_link", "trunk_link", "primary_link",
    "secondary_link", "tertiary_link"
  )
  osm_cwb <- osmdata::opq(bbox = cwb_bbox) |>
    osmdata::add_osm_feature(key = "highway", value = values) |>
    osmdata::osmdata_sf()
  cwb_axis <- osm_cwb$osm_lines
  selected_vars <- c("osm_id", "name", "highway", "maxspeed")
  cwb_axis <- subset(cwb_axis, select = selected_vars)
  return(cwb_axis)
}
