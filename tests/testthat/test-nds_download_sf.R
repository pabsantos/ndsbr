test_that("nds_download_sf loads a 'sf'", {
  file <- nds_download_sf(
    "https://ippuc.org.br/geodownloads/SHAPES_SIRGAS/EIXO_RUA_SIRGAS.zip"
  )
  expect_equal(class(file), c("sf", "data.frame"))
})
