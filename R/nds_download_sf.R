nds_download_sf <- function(url) {
  temp <- tempfile()
  temp2 <- tempfile()
  download.file(url, destfile = temp)
  unzip(zipfile = temp, exdir = temp2)
  file <- sf::st_read(temp2)
  unlink(c(temp, temp2))
  return(file)
}
