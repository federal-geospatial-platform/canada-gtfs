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

Clone the repository to create local up-to-date copies of the files. Run <code>/data/1-process_gtfs.R</code> to increase local memory, load in the links to the GTFS data, and create the functions to download the data. Then run <code>download.gtfs.canada()</code> to loop through the links to the GTFS data and process the relevant information. This will produce a <code>.fst</code> file, which is a quick-to-download data storage file. <code>/data/1-process_gtfs.R</code> also contains a function <code>map.gtfs.system()</code> to map the GTFS systems using the transit system names provided in the <code>gtfs_sources.xlsx</code> file. To produce shapefiles, run the <code>/data/2-export_gtfs.R</code> file. Due to the size of the data, both files take approximately thirty minutes each to run.

To access the data without running the code, visit the [Canadian Public Transit Systems dataset](https://open.canada.ca/data/en/dataset/b8241e15-2872-4a63-9d36-3083d03e8474) hosted on the Federal Geospatial Platform. Note that this method may not provide the most up-to-date information from the transit systems.


# Syst??mes de transport en commun canadiens

![image](https://user-images.githubusercontent.com/57367002/189784929-ca30b980-2a97-4068-b3d6-9bc77088236f.png)

### Quel est ce projet?

Code pour g??n??rer les donn??es g??ospatiales des agences de transport en commun au Canada, avec des informations sur les emplacements des arr??ts, les emplacements des lignes, les types des lignes, le niveau de service, l'acc??s aux fauteuils roulants, l'acc??s aux v??los, etc. Pour produire de [donn??es de Syst??mes de transport en commun canadiens](https://open.canada.ca/data/fr/dataset/b8241e15-2872-4a63-9d36-3083d03e8474) h??berg??es sur la Plateforme g??ospatiale f??d??rale. Les shapefiles sont ??galement fournis dans le r??f??rentiel.

Les utilisateurs peuvent utiliser le script pour t??l??charger directement les donn??es GTFS des agences de transport en commun de tout le Canada dans un format g??ospatial fonctionnel ou modifier le script ?? des fins personnalis??es.

| Champ                   | Description                                                                                                                                                                                                                                                   |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| id                      | Code unique pour le syst??me de transport en   commun                                                                                                                                                                                                          |
| system                  | Le syst??me de transport en commun qui a rapport?? les donn??es                                                                                                                                                                                                  |
| ville                   | La municipalit??/r??gion dans laquelle le syst??me de transport en commun   est principalement situ??                                                                                                                                                             |
| province                | La province dans laquelle le syst??me de transport en commun est   principalement situ??                                                                                                                                                                        |
| id_arret                | Un identifiant unique pour chaque arr??t du syst??me de transport en commun                                                                                                                                                                                     |
| id_forme                | Un identifiant unique pour chaque trajet de v??hicule du syst??me de   transport en commun                                                                                                                                                                      |
| nom_arret               | Le nom de l'arr??t donn?? par le syst??me de transport en commun                                                                                                                                                                                                 |
| lat_arret               | La coordonn??e de latitude de l'arr??t                                                                                                                                                                                                                          |
| lon_arret               | La coordonn??e de longitude de l'arr??t                                                                                                                                                                                                                         |
| lat_pt_forme            | Coordonn??e de latitude de la trajet de v??hicule (doit ??tre joint pour   chaque id_forme)                                                                                                                                                                      |
| lon_pt_forme            | Coordonn??e de longitude de la trajet de v??hicule (doit ??tre joint pour   chaque id_forme)                                                                                                                                                                     |
| sequence_pt_forme       | L???ordre dans lequel lat_pt_forme and lon_pt_forme faut ??tre joint                                                                                                                                                                                             |
| date_fin                | La derni??re date donn??e par le syst??me de transit pour laquelle les   donn??es sont exactes                                                                                                                                                                    |
| service_semaine         | Le nombre de trajets reli??s ?? l'arr??t ou au trajet de v??hicule au cours   de la semaine                                                                                                                                                                       |
| service_weekend         | Le nombre de trajets reli??s ?? l'arr??t ou au trajet de v??hicule au cours   de la semaine                                                                                                                                                                       |
| coleur_ligne            | La couleur officielle du ligne associ??e au trajet de v??hicule                                                                                                                                                                                                 |
| coleur_text_ligne       | La couleur officielle du texte du ligne associ??e au trajet de v??hicule                                                                                                                                                                                        |
| lignes_desservies       | Les noms des lignes connect??s ?? l'arr??t ou au trajet de v??hicule                                                                                                                                                                                              |
| types_lignes_desserives | Les types de v??hicules connect??s ?? l'arr??t ou ?? la trajectoire des   v??hicules                                                                                                                                                                                |
| embarq_fauteuil_rouland | 0 ou vide = l'arr??t n???a pas d???information d'accessibilit??; 1 = certains   v??hicules ?? l'arr??t ou chemins d'acc??s sont accessibles aux fauteuils   roulants; 2 = aucun v??hicule ?? l'arr??t ou chemin menant ?? l'arr??t n'est   accessible aux fauteuils roulants |
| access_fauteuil_rouland | 0 ou vide = aucune information d'accessibilit?? pour le voyage; 1 = le   v??hicule utilis?? pour le voyage peut accueillir au moins un fauteuil roulant;   2 = aucun fauteuil roulant ne peut ??tre accept?? pendant le voyage                                     |
| velos_autorises         | 0 ou vide = aucune information des v??los pour le voyage; 1 = le v??hicule   utilis?? pour le voyage peut accueillir au moins un v??lo; 2 = aucun v??lo ne   peut ??tre accept?? pendant le voyage                                                                   |


### Comment puis-je g??n??rer les donn??es???

Cloner le r??f??rentiel pour cr??er des copies locales des fichiers. Ex??cutez <code>/data/1-process_gtfs.R</code> pour augmenter la m??moire locale, charger les liens vers les donn??es GTFS et cr??er les fonctions pour t??l??charger les donn??es. Ensuite, ex??cutez <code>download.gtfs.canada()</code> pour parcourir les liens vers les donn??es GTFS et traiter les informations pertinentes. Cela produira un fichier <code>.fst</code>, qui est un fichier de stockage de donn??es rapide ?? t??l??charger. <code>/data/1-process_gtfs.R</code> contient ??galement une fonction <code>map.gtfs.system()</code> pour mapper les syst??mes GTFS ?? l'aide des noms de syst??me de transit fournis dans le <code>gtfs_sources.xlsx</code > dossier. Pour produire des shapefiles, ex??cutez le fichier <code>/data/2-export_gtfs.R</code>. En raison de la taille des donn??es, l'ex??cution des deux fichiers prend environ trente minutes chacun.

Pour acc??der aux donn??es sans ex??cuter le code, visitez les [donn??es de Syst??mes de transport en commun canadiens](https://open.canada.ca/data/fr/dataset/b8241e15-2872-4a63-9d36-3083d03e8474) h??berg??es sur la Plateforme g??ospatiale f??d??rale. Notez que cette m??thode peut ne pas fournir les informations les plus r??centes des syst??mes de transport en commun.
