url <- "https://ippuc.org.br/geodownloads/SHAPES_SIRGAS/DIVISA_DE_BAIRROS_SIRGAS.zip"
ippuc_neigh <- ndsbr::nds_download_sf(url)
usethis::use_data(ippuc_neigh, overwrite = TRUE)
