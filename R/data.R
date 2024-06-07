#' NDS-BR participants data
#'
#' A table with information about the drivers which participated in NDS-BR
#'
#' @format ## `ndsdrivers`
#' A tibble with 32 rows and 10 columns:
#' \describe{
#'   \item{DRIVER}{Driver alphabetic code}
#'   \item{SEX}{Driver sex}
#'   \item{AGE}{Age of the driver during the data collection}
#'   \item{DAYS}{Duration of the driver participation in days}
#'   \item{APP_DRIVER}{Boolean indicating if the driver participated as a app driver}
#'   \item{LICENSE_AGE}{Year in which the driver obtained its driver's license}
#'   \item{BRAND}{Brand of the driver's vehicle}
#'   \item{MODEL}{Model of the driver's vehicle}
#'   \item{MODEL_YEAR}{Model year of the driver's vehicle}
#'   \item{HP}{Horsepower of the driver's vehicle}
#' }

"ndsdrivers"

#' Road Data for Curitiba
#'
#' A dataset containing road information for Curitiba, Brazil.
#'
#' @format A data frame and `sf` object with 40,355 observations and 22 variables:
#' \describe{
#'   \item{CHAVE}{chr. The unique key identifier for each road segment.}
#'   \item{CODVIA}{chr. The code of the road.}
#'   \item{NOINICIO}{chr. The starting number of the road segment.}
#'   \item{NOFIM}{chr. The ending number of the road segment.}
#'   \item{STATUS}{chr. The status of the road segment (e.g., "OFICIAL").}
#'   \item{NMVIA}{chr. The name of the road.}
#'   \item{NMVIA_ANT}{chr. The former name of the road, if any.}
#'   \item{SVIARIO}{chr. The classification of the road.}
#'   \item{SVIARIOLEG}{chr. The legal reference for the road classification.}
#'   \item{HIERARQUIA}{chr. The hierarchy level of the road.}
#'   \item{STATUS_DEM}{chr. The official status of the road.}
#'   \item{COD_BAIRRO}{num. The code of the neighborhood}
#'   \item{BAIRRO_E}{chr. The name of the neighborhood on the left side of the road.}
#'   \item{BAIRRO_D}{chr. The name of the neighborhood on the right side of the road.}
#'   \item{COD_REG}{num. The code of the region.}
#'   \item{REGIONAL_E}{chr. The name of the regional administration on the left side of the road.}
#'   \item{REGIONAL_D}{chr. The name of the regional administration on the right side of the road.}
#'   \item{CEP_E}{chr. The postal code on the left side of the road.}
#'   \item{CEP_D}{chr. The postal code on the right side of the road.}
#'   \item{CEP_INFO}{chr. Information about the postal code.}
#'   \item{CEP_FONTE}{chr. The source of the postal code information.}
#'   \item{geometry}{sfc_MULTILINESTRING. The spatial geometry of the road segment.}
#' }
#' @source Provided by the municipal authorities of Curitiba (IPPUC).

"ippuc_road_axis"

#' Example NDS-BR Spatial Dataset
#'
#' A dataset containing trip information of the NDS-BR research project
#'
#' @format A data frame and `sf` object with 18,012 observations and 33 variables:
#' \describe{
#'   \item{DRIVER}{chr. The identifier for the driver.}
#'   \item{DAY}{chr. The date of the trip.}
#'   \item{DAY_CORRIGIDO}{chr. The corrected date of the trip.}
#'   \item{03:00:00}{chr. The timestamp}
#'   \item{TRIP}{dbl. The trip number.}
#'   \item{ID}{chr. The trip identifier.}
#'   \item{PR}{chr. The timestamp in GMT-3 timezone}
#'   \item{H}{dbl. The hour component of the timestamp.}
#'   \item{M}{dbl. The minute component of the timestamp.}
#'   \item{S}{dbl. The second component of the timestamp.}
#'   \item{TIME_ACUM}{dbl. The accumulated time of the trip in seconds.}
#'   \item{SPD_MPH}{dbl. The speed in miles per hour.}
#'   \item{SPD_KMH}{dbl. The speed in kilometers per hour.}
#'   \item{ACEL_MS2}{dbl. The acceleration in meters per second squared.}
#'   \item{HEADING}{dbl. The heading or direction of travel.}
#'   \item{ALTITUDE_FT}{dbl. The altitude in feet.}
#'   \item{VALID_TIME}{chr. Indicates whether the part of the trip is valid ("Yes" or "No").}
#'   \item{TIMESTAMP_GPS}{chr. Indicates whether the GPS timestamp is valid ("No").}
#'   \item{CPOOL}{chr. Indicates whether the trip is carpooling ("Not carpooling").}
#'   \item{CPOOLING_CHECKED}{chr. Indicates whether carpooling was checked ("Not carpooling").}
#'   \item{WSB}{chr. Indicates whether the driver was using seatbelt ("Yes").}
#'   \item{UMP_YN}{chr. Indicates whether the driver was using cellphone ("No").}
#'   \item{UMP}{chr. Indicates whether the driver was using cellphone ("0").}
#'   \item{PICK_UP}{chr. Indicates the pick-up cellphone quantity ("0").}
#'   \item{ACTION}{chr. Indicates the action taken during the usage of cellphone (NA).}
#'   \item{GPS_FILE}{chr. The GPS file identifier (NA).}
#'   \item{CIDADE}{chr. The city name ("Curitiba").}
#'   \item{BAIRRO}{chr. The neighborhood name ("JARDIM DAS AMÉRICAS").}
#'   \item{NOME_RUA}{chr. The street name ("NPI").}
#'   \item{HIERARQUIA_CWB}{chr. The road hierarchy according to the city of Curitiba ("NPI").}
#'   \item{HIERARQUIA_CTB}{chr. The road hierarchy according to the Brazilian Traffic Code ("NPI").}
#'   \item{LIMITE_VEL}{chr. The speed limit ("NPI").}
#'   \item{geometry}{POINT. The spatial geometry of the trip location.}
#' }
#' @source NDS-BR researchers.

"ndsbr_data_sf"

#' OSM Road Network Data for Curitiba
#'
#' A dataset containing OpenStreetMap (OSM) road network data for Curitiba, Brazil.
#'
#' @format A data frame and `sf` object with 27,150 observations and 4 variables:
#' \describe{
#'   \item{osm_id}{chr. The unique identifier for each road segment in OSM.}
#'   \item{highway}{chr. The type of road (e.g., trunk, primary, residential).}
#'   \item{maxspeed}{chr. The maximum speed limit for the road segment, in km/h.}
#'   \item{geometry}{sfc_LINESTRING. The spatial geometry of the road segment.}
#' }
#' @source OpenStreetMap contributors.

"osm_data"

#' Neighborhood Boundaries Data for Curitiba
#'
#' A dataset containing the neighborhood boundaries for Curitiba, Brazil.
#'
#' @format A data frame and `sf` object with 75 observations and 10 variables:
#' \describe{
#'   \item{OBJECTID}{num. The unique identifier for each neighborhood boundary object.}
#'   \item{CODIGO}{num. The code representing the neighborhood.}
#'   \item{TIPO}{chr. The type of boundary, here it is "DIVISA DE BAIRROS".}
#'   \item{NOME}{chr. The name of the neighborhood.}
#'   \item{FONTE}{chr. The source of the boundary information, usually a municipal decree.}
#'   \item{CD_REGIONA}{num. The code representing the region to which the neighborhood belongs.}
#'   \item{NM_REGIONA}{chr. The name of the region to which the neighborhood belongs.}
#'   \item{SHAPE_AREA}{num. The area of the neighborhood in square meters.}
#'   \item{SHAPE_LEN}{num. The perimeter length of the neighborhood in meters.}
#'   \item{geometry}{sfc_POLYGON. The spatial geometry of the neighborhood boundary.}
#' }
#' @source Curitiba Municipal Government (IPPUC).

"ippuc_neigh"
