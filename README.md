# Canadian Public Transit Systems

![image](https://user-images.githubusercontent.com/57367002/189785029-13379427-56d3-4958-bf2a-d776cab35ca5.png)

### What is this project?

Code for generating geospatial data of public transit agencies in Canada, with information on stop locations, route locations, route types, level of service, wheelchair access, bike access, and more. Used to produce the [Canadian Public Transit Systems dataset](https://open.canada.ca/data/en/dataset/b8241e15-2872-4a63-9d36-3083d03e8474) hosted on the Federal Geospatial Platform. Final shapefiles are also provided in the repository.

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

Clone the repository to create local copies of the files. Run <code>1-process_gtfs.R</code> to increase local memory, load in the links to the GTFS data, and create the functions to download the data. Then run <code>download.gtfs.canada()</code> to loop through the links to the GTFS data and process the relevant information. This will produce a <code>.fst</code> file, which is a quick-to-download data storage file. <code>1-process_gtfs.R</code> also contains a function <code>map.gtfs.system()</code> to map the GTFS systems using the transit system names provided in the <code>gtfs_sources.xlsx</code> file. To produce shapefiles, run the <code>2-export_gtfs.R</code> file. Due to the size of the data, both files take approximately thirty minutes each to run.

To access the data without running the code, use the <code>.fst</code> files (non-spatial data for quick loading) or the <code>.shp</code> files (shapefiles for geospatial analysis). Note that this method may not provide the most up-to-date information from the transit systems.


# Systèmes de transport en commun canadiens

![image](https://user-images.githubusercontent.com/57367002/189784929-ca30b980-2a97-4068-b3d6-9bc77088236f.png)

### Quel est ce projet?

Code pour générer les données géospatiales des agences de transport en commun au Canada, avec des informations sur les emplacements des arrêts, les emplacements des lignes, les types des lignes, le niveau de service, l'accès aux fauteuils roulants, l'accès aux vélos, etc. Pour produire le [de données de Systèmes de transport en commun canadiens](https://open.canada.ca/data/fr/dataset/b8241e15-2872-4a63-9d36-3083d03e8474) hébergées sur la Plateforme géospatiale fédérale. Les shapefiles sont également fournis dans le référentiel.

Les utilisateurs peuvent utiliser le script pour télécharger directement les données GTFS des agences de transport en commun de tout le Canada dans un format géospatial fonctionnel ou modifier le script à des fins personnalisées.

| Champ                   | Description                                                                                                                                                                                                                                                   |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| id                      | Code unique pour le système de transport en   commun                                                                                                                                                                                                          |
| system                  | Le système de transport en commun qui a rapporté les données                                                                                                                                                                                                  |
| ville                   | La municipalité/région dans laquelle le système de transport en commun   est principalement situé                                                                                                                                                             |
| province                | La province dans laquelle le système de transport en commun est   principalement situé                                                                                                                                                                        |
| id_arret                | Un identifiant unique pour chaque arrêt du système de transport en commun                                                                                                                                                                                     |
| id_forme                | Un identifiant unique pour chaque trajet de véhicule du système de   transport en commun                                                                                                                                                                      |
| nom_arret               | Le nom de l'arrêt donné par le système de transport en commun                                                                                                                                                                                                 |
| lat_arret               | La coordonnée de latitude de l'arrêt                                                                                                                                                                                                                          |
| lon_arret               | La coordonnée de longitude de l'arrêt                                                                                                                                                                                                                         |
| lat_pt_forme            | Coordonnée de latitude de la trajet de véhicule (doit être joint pour   chaque id_forme)                                                                                                                                                                      |
| lon_pt_forme            | Coordonnée de longitude de la trajet de véhicule (doit être joint pour   chaque id_forme)                                                                                                                                                                     |
| sequence_pt_forme       | L’ordre dans lequel lat_pt_forme and lon_pt_forme faut être joint                                                                                                                                                                                             |
| date_fin                | La dernière date donnée par le système de transit pour laquelle les   données sont exactes                                                                                                                                                                    |
| service_semaine         | Le nombre de trajets reliés à l'arrêt ou au trajet de véhicule au cours   de la semaine                                                                                                                                                                       |
| service_weekend         | Le nombre de trajets reliés à l'arrêt ou au trajet de véhicule au cours   de la semaine                                                                                                                                                                       |
| coleur_ligne            | La couleur officielle du ligne associée au trajet de véhicule                                                                                                                                                                                                 |
| coleur_text_ligne       | La couleur officielle du texte du ligne associée au trajet de véhicule                                                                                                                                                                                        |
| lignes_desservies       | Les noms des lignes connectés à l'arrêt ou au trajet de véhicule                                                                                                                                                                                              |
| types_lignes_desserives | Les types de véhicules connectés à l'arrêt ou à la trajectoire des   véhicules                                                                                                                                                                                |
| embarq_fauteuil_rouland | 0 ou vide = l'arrêt n’a pas d’information d'accessibilité; 1 = certains   véhicules à l'arrêt ou chemins d'accès sont accessibles aux fauteuils   roulants; 2 = aucun véhicule à l'arrêt ou chemin menant à l'arrêt n'est   accessible aux fauteuils roulants |
| access_fauteuil_rouland | 0 ou vide = aucune information d'accessibilité pour le voyage; 1 = le   véhicule utilisé pour le voyage peut accueillir au moins un fauteuil roulant;   2 = aucun fauteuil roulant ne peut être accepté pendant le voyage                                     |
| velos_autorises         | 0 ou vide = aucune information des vélos pour le voyage; 1 = le véhicule   utilisé pour le voyage peut accueillir au moins un vélo; 2 = aucun vélo ne   peut être accepté pendant le voyage                                                                   |


### Comment puis-je générer les données ?

Cloner le référentiel pour créer des copies locales des fichiers. Exécutez <code>1-process_gtfs.R</code> pour augmenter la mémoire locale, charger les liens vers les données GTFS et créer les fonctions pour télécharger les données. Ensuite, exécutez <code>download.gtfs.canada()</code> pour parcourir les liens vers les données GTFS et traiter les informations pertinentes. Cela produira un fichier <code>.fst</code>, qui est un fichier de stockage de données rapide à télécharger. <code>1-process_gtfs.R</code> contient également une fonction <code>map.gtfs.system()</code> pour mapper les systèmes GTFS à l'aide des noms de système de transit fournis dans le <code>gtfs_sources.xlsx</code > dossier. Pour produire des shapefiles, exécutez le fichier <code>2-export_gtfs.R</code>. En raison de la taille des données, l'exécution des deux fichiers prend environ trente minutes chacun.

Pour accéder aux données sans exécuter le code, utilisez les fichiers <code>.fst</code> (données non spatiales pour un chargement rapide) ou les fichiers <code>.shp</code> (shapefiles pour l'analyse géospatiale). Notez que cette méthode peut ne pas fournir les informations les plus récentes des systèmes de transport en commun.
