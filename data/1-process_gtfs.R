#### PROCESS GENERAL TRANSIT FEED SPECIFICATION (GTFS) DATA ####

# Read in data manipulation libraries
library(readxl)
library(tidyr)
library(plyr)
library(dplyr)
library(data.table)
library(stringr)
library(fst)

# Read in geospatial libraries
library(raster)

# Increase memory limit
memory.limit(24000)

# Read in GTFS data links
data_gtfs_links <- read_excel("gtfs_sources.xlsx")

# Create function to read in GTFS data
download.gtfs.canada <- function(){
  # Initiate empty data frames
  data_gtfs_all_points <- data.frame()
  data_gtfs_all_lines <- data.frame()
  # Loop through all systems on record
  for(i in seq(1, nrow(data_gtfs_links))){
    # Print message to indicate download is beginning
    print(paste0("[", i , "/", nrow(data_gtfs_links), "] ",
                 "Downloading GTFS data for ", data_gtfs_links[i,]$system, ":"))
    # Process files that are not stored locally
    if(is.na(data_gtfs_links[i,]$local) | !is.na(data_gtfs_links[i,]$zipped)){
      # Create temporary file location
      loc <- tempfile()
      # Download GTFS zip folder for transit system
      try(download.file(data_gtfs_links[i,]$url, loc, mode = "wb"))
      # Process files that have two layers of zip folder
      if(!is.na(data_gtfs_links[i,]$zipped)) {
        # Store second zip folder locally
        unzip(loc, data_gtfs_links[i,]$zipped, exdir = "./data")
        # Rename second zip folder
        file.rename(
          paste0("./data/", data_gtfs_links[i,]$zipped),
          paste0("./data/", data_gtfs_links[i,]$local, ".zip"))
        # Update local file path
        loc <- paste0("./data/", data_gtfs_links[i,]$local, ".zip")
      }
      # Process files that are stored locally
    } else {
      # Identify local file path
      loc <- paste0("./data/", data_gtfs_links[i,]$local, ".zip")
    }
    # Identify file path of GTFS data
    file <- ifelse(!is.na(data_gtfs_links[i,]$subfolder),
                   paste0(data_gtfs_links[i,]$subfolder, "/"), "")
    # Format calendar data
    suppressWarnings(try(calendar <- read.csv(unz(
      loc, paste0(file, "calendar.txt")), check.names = F, encoding = "UTF-8",
      colClasses = c("character"), sep = ",", header = T) %>%
        # Rename ID column
        rename_if(endsWith(names(.), "service_id"), ~"service_id") %>%
        # Edit columns
        mutate(
          # Format end date
          end_date = as.Date(as.character(max(end_date)), "%Y%m%d"),
          # Add column to indicate weekday service
          weekday_service = str_count(
            paste0(monday, tuesday, wednesday, thursday, friday), "1"),
          # Add column to indicate weekend service
          weekend_service = str_count(paste0(saturday, sunday), "1")) %>%
        # Select columns of interest
        dplyr::select(any_of(
          c("service_id", "end_date", "weekday_service", "weekend_service"))),
      # Suppress error message when data doesn't exist
      silent = T
      ))
    # Format route data
    suppressWarnings(try(routes <- read.csv(unz(
      loc, paste0(file, "routes.txt")), check.names = F, encoding = "UTF-8",
      colClasses = c("character"), sep = ",", header = T) %>%
        # Rename ID column
        rename_if(endsWith(names(.), "route_id"), ~"route_id") %>%
        # Edit columns
        mutate(
          # Map route types from codes to words
          route_type = mapvalues(route_type, warn_missing = F,
            c("0", "1", "2", "3", "4", "5", "6", "7", "11", "12", "700",
              "1501", "715"),
            c("Light rail", "Subway", "Rail", "Bus" , "Ferry", "Cable tram",
              "Aerial lift", "Funicular", "Trolleybus", "Monorail", "Bus",
              "Communal taxi service", "Demand and response bus service"))) %>%
        # Select columns of interest
        dplyr::select(any_of(
          c("route_id", "route_long_name", "route_type",
            "route_color", "route_text_color"))),
      # Suppress error message when data doesn't exist
      silent = T
      ))
    # Format trip data
    suppressWarnings(try(trips <- read.csv(unz(
      loc, paste0(file, "trips.txt")), check.names = F, encoding = "UTF-8",
      colClasses = c("character"), sep = ",", header = T) %>%
        # Rename ID column
        rename_if(endsWith(names(.), "route_id"), ~"route_id") %>%
        # Select columns of interest
        dplyr::select(any_of(
          c("route_id", "service_id", "trip_id", "shape_id",
            "wheelchair_accessible", "bikes_allowed"))) %>%
        # Check if calendar data exists
        {if("calendar.txt" %in% unzip(loc, list = TRUE)$Name)
          {if(nrow(read.csv(unz(loc, paste0(file, "calendar.txt")))) != 0)
            merge(., calendar, on = service_id, all.x = T)
          else .}
          else .} %>%
        # Merge route data
        merge(routes, on = route_id, all.x = T),
      # Suppress error message when data doesn't exist
      silent = T
      ))
    # Format stop time data
    suppressWarnings(try(stop_times <- read.csv(unz(
      loc, paste0(file, "stop_times.txt")), check.names = F, encoding = "UTF-8",
      colClasses = c("character"), sep = ",", header = T) %>%
        # Rename ID column
        rename_if(endsWith(names(.), "trip_id"), ~"trip_id") %>%
      # Select columns of interest
      dplyr::select(any_of(
        c("trip_id", "stop_id"))),
      # Suppress error message when data doesn't exist
      silent = T
      ))
    # Format shape data
    suppressWarnings(try(shapes <- read.csv(unz(
      loc, paste0(file, "shapes.txt")), check.names = F, encoding = "UTF-8",
      colClasses = c("character"), sep = ",", header = T) %>%
        # Rename ID column
        rename_if(endsWith(names(.), "shape_id"), ~"shape_id") %>%
        # Select distinct rows corresponding to each shape
        distinct(shape_id, .keep_all = T) %>%
        # Merge trip data
        merge(trips, all.x = T) %>%
        # Collect entries into shapes
        group_by(shape_id) %>%
        # Edit trip columns if calendar data exists
        {if("calendar.txt" %in% unzip(loc, list = TRUE)$Name)
          {if(nrow(read.csv(unz(loc, paste0(file, "calendar.txt")))) != 0)
            mutate(., 
                   # Add column for number of weekday trips
                   weekday_service = sum(weekday_service, na.rm = T),
                   # Add column for number of weekend trips
                   weekend_service = sum(weekend_service, na.rm = T))
          else  mutate(., 
                       # Add column when no calendar data exists
                       weekday_service = NA,
                       # Add column when no calendar data exists
                       weekend_service = NA)}
          else mutate(., 
                      # Add column when no calendar data exists
                      weekday_service = NA,
                      # Add column when no calendar data exists
                      weekend_service = NA)} %>%
        # Edit remaining columns
        mutate(
          # Convert coordinates and sequences to numeric
          shape_pt_lat = as.numeric(shape_pt_lat),
          shape_pt_lon = as.numeric(shape_pt_lon),
          shape_pt_sequence = as.numeric(shape_pt_sequence),
          # Add column for list of routes serviced
          routes_serviced = paste(unique(
            route_long_name[!is.na(route_long_name)]), collapse = ", "),
          # Add column for list of public transit modalities serviced
          route_types_serviced = paste(sort(unique( 
            route_type[!is.na(route_type)])), collapse = ", ")) %>%
        # Ungroup data
        ungroup() %>%
        # Arrange by route id to put missing route data at the bottom
        arrange(route_id) %>%
        # Select distinct rows corresponding to each stop
        distinct(shape_id, .keep_all = T) %>%
        # Select columns of interest
        dplyr::select(any_of(
          c("shape_id", "end_date", "weekday_service", "weekend_service",
            "route_color", "route_text_color", "routes_serviced",
            "route_types_serviced", "wheelchair_accessible", "bikes_allowed"))),
      # Suppress error message when data doesn't exist
      silent = T
      ))
    # Create a new dataframe for system-level GTFS point data
    suppressWarnings(try(data_gtfs_system_points <- read.csv(
      unz(loc, paste0(file, "stops.txt")), check.names = F, encoding = "UTF-8",
      colClasses = c("character"), sep = ",", header = T) %>%
        # Rename ID column
        rename_if(endsWith(names(.), "stop_id"), ~"stop_id") %>%
        # Check if both parent_station and wheelchair_boarding columns exist
        { if("parent_station" %in% colnames(.)
             & "wheelchair_boarding" %in% colnames(.))
          # Join parent station wheelchair boarding information
          merge(., .[, c("stop_id", "wheelchair_boarding")] %>%
                  rename(parent_wheelchair_boarding = wheelchair_boarding),
                by.x = "parent_station", by.y = "stop_id", all.x = T) %>%
            # Add wheelchair boarding information inherited from parent stations
            mutate(
              wheelchair_boarding = ifelse(
                !is.na(parent_station) & parent_station != ""
                & (is.na(wheelchair_boarding) | wheelchair_boarding == 0),
                parent_wheelchair_boarding, wheelchair_boarding))
          else . } %>%
        # Select columns of interest
        dplyr::select(any_of(
          c("stop_id", "stop_name", "stop_lat", 
            "stop_lon", "wheelchair_boarding"))) %>%
        # Merge stop time data
        merge(stop_times, all.x = T) %>%
        # Merge trip data
        merge(trips, all.x = T) %>%
        # Collect entries into stops
        group_by(stop_id) %>%
        # Edit trip columns if calendar data exists
        {if("calendar.txt" %in% unzip(loc, list = TRUE)$Name)
          {if(nrow(read.csv(unz(loc, paste0(file, "calendar.txt")))) != 0)
            mutate(., 
                   # Add column for number of weekday trips
                   weekday_service = sum(weekday_service, na.rm = T),
                   # Add column for number of weekend trips
                   weekend_service = sum(weekend_service, na.rm = T))
            else mutate(., 
                        # Add column when no calendar data exists
                        weekday_service = NA,
                        # Add column when no calendar data exists
                        weekend_service = NA)}
          else mutate(., 
                      # Add column when no calendar data exists
                      weekday_service = NA,
                      # Add column when no calendar data exists
                      weekend_service = NA)} %>%
        # Edit remaining columns
        mutate(
          # Convert coordinates to numeric
          stop_lat = as.numeric(stop_lat),
          stop_lon = as.numeric(stop_lon),
          # Add column for list of routes serviced
          routes_serviced = paste(unique( 
            route_long_name[!is.na(route_long_name)]), collapse = ", "),
          # Add column for list of public transit modalities serviced
          route_types_serviced = paste(sort(unique( 
            route_type[!is.na(route_type)])), collapse = ", ")) %>%
        # Ungroup data
        ungroup() %>%
        # Arrange by route id to put missing route data at the bottom
        arrange(route_id) %>%
        # Select distinct rows corresponding to each stop
        distinct(stop_id, .keep_all = T) %>%
        # Edit columns to add general information
        mutate(
          # Create column for system id
          id = data_gtfs_links[i,]$id,
          # Create column for system name
          system = data_gtfs_links[i,]$system,
          # Create column for city name
          city = data_gtfs_links[i,]$city,
          # Create column for province
          province = data_gtfs_links[i,]$province) %>%
        # Move identifying information to the front
        relocate(id, system, city, province) %>%
        # Remove unneeded columns
        dplyr::select(!any_of(
          c("trip_id", "route_id", "service_id", "shape_id", "route_long_name", 
            "route_type", "route_color", "route_text_color",
            "wheelchair_accessible", "bikes_allowed", "encoding"))),
      # Suppress error message when data doesn't exist
      silent = T
      ))
    # Create a new dataframe for system-level GTFS line data
    suppressWarnings(try(data_gtfs_system_lines <- read.csv(
      unz(loc, paste0(file, "shapes.txt")), check.names = F, encoding = "UTF-8",
      colClasses = c("character"), sep = ",", header = T) %>%
        # Rename ID column
        rename_if(endsWith(names(.), "shape_id"), ~"shape_id") %>%
        # Select columns of interest
        dplyr::select(!any_of(c("shape_dist_traveled"))) %>%
        # Merge with shape data
        merge(shapes, all.x = T) %>%
        # Edit columns to add general information
        mutate(
          # Convert coordinates and sequences to numeric
          shape_pt_lat = as.numeric(shape_pt_lat),
          shape_pt_lon = as.numeric(shape_pt_lon),
          shape_pt_sequence = as.numeric(shape_pt_sequence),
          # Create column for system id
          id = data_gtfs_links[i,]$id,
          # Create column for system name
          system = data_gtfs_links[i,]$system,
          # Create column for city name
          city = data_gtfs_links[i,]$city,
          # Create column for province
          province = data_gtfs_links[i,]$province) %>%
        # Move identifying information to the front
        relocate(id, system, city, province) %>%
        # Arrange coordinates in proper order
        arrange(shape_id, shape_pt_sequence),
      # Suppress error message when data doesn't exist
      silent = T
      ))
    # Add system-level point information to dataframe
    try(data_gtfs_all_points <- rbind.fill(
      data_gtfs_all_points, data_gtfs_system_points), silent = T)
    # Add system-level line information to dataframe
    try(data_gtfs_all_lines <- rbind.fill(
      data_gtfs_all_lines, data_gtfs_system_lines), silent = T)
  }
  return(data_gtfs_all_points)
  # Create first row to force dataframe to encode as UTF-8
  encoding_points = data.frame(
    id = "→", system = "→", city = "→", province = "→",
    stop_name = "→", routes_serviced = "→")
  # Save point data as FST
  write.fst(
    # Bind row with UTF-8 encoded columns to force encoding to UTF-8
    rbind.fill(
      encoding_points,
      # Perform final edits on point data
      data_gtfs_all_points %>%
        # Edit columns
        mutate(
          # Append system name to stop id
          stop_id = paste(`id`, "-", stop_id)) %>%
        # Convert missing accessibility values to zero
        { if("wheelchair_boarding" %in% colnames(.))
        # Convert missing wheelchair boarding values to zero
        mutate(.,
          wheelchair_boarding = ifelse(
            is.na(wheelchair_boarding) | wheelchair_boarding == "",
            0, wheelchair_boarding))
          else . } %>%
        # Remove duplicated rows
        distinct()), "./data/gtfs_canada_points.fst")
  # Create first row to force dataframe to encode as UTF-8
  encoding_lines = data.frame(
    id = "→", system = "→", city = "→", province = "→",
    routes_serviced = "→", route_types_serviced = "→")
  # Save line data as FST
  write.fst(
    # Bind row with UTF-8 encoded columns to force encoding to UTF-8
    rbind.fill(
      encoding_lines,
      # Perform final edits on line data
      data_gtfs_all_lines %>%
        # Edit columns
        mutate(
          # Append system name to shape id
          shape_id = paste(`id`, "-", shape_id)) %>%
        # Convert missing accessibility values to zero
        { if("wheelchair_boarding" %in% colnames(.))
          # Convert missing wheelchair boarding values to zero
          mutate(.,
                 wheelchair_accessible = ifelse(
                   is.na(wheelchair_accessible) | wheelchair_accessible == "",
                   0, wheelchair_accessible),
                 bikes_allowed = ifelse(
                   is.na(bikes_allowed) | bikes_allowed == "",
                   0, bikes_allowed))
          else . } %>%
        # Remove duplicated rows
        distinct()), "./data/gtfs_canada_lines.fst")
}

# Create function to map GTFS system data
map.gtfs.system <- function(name = NA){
  # Create map if valid system name is entered
  if(name %in% data_gtfs_links$system){
    # Select line data for system
    lines <- read_fst("./data/gtfs_canada_lines.fst", from = 2)[
      read_fst("./data/gtfs_canada_lines.fst", from = 2)$system == name,]
    # Identify coordinates of lines
    xy <- lines %>% dplyr::select(shape_pt_lon, shape_pt_lat)
    # Identify boundary of map based on system location
    bounds <- bbox(SpatialPointsDataFrame(
      coords = xy, data = lines,
      proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")))
    # Create an interactive map
    m <- leaflet(lines, options = leafletOptions(preferCanvas = TRUE)) %>%
      fitBounds(bounds[1], bounds[2], bounds[3], bounds[4]) %>%
      addProviderTiles(providers$CartoDB.Positron) 
    # Identify each unique line, with subway lines last
    ids <- unique((lines %>% arrange(
      route_types_serviced, shape_id, shape_pt_sequence))$shape_id)
    # Go through each line and add it to the interactive map
    for(i in ids) {
      # Add subway lines as thicker lines on top of other lines
      if(lines[lines$shape_id == i,][1,]$route_types_serviced == "Subway"){
        color <- paste0("#", lines[lines$shape_id == i,][1,]$route_color)
        m <- m %>%
          addPolylines(data = lines[lines$shape_id == i,],
                       color = color, weight = 4, opacity = 1, 
                       lng = ~shape_pt_lon, lat = ~shape_pt_lat)
      }
      # Add other lines as thin red lines underneath subway lines
      else{
        m <- m %>%
          addPolylines(data = lines[lines$shape_id == i,],
                       color = "red", weight = 2, opacity = 0.2,
                       lng = ~shape_pt_lon, lat = ~shape_pt_lat)
      }
    }
    # Plot interactive map
    m
  }
}