## code to prepare `osm_data` dataset goes here
osm_data <- ndsbr::nds_download_cwb_osm()
usethis::use_data(osm_data, overwrite = TRUE)
