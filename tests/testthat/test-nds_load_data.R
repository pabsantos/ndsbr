test_that("nds_load_data returns error if 'pattern' is missing", {
  expect_error(nds_load_data(), "'pattern' is missing")
})

test_that("nds_load_data returns error if 'pattern' doesn't detect any file", {
  expect_error(nds_load_data("xyz"), "Files not found")
})
