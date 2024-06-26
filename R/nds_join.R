#' Join NDS data with road axis data
#'
#' This function joins NDS data with road axis data, including a 10-meter buffer
#' around axis data and arranging names and road hierarchy data.
#'
#' @param ndsbr_data An `sf` object representing NDS data. This object
#' should have a `POINT` geometry type.
#' @param road_axis An `sf` object representing road axis data. This object
#' should have a `LINESTRING` or `MULTILINESTRING` geometry type.
#' @param axis_vars A character vector of variables to join from the road axis
#' data. Default is `c("NMVIA", "SVIARIO", "HIERARQUIA")`.
#'
#' @return An `sf` object with the joined data.
#' @export
#'
#' @examples
#' \dontrun{
#' result <- nds_join_axis(ndsbr_data_sf, ippuc_road_axis)
#' }
#'
nds_join_axis <- function(
    ndsbr_data,
    road_axis,
    axis_vars = c("NMVIA", "SVIARIO", "HIERARQUIA")) {

  if (missing(ndsbr_data)) {
    stop("'ndsbr_data' is missing")
  }

  if (missing(road_axis)) {
    stop("'road_axis' is missing")
  }

  if (!inherits(ndsbr_data, "sf")) {
    stop("'ndsbr_data' is not a 'sf' object")
  }

  if (!inherits(road_axis, "sf")) {
    stop("'road_axis' is not a 'sf' object")
  }

  if (!inherits(axis_vars, "character")) {
    stop("'axis_vars' is not a 'character' object")
  }


  if (sf::st_geometry_type(ndsbr_data)[1] != "POINT") {
    stop("Invalid 'ndsbr_data' geometry type")
  }

  axis_type <- c("LINESTRING", "MULTILINESTRING")
  if (!sf::st_geometry_type(road_axis)[1] %in% axis_type) {
    stop("Invalid 'road_axis' geometry type")
  }

  message("Making a 10-meter buffer around axis data...")

  if (sf::st_crs(road_axis)$input != "EPGS:31982") {
    road_axis <- sf::st_transform(road_axis, 31982)
  }

  road_axis_buffer <- sf::st_buffer(road_axis, dist = 10, endCapStyle = "FLAT")

  if (sf::st_crs(road_axis_buffer)$input != "EPSG:4674") {
    road_axis_buffer <- sf::st_transform(road_axis_buffer, 4674)
  }

  road_axis_buffer <- sf::st_make_valid(road_axis_buffer)

  road_axis_buffer <- subset(road_axis_buffer, select = axis_vars)

  message("Joining data...")

  nds_joined_data <- sf::st_join(ndsbr_data, road_axis_buffer)

  message("Arranging names and road hierarchy data...")

  nds_joined_data <- dplyr::distinct(
    nds_joined_data,
    .data$ID,
    .data$TIME_ACUM,
    .keep_all = TRUE
  )

  nds_joined_data$NOME_RUA <- nds_joined_data$NMVIA
  nds_joined_data$NOME_RUA[is.na(nds_joined_data$NOME_RUA)] <- "NPI"

  nds_joined_data$HIERARQUIA_CWB <- nds_joined_data$SVIARIO
  nds_joined_data$HIERARQUIA_CWB[is.na(nds_joined_data$HIERARQUIA_CWB)] <- "NPI"

  nds_joined_data$HIERARQUIA_CTB <- nds_joined_data$HIERARQUIA
  nds_joined_data$HIERARQUIA_CTB[is.na(nds_joined_data$HIERARQUIA_CTB)] <- "NPI"

  nds_joined_data$NMVIA <- NULL
  nds_joined_data$SVIARIO <- NULL
  nds_joined_data$HIERARQUIA <- NULL

  return(nds_joined_data)
}

#' Join NDS data with neighborhood data
#'
#' This function joins NDS data with neighborhood data, ensuring the correct
#' spatial reference and geometry types.
#'
#' @param ndsbr_data An `sf` object representing NDS data. This object should
#' have a `POINT` geometry type.
#' @param neigh_data An `sf` object representing neighborhood data. This object
#' should have a `POLYGON` geometry type.
#' @param vars A character vector of variables to join from the neighborhood
#' data. Default is `"NOME"`.
#'
#' @return An `sf` object with the joined data, including neighborhood
#' information.
#' @export
#'
#' @examples
#' result <- nds_join_neigh(ndsbr_data_sf, ippuc_neigh)
nds_join_neigh <- function(ndsbr_data, neigh_data, vars = "NOME") {

  if (missing(ndsbr_data)) {
    stop("'ndsbr_data' is missing")
  }

  if (missing(neigh_data)) {
    stop("'neigh_data' is missing")
  }

  if (!inherits(ndsbr_data, "sf")) {
    stop("'ndsbr_data' is not a 'sf' object")
  }

  if (!inherits(neigh_data, "sf")) {
    stop("'neigh_data' is not a 'sf' object")
  }

  if (!inherits(vars, "character")) {
    stop("'vars' is not a 'character' object")
  }

  if (sf::st_geometry_type(ndsbr_data)[1] != "POINT") {
    stop("Invalid 'ndsbr_data' geometry type")
  }

  if (sf::st_geometry_type(neigh_data)[1] != "POLYGON") {
    stop("Invalid 'neigh_data' geometry type")
  }

  if (sf::st_crs(neigh_data)$input != "EPSG:4674") {
    neigh_data <- sf::st_transform(neigh_data, 4674)
  }

  neigh_data <- subset(neigh_data, select = vars)
  nds_joined_data <- sf::st_join(ndsbr_data, neigh_data)
  nds_joined_data$BAIRRO <- nds_joined_data$NOME
  nds_joined_data$NOME <- NULL
  nds_joined_data$BAIRRO[is.na(nds_joined_data$BAIRRO)] <- "NPI"
  nds_joined_data$CIDADE[nds_joined_data$BAIRRO != "NPI"] <- "Curitiba"
  return(nds_joined_data)
}

#' Join NDS data with OSM speed limit data
#'
#' This function joins NDS data with OSM speed limit data,
#' including a 10-meter buffer around axis data and arranging speed limit
#' information.
#'
#' @param ndsbr_data An `sf` object representing NDS data.
#' This object should have a `POINT` geometry type.
#' @param osm_data An `sf` object representing OSM data.
#' This object should have a `LINESTRING` or `MULTILINESTRING` geometry type.
#' @param vars A character vector of variables to join from the OSM data.
#' Default is `"maxspeed"`.
#'
#' @return An `sf` object with the joined data,
#' including speed limit information.
#' @export
#'
#' @examples
#' \dontrun{
#' cwb_osm <- nds_download_cwb_osm()
#' result <- nds_join_spdlimit(ndsbr_data_sf, cwb_osm)
#' }
#'
nds_join_spdlimit <- function(ndsbr_data, osm_data, vars = "maxspeed") {

  if (missing(ndsbr_data)) {
    stop("'ndsbr_data' is missing")
  }

  if (missing(osm_data)) {
    stop("'osm_data' is missing")
  }

  if (!inherits(ndsbr_data, "sf")) {
    stop("'ndsbr_data' is not a 'sf' object")
  }

  if (!inherits(osm_data, "sf")) {
    stop("'osm_data' is not a 'sf' object")
  }

  if (!inherits(vars, "character")) {
    stop("'vars' is not a 'character' object")
  }

  if (sf::st_geometry_type(ndsbr_data)[1] != "POINT") {
    stop("Invalid 'ndsbr_data' geometry type")
  }

  axis_type <- c("LINESTRING", "MULTILINESTRING")
  if (!sf::st_geometry_type(osm_data)[1] %in% axis_type) {
    stop("Invalid 'osm_data' geometry type")
  }

  message("Making a 10-meter buffer around axis data...")

  osm_data <- subset(osm_data, select = vars)

  if (sf::st_crs(osm_data)$input != "EPGS:31982") {
    osm_data <- sf::st_transform(osm_data, 31982)
  }

  osm_data_buffer <- sf::st_buffer(osm_data, dist = 10, endCapStyle = "FLAT")

  message("Joining data...")

  if (sf::st_crs(osm_data_buffer)$input != "EPSG:4674") {
    osm_data_buffer <- sf::st_transform(osm_data_buffer, 4674)
  }

  nds_joined_data <- sf::st_join(ndsbr_data, osm_data_buffer)

  message("Arranging speed limit data...")

  nds_joined_data <- dplyr::distinct(
    nds_joined_data,
    .data$ID,
    .data$TIME_ACUM,
    .keep_all = TRUE
  )

  nds_joined_data$LIMITE_VEL <- nds_joined_data$maxspeed
  nds_joined_data$maxspeed <- NULL
  nds_joined_data$LIMITE_VEL[is.na(nds_joined_data$LIMITE_VEL)] <- "NPI"


  ## Corrigir essa parte
  nds_joined_data$LIMITE_VEL <- ifelse(
    nds_joined_data$LIMITE_VEL == "NPI",
    ifelse(
      nds_joined_data$HIERARQUIA_CTB == "1",
      "80",
      ifelse(
        nds_joined_data$HIERARQUIA_CTB == "2",
        "60",
        ifelse(
          nds_joined_data$HIERARQUIA_CTB == "3",
          "40",
          ifelse(
            nds_joined_data$HIERARQUIA_CTB == "4",
            "30",
            "NPI"
          )
        )
      )
    ),
    nds_joined_data$LIMITE_VEL
  )

  return(nds_joined_data)
}
