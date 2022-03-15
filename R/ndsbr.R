#' \code{ndsbr}: Load, Analyze and Manipulate Data From The Brazilian
#' Naturalistic Driving Study
#'
#' The \code{ndsbr} package provides two main categories of functions:
#' \code{create} and \code{calc}, in addition to other utility functions.
#'
#' @section \code{create} functions:
#' The \code{create} functions are used to create spatial objects in \code{sf}
#' format, using the naturalistic data as input. These functions are:
#' * \code{nds_create_points()}
#' * \code{nds_create_lines()}
#'
#' @md
#'
#' @section \code{calc} functions:
#' The \code{calc} functions can be used to extract basic information of the
#' naturalistic sample (travel time or travel distance) and safety-related
#' variables, such as speeding and use of mobile phone (UMP). These functions
#' are:
#' * \code{nds_calc_dist()}
#' * \code{nds_calc_time()}
#' * \code{nds_calc_speeding()}
#' * \code{nds_calc_ump()}
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
