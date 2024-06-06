ndsbr_data <- ndsbr::nds_load_data(
  pattern = "driver",
  folder = system.file("extdata", package = "ndsbr")
)

ndsbr_data_sf <- ndsbr::nds_create_points(ndsbr_data, x = LONG, y = LAT)

usethis::use_data(ndsbr_data_sf, overwrite = TRUE)
