nds_create_lines <- function(data) {
  data %>%
    sf::st_drop_geometry() %>%
    tidyr::drop_na(LONG, LAT) %>%
    dplyr::filter(LONG != 0, LAT != 0) %>%
    dplyr::arrange(DRIVER, ID, TIME_ACUM) %>%
    dplyr::mutate(
      time_lag = TIME_ACUM - dplyr::lag(TIME_ACUM),
      wkt = dplyr::case_when(
        time_lag == 1 ~ paste0(
          "LINESTRING (", dplyr::lag(LONG), " ", dplyr::lag(LAT), ", ", LONG,
          " ", LAT, ")"
        ),
        time_lag > 1 ~ "0",
        time_lag < 1 ~ "0",
        TRUE ~ NA_character_
      )
    ) %>%
    dplyr::filter(wkt != "0") %>%
    dplyr::select(-time_lag) %>%
    sf::st_as_sf(wkt = "wkt") %>%
    sf::st_set_crs(4674)
}
