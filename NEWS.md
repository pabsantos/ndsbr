# ndsbr 0.3.1

# ndsbr 0.3.0

New features added: 

## nds_join functions

- `nds_join_roadaxis()`
- `nds_join_neigh()`
- `nds_join_spdlimit()`

## nds_download new function

- `nds_download_cwb_osm()`

## Example datasets

- `ndsbr_data_sf`
- `ippuc_road_axis`
- `ippuc_neigh`
- `osm_data`

# ndsbr 0.2.0

* Added a new set data related to participants characteristics: `ndsdrivers`

# ndsbr 0.1.5

* Fixed an error in `nds_calc_speeding` documentation.

# ndsbr 0.1.4

* Fixed a bug in `nds_create_points` and `nds_calc_time`: it was not considering the correct amount of valid data.

# ndsbr 0.1.3

* Created a new function `nds_split_data`: now it is possible to split the naturalistic data into the original separation of the sample. 

# ndsbr 0.1.2

* Fixed a bug in `nds_create_lines`: it was not considering the correct amount of valid points. 

# ndsbr 0.1.1

* Added a `NEWS.md` file to track changes to the package.
* Added new feature to `nds_load_data`: now it can read `.csv` files with "." separator.
