% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nds_join.R
\name{nds_join_neigh}
\alias{nds_join_neigh}
\title{Join NDS data with neighborhood data}
\usage{
nds_join_neigh(ndsbr_data, neigh_data, vars = "NOME")
}
\arguments{
\item{ndsbr_data}{An \code{sf} object representing NDS data. This object should
have a \code{POINT} geometry type.}

\item{neigh_data}{An \code{sf} object representing neighborhood data. This object
should have a \code{POLYGON} geometry type.}

\item{vars}{A character vector of variables to join from the neighborhood
data. Default is \code{"NOME"}.}
}
\value{
An \code{sf} object with the joined data, including neighborhood
information.
}
\description{
This function joins NDS data with neighborhood data, ensuring the correct
spatial reference and geometry types.
}
\examples{
result <- nds_join_neigh(ndsbr_data_sf, ippuc_neigh)
}
