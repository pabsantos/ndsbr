# nds_calc_time -----------------------------------------------------------

test_that("nds_calc_time works correctly with default units (seconds)", {
  # Create a sample data frame
  data <- data.frame(
    DRIVER = c("driver1", "driver1", "driver2", "driver2", "driver2"),
    TIME_ACUM = c(1, 2, 1, 2, 3),
    VALID_TIME = c("Yes", "No", "Yes", "Yes", "No")
  )

  # Run the function
  result <- nds_calc_time(data, by = DRIVER)

  # Expected result
  expected_result <- dplyr::tibble(
    DRIVER = c("driver1", "driver2"),
    TIME = c(2, 3)
  )

  # Check if the result is as expected
  expect_equal(result, expected_result)
})

test_that("nds_calc_time works correctly with units in minutes", {
  # Create a sample data frame
  data <- data.frame(
    DRIVER = c("driver1", "driver1", "driver2", "driver2", "driver2"),
    TIME_ACUM = c(1, 2, 1, 2, 3),
    VALID_TIME = c("Yes", "No", "Yes", "Yes", "No")
  )

  # Run the function
  result <- nds_calc_time(data, by = DRIVER, units = "minutes")

  # Expected result
  expected_result <- dplyr::tibble(
    DRIVER = c("driver1", "driver2"),
    TIME = c(2/60, 3/60)
  )

  # Check if the result is as expected
  expect_equal(result, expected_result)
})

test_that("nds_calc_time works correctly with units in hours", {
  # Create a sample data frame
  data <- data.frame(
    DRIVER = c("driver1", "driver1", "driver2", "driver2", "driver2"),
    TIME_ACUM = c(1, 2, 1, 2, 3),
    VALID_TIME = c("Yes", "No", "Yes", "Yes", "No")
  )

  # Run the function
  result <- nds_calc_time(data, by = DRIVER, units = "hours")

  # Expected result
  expected_result <- dplyr::tibble(
    DRIVER = c("driver1", "driver2"),
    TIME = c(2/3600, 3/3600)
  )

  # Check if the result is as expected
  expect_equal(result, expected_result)
})

test_that("nds_calc_time works correctly with valid data only", {
  # Create a sample data frame
  data <- data.frame(
    DRIVER = c("driver1", "driver1", "driver2", "driver2", "driver2"),
    TIME_ACUM = c(1, 2, 1, 2, 3),
    VALID_TIME = c("Yes", "No", "Yes", "Yes", "No")
  )

  # Run the function with valid = "yes"
  result <- nds_calc_time(data, by = DRIVER, valid = "Yes")

  # Expected result
  expected_result <- dplyr::tibble(
    DRIVER = c("driver1", "driver2"),
    TIME = c(2, 3)
  )

  # Check if the result is as expected
  expect_equal(result, expected_result)
})

test_that("nds_calc_time returns an error when 'data' is missing", {
  expect_error(nds_calc_time(by = DRIVER), "'data' is missing")
})

test_that("nds_calc_time returns an error when 'by' is missing", {
  data <- data.frame(DRIVER = "driver1", TIME_ACUM = 1)
  expect_error(nds_calc_time(data), "'by' is missing")
})

test_that("nds_calc_time returns an error for invalid time unit", {
  data <- data.frame(DRIVER = "driver1", TIME_ACUM = 1)
  expect_error(
    nds_calc_time(data, by = DRIVER, units = "days"),
    "invalid time unit"
  )
})

# nds_calc_dist -----------------------------------------------------------

test_that("nds_calc_dist works correctly with default units (meters)", {
  # Create a sample sf object with linestring geometry
  data <- sf::st_as_sf(data.frame(
    DRIVER = c("driver1", "driver1", "driver2"),
    wkt_lines = c(
      "LINESTRING (30 -100, 31 -101)",
      "LINESTRING (31 -101, 32 -102)",
      "LINESTRING (40 -110, 41 -111)"
    ),
    stringsAsFactors = FALSE
  ), wkt = "wkt_lines", crs = 31982)

  # Run the function
  result <- nds_calc_dist(data, geom = wkt_lines, by = DRIVER)

  # Expected result
  expected_result <- dplyr::tibble(
    DRIVER = c("driver1", "driver2"),
    DIST = c(
      as.numeric(
        sf::st_length(
          sf::st_sfc(
            sf::st_linestring(
              matrix(
                c(30, -100, 31, -101, 31, -101, 32, -102),
                ncol = 2,
                byrow = TRUE
              )
            )
          )
        )
      ),
      as.numeric(sf::st_length(sf::st_sfc(sf::st_linestring(
        matrix(c(40, -110, 41, -111), ncol = 2, byrow = TRUE)
      ))))
    )
  )

  # Check if the result is as expected
  expect_equal(result, expected_result)
})

test_that("nds_calc_dist works correctly with units in kilometers", {
  # Create a sample sf object with linestring geometry
  data <- sf::st_as_sf(data.frame(
    DRIVER = c("driver1", "driver1", "driver2"),
    wkt_lines = c(
      "LINESTRING (30 -100, 31 -101)",
      "LINESTRING (31 -101, 32 -102)",
      "LINESTRING (40 -110, 41 -111)"
    ),
    stringsAsFactors = FALSE
  ), wkt = "wkt_lines", crs = 31982)

  # Run the function
  result <- nds_calc_dist(
    data,
    geom = wkt_lines,
    by = DRIVER,
    units = "kilometers"
  )

  # Expected result
  expected_result <- dplyr::tibble(
    DRIVER = c("driver1", "driver2"),
    DIST = c(
      as.numeric(sf::st_length(sf::st_sfc(
        sf::st_linestring(matrix(
          c(30, -100, 31, -101, 31, -101, 32, -102),
          ncol = 2,
          byrow = TRUE
        ))
      ))) / 1000,
      as.numeric(sf::st_length(sf::st_sfc(
        sf::st_linestring(matrix(
          c(40, -110, 41, -111), ncol = 2, byrow = TRUE
        ))
      ))) / 1000
    )
  )

  # Check if the result is as expected
  expect_equal(result, expected_result)
})

test_that("nds_calc_dist returns an error when 'data' is missing", {
  expect_error(nds_calc_dist(geom = geometry, by = DRIVER), "'data' is missing")
})

test_that("nds_calc_dist returns an error when 'by' is missing", {
  data <- sf::st_as_sf(data.frame(
    DRIVER = "driver1",
    wkt_lines = "LINESTRING (30 -100, 31 -101)",
    stringsAsFactors = FALSE
  ), wkt = "wkt_lines", crs = 4674)
  expect_error(nds_calc_dist(data, geom = geometry), "'by' is missing")
})

test_that("nds_calc_dist returns an error when 'geom' is missing", {
  data <- sf::st_as_sf(data.frame(
    DRIVER = "driver1",
    wkt_lines = "LINESTRING (30 -100, 31 -101)",
    stringsAsFactors = FALSE
  ), wkt = "wkt_lines", crs = 4674)
  expect_error(nds_calc_dist(data, by = DRIVER), "'geom' is missing")
})

test_that("nds_calc_dist returns an error for invalid distance unit", {
  data <- sf::st_as_sf(
    data.frame(
      DRIVER = "driver1",
      wkt_lines = "LINESTRING (30 -100, 31 -101)",
      stringsAsFactors = FALSE
    ),
    wkt = "wkt_lines",
    crs = 4674
  )
  expect_error(
    nds_calc_dist(
      data,
      geom = geometry,
      by = DRIVER,
      units = "miles"
    ),
    "invalid distance unit"
  )
})

# nds_calc_speeding -------------------------------------------------------

test_that(
  "nds_calc_speeding works correctly with type 'time' and percentage FALSE", {
  # Create a sample data frame
  data <- dplyr::tibble(
    ID = c(1, 1, 2, 2),
    SPD_KMH = c(60, 80, 90, 100),
    LIMITE_VEL = c(70, 70, 95, 95),
    DRIVER = c("driver1", "driver1", "driver2", "driver2")
  )

  # Run the function
  result <- nds_calc_speeding(
    data,
    type = "time",
    by = ID,
    spd = 5,
    exp = 10,
    percentage = FALSE
  )

  # Expected result
  expected_result <- dplyr::tibble(
    ID = c(1, 2),
    SP = c(0.5, NA)
  )

  # Check if the result is as expected
  expect_equal(result |> dplyr::ungroup(), expected_result)
})

test_that(
  "nds_calc_speeding works correctly with type 'time' and percentage TRUE", {
  # Create a sample data frame
  data <- dplyr::tibble(
    ID = c(1, 1, 2, 2),
    SPD_KMH = c(60, 80, 90, 100),
    LIMITE_VEL = c(70, 70, 95, 95),
    DRIVER = c("driver1", "driver1", "driver2", "driver2")
  )

  # Run the function
  result <- nds_calc_speeding(
    data,
    type = "time",
    by = ID,
    spd = 10,
    exp = 5,
    percentage = TRUE
  )

  # Expected result
  expected_result <- dplyr::tibble(
    ID = c(1, 2),
    SP = c(NA_real_, NA_real_)
  )

  # Check if the result is as expected
  expect_equal(result |> dplyr::ungroup(), expected_result)
})

test_that("nds_calc_speeding works correctly with type 'distance' and percentage TRUE", {
  # Create a sample sf object with linestring geometry
  data <- sf::st_as_sf(data.frame(
    ID = c(1, 1, 2, 2),
    SPD_KMH = c(60, 80, 90, 100),
    LIMITE_VEL = c(70, 70, 95, 95),
    DRIVER = c("driver1", "driver1", "driver2", "driver2"),
    wkt_lines = c(
      "LINESTRING (0 0, 1 1)",
      "LINESTRING (1 1, 2 2)",
      "LINESTRING (2 2, 3 3)",
      "LINESTRING (3 3, 4 4)"
    )
  ), wkt = "wkt_lines", crs = 4326)

  # Run the function
  result <- nds_calc_speeding(
    data,
    type = "distance",
    by = ID,
    spd = 10,
    exp = 5,
    percentage = TRUE
  )

  # Expected result
  expected_result <- dplyr::tibble(
    ID = c(1, 2),
    SP = c(NA_real_, NA_real_) # both driver1 and driver2 have one exposure and one speeding event
  )

  # Check if the result is as expected
  expect_equal(result |> dplyr::ungroup(), expected_result)
})

test_that("nds_calc_speeding handles missing arguments", {
  data <- dplyr::tibble(
    ID = c(1, 1, 2, 2),
    SPD_KMH = c(60, 80, 90, 100),
    LIMITE_VEL = c(70, 70, 95, 95),
    DRIVER = c("driver1", "driver1", "driver2", "driver2")
  )

  expect_error(nds_calc_speeding(
    data,
    type = "time",
    by = ID,
    spd = 5
  ),
  "'exp' is missing")
  expect_error(nds_calc_speeding(
    data,
    type = "time",
    by = ID,
    exp = 10
  ),
  "'spd' is missing")
  expect_error(nds_calc_speeding(
    data,
    type = "time",
    spd = 5,
    exp = 10
  ),
  "'by' is missing")
  expect_error(nds_calc_speeding(data, by = ID, spd = 5, exp = 10),
               "'data' is missing")
  expect_error(nds_calc_speeding(
    type = "time",
    by = ID,
    spd = 5,
    exp = 10
  ),
  "'data' is missing")
})

test_that("nds_calc_speeding handles invalid type", {
  data <- dplyr::tibble(
    ID = c(1, 1, 2, 2),
    SPD_KMH = c(60, 80, 90, 100),
    LIMITE_VEL = c(70, 70, 95, 95),
    DRIVER = c("driver1", "driver1", "driver2", "driver2")
  )

  expect_error(nds_calc_speeding(
    data,
    type = "invalid",
    by = ID,
    spd = 5,
    exp = 10
  ),
  "Invalid 'type'")
})
