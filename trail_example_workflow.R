# Get trail and road data from Open Street Maps
# Forest Hayes
# Dec 16, 2020


library(magrittr)

# Create a bounding box for the study area
glac_bbox <-
  # approximate bounding box for Glacier National Park
  sf::st_bbox(c(xmin = -114.47552, ymin = 48.23369, xmax = -113.24198, ymax = 49.0000))

# Get trail data
trails <- 
  osmdata::opq(bbox = glac_bbox) %>% 
  osmdata::add_osm_feature(key = 'highway', value = c("path", "footway", "steps")) %>% 
  osmdata::osmdata_sf()

# Get trailhead data
#' Note: this is specifically for _named_ trailheads. There are numerous parking
#' areas that are at the start of trails that do now show up as trailheads.
trailhead <- 
  osmdata::opq(bbox = glac_bbox) %>% 
  osmdata::add_osm_feature(key = 'highway', value = c("trailhead")) %>% 
  osmdata::osmdata_sf()

# # Get parking area data - Could be useful??
# parking <-
#   osmdata::opq(bbox = glac_bbox) %>%
#   osmdata::add_osm_feature(key = 'amenity', value = c("parking")) %>%
#   osmdata::osmdata_sf()

# Get data for all road types
all_roads <-
    osmdata::opq(bbox = glac_bbox) %>%
    osmdata::add_osm_feature(
      key = 'highway', 
      value = c("motorway", "trunk", "primary", "secondary", "tertiary", 
                "unclassified", "residential", "motorway_link", "trunk_link", 
                "primary_link", "secondary_link", "tertiary_link", 
                "living_street", "service")
    ) %>%
    osmdata::osmdata_sf()
  

# Preview data via map
mapview::mapview(
  list(
    Roads = all_roads$osm_lines,
    Trail = trails$osm_lines,
    Trailhead = trailhead$osm_points
  ),
  color = list("saddlebrown", "coral", "darkblue"),
  col.regions = "blue"
)
