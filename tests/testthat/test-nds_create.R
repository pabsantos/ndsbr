
# nds_create_lines --------------------------------------------------------

test_that("nds_create_lines works correctly with all data", {
  # Create a sample data frame
  data <- data.frame(
    DRIVER = c("driver1", "driver1", "driver1", "driver2", "driver2"),
    ID = c(1, 1, 1, 2, 2),
    TIME_ACUM = c(1, 2, 3, 1, 2),
    LONG = c(30, 31, 32, 40, 41),
    LAT = c(-100, -101, -102, -110, -111),
    VALID_TIME = c("Yes", "Yes", "No", "Yes", "Yes")
  )

  # Run the function
  result <- nds_create_lines(data, x = LONG, y = LAT)

  # Check if result is an sf object
  expect_s3_class(result, "sf")

  # Check if the CRS is set correctly
  expect_equal(sf::st_crs(result)$epsg, 4674)
})

test_that("nds_create_lines works correctly with valid data", {
  # Create a sample data frame
  data <- data.frame(
    DRIVER = c("driver1", "driver1", "driver1", "driver2", "driver2"),
    ID = c(1, 1, 1, 2, 2),
    TIME_ACUM = c(1, 2, 3, 1, 2),
    LONG = c(30, 31, 32, 40, 41),
    LAT = c(-100, -101, -102, -110, -111),
    VALID_TIME = c("Yes", "Yes", "No", "Yes", "Yes")
  )

  # Run the function with valid = "yes"
  result <- nds_create_lines(data, x = LONG, y = LAT, valid = "yes")

  # Check if result is an sf object
  expect_s3_class(result, "sf")

  # Check if the CRS is set correctly
  expect_equal(sf::st_crs(result)$epsg, 4674)

  # Check if the geometries are correct
  expected_lines <- sf::st_as_sf(data.frame(
    DRIVER = c("driver1", "driver2"),
    ID = c(1, 2),
    TIME_ACUM = c(1, 1),
    wkt_lines = c(
      "LINESTRING (30 -100, 31 -101)",
      "LINESTRING (40 -110, 41 -111)"
    )
  ), wkt = "wkt_lines", crs = 4674)

  expect_equal(sf::st_geometry(result), sf::st_geometry(expected_lines))
})

test_that("nds_create_lines returns an error when 'data' is missing", {
  expect_error(nds_create_lines(), "'data' is missing")
})

test_that("nds_create_lines returns an error when 'x' is missing", {
  data <- data.frame(DRIVER = "driver1", ID = 1, TIME_ACUM = 1, LAT = -100)
  expect_error(nds_create_lines(data, y = LAT), "'x' coordinate is missing")
})

test_that("nds_create_lines returns an error when 'y' is missing", {
  data <- data.frame(DRIVER = "driver1", ID = 1, TIME_ACUM = 1, LONG = 30)
  expect_error(nds_create_lines(data, x = LONG), "'y' coordinate is missing")
})

# nds_create_points -------------------------------------------------------

test_that("nds_create_points works correctly with all data", {
  # Create a sample data frame
  data <- data.frame(
    DRIVER = c("driver1", "driver1", "driver2", "driver2"),
    ID = c(1, 1, 2, 2),
    TIME_ACUM = c(1, 2, 1, 2),
    LONG = c(30, 31, 40, 41),
    LAT = c(-100, -101, -110, -111),
    VALID_TIME = c("Yes", "No", "Yes", "Yes")
  )

  # Run the function
  result <- nds_create_points(data, x = LONG, y = LAT)

  # Check if result is an sf object
  expect_s3_class(result, "sf")

  # Check if the CRS is set correctly
  expect_equal(sf::st_crs(result)$epsg, 4674)
})

test_that("nds_create_points works correctly with valid data", {
  # Create a sample data frame
  data <- data.frame(
    DRIVER = c("driver1", "driver1", "driver2", "driver2"),
    ID = c(1, 1, 2, 2),
    TIME_ACUM = c(1, 2, 1, 2),
    LONG = c(30, 31, 40, 41),
    LAT = c(-100, -101, -110, -111),
    VALID_TIME = c("Yes", "No", "Yes", "Yes")
  )

  # Run the function with valid = "yes"
  result <- nds_create_points(data, x = LONG, y = LAT, valid = "yes")

  # Check if result is an sf object
  expect_s3_class(result, "sf")

  # Check if the CRS is set correctly
  expect_equal(sf::st_crs(result)$epsg, 4674)

})

test_that("nds_create_points returns an error when 'data' is missing", {
  expect_error(nds_create_points(), "'data' is missing")
})

test_that("nds_create_points returns an error when 'x' is missing", {
  data <- data.frame(DRIVER = "driver1", ID = 1, TIME_ACUM = 1, LAT = -100)
  expect_error(nds_create_points(data, y = LAT), "'x' coordinate is missing")
})

test_that("nds_create_points returns an error when 'y' is missing", {
  data <- data.frame(DRIVER = "driver1", ID = 1, TIME_ACUM = 1, LONG = 30)
  expect_error(nds_create_points(data, x = LONG), "'y' coordinate is missing")
})

