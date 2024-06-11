test_that("nds_split_data returns an error when 'data' is missing", {
  expect_error(nds_split_data(), "'data' is missing")
})
