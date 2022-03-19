#' \code{ndsbr}: Load, Analyze and Manipulate Data From The Brazilian
#' Naturalistic Driving Study
#'
#' The \code{ndsbr} package provides two main categories of functions:
#' \code{nds_create} and \code{nds_calc}, in addition to other utility
#' functions.
#'
#' @section \code{nds_create} functions:
#' The \code{nds_create} functions are used to create spatial objects in
#' \code{sf} format, using the naturalistic data as input. These functions are:
#' * \link{nds_create_points}
#' * \link{nds_create_lines}
#'
#' @md
#'
#' @section \code{nds_calc} functions:
#' The \code{nds_calc} functions can be used to extract basic information of the
#' naturalistic sample (traveled time or traveled distance) and safety-related
#' variables, such as speeding. These functions are:
#' * \code{nds_calc_dist}
#' * \link{nds_calc_time}
#' * \code{nds_calc_speeding}
#'
#'
#' @section Other functions:
#' * \link{nds_load_data}: Load naturalistic data.
#' * \link{nds_download_sf}: Download and load spatial data.
#'
#' @docType package
#' @name ndsbr
NULL
#> NULL
