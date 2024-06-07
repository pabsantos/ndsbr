url <- "https://ippuc.org.br/geodownloads/SHAPES_SIRGAS/EIXO_RUA_SIRGAS.zip"
ippuc_road_axis <- ndsbr::nds_download_sf(
  url,
  options = "ENCODING=WINDOWS-1252"
)
ippuc_road_axis <- sf::st_transform(ippuc_road_axis, crs = 4674)
usethis::use_data(ippuc_road_axis, overwrite = TRUE, compress = "xz")
