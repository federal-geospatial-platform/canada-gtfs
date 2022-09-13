# Canadian Public Transit Systems

![image](https://user-images.githubusercontent.com/57367002/189784868-1ccaf6f4-c24b-4c76-b7bb-0f86fdcf9f56.png)

### What is this project?

Code for generating geospatial data of public transit agencies in Canada, with information on stop locations, route locations, route types, level of service, wheelchair access, bike access, and more. Used to generate the [Canadian Public Transit Systems dataset](https://open.canada.ca/data/en/dataset/b8241e15-2872-4a63-9d36-3083d03e8474) hosted on the Federal Geospatial Platform. Final shapefiles are also provided in the repository.

Users can use the script to directly download GTFS data from public transit agencies in all of Canada in a workable geospatial format or modify the script for custom purposes.

| Field                 | Description                                                                                                                                                           |
|-----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| id                    | Unique code for the transit system                                                                                                                                                       |
| system                | The transit system that reported the data                                                                                                                                                      |
| city                  | The municipality or region in which the transit system is primarily located                                                                                                                  |
| province              | The province in which the transit system is primarily located                                                                                                                                  |
| stop_id               | A unique identifier for each stop in the transit system                                                                                                                                        |
| shape_id              | A unique identifier for each vehicle path in the transit system                                                                                                                                |
| stop_name             | The name of the stop given by the transit system                                                                                                                                               |
| stop_lat              | The latitude coordinate of the stop                                                                                                                                                            |
| stop_lon              | The longitude coordinate of the stop                                                                                                                                                           |
| shape_pt_lat          | The latitude coordinate of the vehicle path (must be connected for each shape_id)                                                                                                            |
| shape_pt_lon          | The longitude coordinate of the vehicle path (must be connected for each shape_id)                                                                                                           |
| shape_pt_sequence     | The order in which shape_pt_lat and shape_pt_lon should be connected                                                                                                                           |
| end_date              | The latest date given by the transit system for which the data is accurate                                                                                                                   |
| weekday_service       | The number of trips connected to the stop or vehicle path during the week                                                                                                                      |
| weekend_service       | The number of trips connected to the stop or vehicle path during the weekend                                                                                                                 |
| route_color           | The official colour of the route associated with the vehicle path                                                                                                                              |
| route_text_color      | The official text colour of the route associated with the vehicle path                                                                                                                         |
| routes_serviced       | The names of the routes connected to the stop or vehicle path                                                                                                                                  |
| route_types_serviced  | The types of vehicles connected to the stop or vehicle path                                                                                                                                    |
| wheelchair_boarding   | 0 or empty = stop has no accessibility information; 1 = some vehicles at or paths to the stop are wheelchair accessible; 2 = no vehicles at or paths   to the stop are wheelchair accessible |
| wheelchair_accessible | 0 or empty = no accessibility information for the trip; 1 = vehicle being used for the trip can accommodate at least one wheelchair; 2 = no wheelchairs   can be accommodated on the trip    |
| bikes_allowed         | 0 or empty = no bike information for the trip; 1 = vehicle being used for the trip can accommodate at least one bicycle; 2 = no bicycles are allowed on the trip                           |

### How do I generate the data?

Pull the repository to create local copies of the files. Run <code>1-process_gtfs.R</code> to increase local memory, load in the links to the GTFS data, and create the functions to download the data. Then run <code>download.gtfs.canada()</code> to loop through the links to the GTFS data and process the relevant information. This will produce a <code>.fst</code> file, which is a quick-to-download data storage file. <code>1-process_gtfs.R</code> also contains a function <code>map.gtfs.system</code> to map the GTFS systems using the transit system names provided in the <code>gtfs_sources.xlsx</code> file. To produce shapefiles, run the <code>2-export_gtfs.R</code> file. Due to the size of the data, both files take approximately thirty minutes each to run.

To access the data without running the code, use the <code>.fst</code> files (non-spatial data for quick loading) or the <code>.shp</code> files (shapefiles for geospatial analysis). Note that this method may not provide the most up-to-date information from the transit systems.


# Systèmes de transport en commun canadiens

![image](https://user-images.githubusercontent.com/57367002/189784929-ca30b980-2a97-4068-b3d6-9bc77088236f.png)

### What is this project?

Code for generating geospatial data of public transit agencies in Canada, with information on stop locations, route locations, route types, level of service, wheelchair access, bike access, and more. Used to generate the [Canadian Public Transit Systems dataset](https://open.canada.ca/data/en/dataset/b8241e15-2872-4a63-9d36-3083d03e8474) hosted on the Federal Geospatial Platform. Final shapefiles are also provided in the repository.

Users can use the script to directly download GTFS data from public transit agencies in all of Canada in a workable geospatial format or modify the script for custom purposes.

| Field                 | Description                                                                                                                                                           |
|-----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| id                    | Unique code for the transit system                                                                                                                                                       |
| system                | The transit system that reported the data                                                                                                                                                      |
| city                  | The municipality or region in which the transit system is primarily located                                                                                                                  |
| province              | The province in which the transit system is primarily located                                                                                                                                  |
| stop_id               | A unique identifier for each stop in the transit system                                                                                                                                        |
| shape_id              | A unique identifier for each vehicle path in the transit system                                                                                                                                |
| stop_name             | The name of the stop given by the transit system                                                                                                                                               |
| stop_lat              | The latitude coordinate of the stop                                                                                                                                                            |
| stop_lon              | The longitude coordinate of the stop                                                                                                                                                           |
| shape_pt_lat          | The latitude coordinate of the vehicle path (must be connected for each shape_id)                                                                                                            |
| shape_pt_lon          | The longitude coordinate of the vehicle path (must be connected for each shape_id)                                                                                                           |
| shape_pt_sequence     | The order in which shape_pt_lat and shape_pt_lon should be connected                                                                                                                           |
| end_date              | The latest date given by the transit system for which the data is accurate                                                                                                                   |
| weekday_service       | The number of trips connected to the stop or vehicle path during the week                                                                                                                      |
| weekend_service       | The number of trips connected to the stop or vehicle path during the weekend                                                                                                                 |
| route_color           | The official colour of the route associated with the vehicle path                                                                                                                              |
| route_text_color      | The official text colour of the route associated with the vehicle path                                                                                                                         |
| routes_serviced       | The names of the routes connected to the stop or vehicle path                                                                                                                                  |
| route_types_serviced  | The types of vehicles connected to the stop or vehicle path                                                                                                                                    |
| wheelchair_boarding   | 0 or empty = stop has no accessibility information; 1 = some vehicles at or paths to the stop are wheelchair accessible; 2 = no vehicles at or paths   to the stop are wheelchair accessible |
| wheelchair_accessible | 0 or empty = no accessibility information for the trip; 1 = vehicle being used for the trip can accommodate at least one wheelchair; 2 = no wheelchairs   can be accommodated on the trip    |
| bikes_allowed         | 0 or empty = no bike information for the trip; 1 = vehicle being used for the trip can accommodate at least one bicycle; 2 = no bicycles are allowed on the trip                           |


### How do I generate the data?

Pull the repository to create local copies of the files. Run <code>1-process_gtfs.R</code> to increase local memory, load in the links to the GTFS data, and create the functions to download the data. Then run <code>download.gtfs.canada()</code> to loop through the links to the GTFS data and process the relevant information. This will produce a <code>.fst</code> file, which is a quick-to-download data storage file. <code>1-process_gtfs.R</code> also contains a function <code>map.gtfs.system</code> to map the GTFS systems using the transit system names provided in the <code>gtfs_sources.xlsx</code> file. To produce shapefiles, run the <code>2-export_gtfs.R</code> file. Due to the size of the data, both files take approximately thirty minutes each to run.

To access the data without running the code, use the <code>.fst</code> files (non-spatial data for quick loading) or the <code>.shp</code> files (shapefiles for geospatial analysis). Note that this method may not provide the most up-to-date information from the transit systems.
