nds_split_data <- function(data, driver = DRIVER) {

  part1 <- c("A", "B", "C", "D", "J", "K", "W", "X")
  part2 <- c("L", "M", "N", "O", "P", "Q", "R", "Y")
  part3 <- c("E", "F", "G", "H", "S", "T", "U", "V")
  part4 <- c("I", "Z", "AA", "AB", "AC", "AD", "AE", "AF")

  parts <- list(part1, part2, part3, part4)

  data_split <- purrr::map(
    parts, ~dplyr::filter(data, {{ driver }} %in% .x)
  )

  return(data_split)
}
