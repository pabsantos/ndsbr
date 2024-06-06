url <- "https://ippuc.org.br/geodownloads/SHAPES_SIRGAS/EIXO_RUA_SIRGAS.zip"
ippuc_road_axis <- ndsbr::nds_download_sf(url)

usethis::use_data(ippuc_road_axis, overwrite = TRUE)
