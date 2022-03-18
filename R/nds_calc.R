df %>%
  dplyr::group_by(ID) %>%
  dplyr::summarise(TIME = dplyr::n() / 60)

nds_calc_time <- function(variables) {

}
