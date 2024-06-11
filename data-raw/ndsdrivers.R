ndsdrivers <- read.csv2("data-raw/ndsdrivers.csv")
ndsdrivers <- janitor::clean_names(ndsdrivers)

driver_list <- strsplit(ndsdrivers$driver, split = "_")

drivers <- vector(length = length(driver_list))

for (i in 1:length(driver_list)) {
  drivers[i] <- driver_list[[i]][2]
}

ndsdrivers$driver <- drivers

ndsdrivers$app_driver <- ifelse(
  ndsdrivers$categoria == "Habitual", FALSE, TRUE
)

ndsdrivers$license_date <- lubridate::dmy(ndsdrivers$x1a_habilitacao)

vehicles <- strsplit(ndsdrivers$marca_modelo, split = "/")

for (i in 1:length(vehicles)) {
  ndsdrivers$brand[i] <- vehicles[[i]][1]
  ndsdrivers$model[i] <- vehicles[[i]][2]
}

ndsdrivers$hp_vehicle <- sub(".*?/(\\d+).*", "\\1", ndsdrivers$cap_pot_cil)

ndsdrivers$transmission <- ifelse(
  ndsdrivers$cambio == "Manual",
  "manual",
  ifelse(
    ndsdrivers$cambio == "Automático",
    "auto",
    NA
  )
)

ndsdrivers <- subset(ndsdrivers, select = c(
  driver, sexo, idade, categoria_cnh, ano_modelo, app_driver,
  license_date, brand, model, hp_vehicle, transmission
))

colnames(ndsdrivers) <- c(
  "driver_id", "sex", "age", "license_type",
  "vehicle_age", "app_driver", "license_date", "vehicle_brand",
  "vehicle_model", "vehicle_hp", "vehicle_transmission"
)

usethis::use_data(ndsdrivers, overwrite = TRUE)
