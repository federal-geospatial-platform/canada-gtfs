#### PROCESS GENERAL TRANSIT FEED SPECIFICATION (GTFS) DATA ####

# Read in data manipulation libraries
library(readxl)
library(tidyr)
library(plyr)
library(dplyr)
library(fst)

# Read in geospatial libraries
library(sf)
library(sp)

# Read in English point and line GTFS data
points_en <-
  read_fst("./data/gtfs_canada_points.fst", from = 2) %>% as.data.frame() 
lines_en <-
  read_fst("./data/gtfs_canada_lines.fst", from = 2) %>% as.data.frame() 

# Format French point and line GTFS data
points_fr <- points_en %>%
  rename(ville = city,
         nom_arret = stop_name,
         id_arret = stop_id,
         lat_arret = stop_lat,
         lon_arret = stop_lon,
         date_fin = end_date,
         service_semaine = weekday_service,
         service_weekend = weekend_service,
         lignes_desservies = routes_serviced,
         types_lignes_desserives = route_types_serviced,
         embarq_fauteuil_rouland = wheelchair_boarding) %>%
  mutate(types_lignes_desserives = mapvalues(
    types_lignes_desserives,
    c("Light rail", "Bus, Communal taxi service",
      "Communal taxi service", "Demand and response bus service",
      "Subway", "Bus, Light rail"),
    c("Métro léger", "Bus, Service de taxi communal",
      "Service de taxi communal", "Bus à la demande et à la réponse",
      "Métro", "Bus, Métro léger")))
lines_fr <- lines_en %>%
  rename(ville = city,
         lignes_desservies = routes_serviced,
         types_lignes_desserives = route_types_serviced,
         id_forme = shape_id,
         lat_pt_forme = shape_pt_lat,
         lon_pt_forme = shape_pt_lon,
         sequence_pt_forme = shape_pt_sequence,
         date_fin = end_date,
         service_semaine = weekday_service,
         service_weekend = weekend_service,
         lignes_desservies = routes_serviced,
         coleur_ligne = route_color,
         coleur_text_ligne = route_text_color,
         types_lignes_desserives = route_types_serviced,
         access_fauteuil_rouland = wheelchair_accessible,
         velos_autorises = bikes_allowed) %>%
  mutate(types_lignes_desserives = mapvalues(
    types_lignes_desserives,
    c("Light rail",  "Communal taxi service",
      "Demand and response bus service", "Subway"),
    c("Métro léger",  "Service de taxi communal",
      "Bus à la demande et à la réponse", "Métro")))

# Convert points data to geometry
coordinates(points_en) = ~stop_lon + stop_lat
proj4string(points_en) <- CRS("+proj=longlat +datum=NAD83")
points_en <- points_en %>% st_as_sf() %>% st_transform(3978)
coordinates(points_fr) = ~lon_arret + lat_arret
proj4string(points_fr) <- CRS("+proj=longlat +datum=NAD83")
points_fr <- points_fr %>% st_as_sf() %>% st_transform(3978)

# Convert lines data to geometry
coordinates(lines_en) = ~shape_pt_lon + shape_pt_lat
proj4string(lines_en) <- CRS("+proj=longlat +datum=NAD83")
lines_en <- lines_en %>% st_as_sf() %>% st_transform(3978)
coordinates(lines_fr) = ~lon_pt_forme + lat_pt_forme
proj4string(lines_fr) <- CRS("+proj=longlat +datum=NAD83")
lines_fr <- lines_fr %>% st_as_sf() %>% st_transform(3978)

# Select features for line data
features_en <- lines_en %>%
  as.data.frame() %>%
  group_by(shape_id) %>%
  summarise_at(colnames(lines_en)[! colnames(lines_en) %in% c(
    "shape_id", "shape_pt_sequence", "geometry")], first)
features_fr <- lines_fr %>%
  as.data.frame() %>%
  group_by(id_forme) %>%
  summarise_at(colnames(lines_fr)[! colnames(lines_fr) %in% c(
    "id_forme", "sequence_pt_forme", "geometry")], first)

# Connect points in lines data
lines_connected_en <- lines_en %>%
  group_by(shape_id) %>%
  arrange(shape_pt_sequence) %>%
  summarize(do_union = FALSE) %>%
  st_cast("LINESTRING") %>% 
  merge(features_en, by = "shape_id", all.x = TRUE)
lines_connected_fr <- lines_fr %>%
  group_by(id_forme) %>%
  arrange(sequence_pt_forme) %>%
  summarize(do_union = FALSE) %>%
  st_cast("LINESTRING") %>% 
  merge(features_fr, by = "id_forme", all.x = TRUE)

# Export GTFS data as shapefiles
st_write(points_en, "./shapefiles/gtfs_points_en.shp", layer_options = "ENCODING=UTF-8")
st_write(points_fr, "./shapefiles/gtfs_points_fr.shp", layer_options = "ENCODING=UTF-8")
st_write(lines_connected_en, "./shapefiles/gtfs_lines_en.shp", layer_options = "ENCODING=UTF-8")
st_write(lines_connected_fr, "./shapefiles/gtfs_lines_fr.shp", layer_options = "ENCODING=UTF-8")

# Export GTFS data
# write.csv(points_en, "points_en.csv", fileEncoding = "UTF-8", row.names = F)
# write.csv(lines_en, "lines_en.csv", fileEncoding = "UTF-8", row.names = F)
# write.csv(points_fr, "points_fr.csv", fileEncoding = "UTF-8", row.names = F)
# write.csv(lines_fr, "lines_fr.csv", fileEncoding = "UTF-8", row.names = F)

# # Read GTFS data
# points_en <- read.csv("points_en.csv", encoding = "UTF-8")
# points_fr <- read.csv("points_fr.csv", encoding = "UTF-8")
# lines_en <- read.csv("lines_en.csv", encoding = "UTF-8")
# lines_fr <- read.csv("lines_fr.csv", encoding = "UTF-8")