#' Split naturalistic data into the original files
#'
#' `r lifecycle::badge('deprecated')`
#'
#' This function splits the naturalistic data into the original separation of
#' the NDS-BR sample.
#'
#' \code{nds_split_data} takes the naturalistic data imported by
#' \link{nds_load_data} and splits into four tibbles, matching the original
#' separation of drivers provided by the sample of NDS-BR. The function uses
#' the column containing driver names to properly split the data.
#'
#' @param data A data.frame or tibble with naturalistic data
#' @param driver A column with the names of the drivers.
#'
#' @return A list with four tibbles of the NDS-BR dataset.
#' @export
#'
#' @examples
#' path <- system.file("extdata", package = "ndsbr")
#' df <- nds_load_data("driver", path)
#' df_split <- nds_split_data(df)
nds_split_data <- function(data, driver = .data$DRIVER) {

  if (missing(data)) {
    stop("'data' is missing")
  }

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
