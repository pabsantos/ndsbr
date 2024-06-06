# nds_join_axis() ----

test_that(
  "nds_join_axis() throws missing errors", {
    expect_error(
      nds_join_axis(road_axis = ippuc_road_axis),
      "'ndsbr_data' is missing"
    )
    expect_error(
      nds_join_axis(ndsbr_data_sf),
      "'road_axis' is missing"
    )
  }
)

test_that(
  "nds_join_axis() throws invalid class errors", {
    expect_error(
      nds_join_axis(ndsbr_data = "xyz", ippuc_road_axis),
      "'ndsbr_data' is not a 'sf' object"
    )
    expect_error(
      nds_join_axis(ndsbr_data_sf, road_axis = "xyz"),
      "'road_axis' is not a 'sf' object"
    )
    expect_error(
      nds_join_axis(ndsbr_data_sf, ippuc_road_axis, c(1, 2, 3)),
      "'axis_vars' is not a 'character' object"
    )
  }
)

test_that(
  "nds_join_axis() returns invalid 'geometry' errors", {
    expect_error(
      nds_join_axis(ndsbr_data = ippuc_road_axis, road_axis = ippuc_road_axis),
      "Invalid 'ndsbr_data' geometry type"
    )
    expect_error(
      nds_join_axis(ndsbr_data_sf, road_axis = ndsbr_data_sf),
      "Invalid 'road_axis' geometry type"
    )
  }
)

test_that(
  "nds_join_axis() returns a valid 'sf' object", {
    expect_true("sf" %in% class(nds_join_axis(ndsbr_data_sf, ippuc_road_axis)))
  }
)

# nds_join_neigh() --------------------------------------------------------

test_that(
  "nds_join_neigh() throws missing errors", {
    expect_error(
      nds_join_neigh(neigh_data = ippuc_neigh),
      "'ndsbr_data' is missing"
    )
    expect_error(
      nds_join_neigh(ndsbr_data_sf),
      "'neigh_data' is missing"
    )
  }
)

test_that(
  "nds_join_neigh() throws invalid class errors", {
    expect_error(
      nds_join_neigh(ndsbr_data = "xyz", ippuc_neigh),
      "'ndsbr_data' is not a 'sf' object"
    )
    expect_error(
      nds_join_neigh(ndsbr_data_sf, neigh_data = "xyz"),
      "'neigh_data' is not a 'sf' object"
    )
    expect_error(
      nds_join_neigh(ndsbr_data_sf, ippuc_neigh, c(1, 2, 3)),
      "'vars' is not a 'character' object"
    )
  }
)

test_that(
  "nds_join_neigh() returns invalid 'geometry' errors", {
    expect_error(
      nds_join_neigh(ndsbr_data = ippuc_road_axis, neigh_data = ippuc_neigh),
      "Invalid 'ndsbr_data' geometry type"
    )
    expect_error(
      nds_join_neigh(ndsbr_data_sf, neigh_data = ndsbr_data_sf),
      "Invalid 'neigh_data' geometry type"
    )
  }
)

test_that(
  "nds_join_neigh() returns a valid 'sf' object", {
    expect_true("sf" %in% class(nds_join_neigh(ndsbr_data_sf, ippuc_neigh)))
  }
)
