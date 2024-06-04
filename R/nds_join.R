nds_join_axis <- function(
    ndsbr_data,
    road_axis,
    axis_vars = c("NMVIA", "SVIARIO", "HIERARQUIA")) {
  road_axis_buffer <- sf::st_buffer(road_axis, dist = 10, endCapStyle = "FLAT")
  if (sf::st_crs(road_axis_buffer)$input != "EPSG:4674") {
    road_axis_buffer <- sf::st_transform(road_axis_buffer, 4674)
  }

  road_axis_buffer <- subset(road_axis_buffer, select = axis_vars)
  nds_joined_data <- sf::st_join(ndsbr_data, road_axis_buffer)
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

nds_join_neigh <- function(ndsbr_data, neigh_data, vars = "NOME") {
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
