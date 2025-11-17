################################################################################
# Spatial Data Visualization
################################################################################
#
# James Tuttlebee
# jamtuttlebee@gmail.com
# 11/16/2025
#
# Spatial visualization of wife's half marathon from Strava
#
################################################################################
# Read in necessary packages (some of these may not be required for this script, but I just read in all the ones I think I may need, just in case. I also tried so many different things here before I figured it out, that I may have some packages from previous attempts that I don't remember what should have been remeoved)
library(FITfileR)
library(readxl)
library(tidyverse)
library(janitor)
library(stars)
library(cowplot)
library(patchwork)
library(ggridges)
library(elevatr)
library(dplyr)
library(ggplot2)
library(ggspatial)
library(rnaturalearth)
library(rnaturalearthhires)
library(sf)
library(tigris)
library(terra)
library(tidyterra)
library(mapview)
library(leaflet)
library(geosphere)
################################################################################
# read in data
half_gpx <- "data/raw/Chicago_Half_Marathon.gpx"

# Read GPX track points
half_points <- st_read(half_gpx, layer = "track_points")

# Make sure geometry is read as points
half_points <- st_cast(half_points, "POINT")

# Arrange them by time to be able to calculate pace
half_points <- half_points %>%
  arrange(time)

# Calculate distance between points in meters
coords <- st_coordinates(half_points)
half_points$distance_m <- c(0, geosphere::distHaversine(coords[-nrow(coords), ], coords[-1, ]))

# Calculate time difference between points in seconds
half_points$time_sec <- c(0, as.numeric(difftime(half_points$time[-1], half_points$time[-nrow(half_points)], units = "secs")))

# Calculate pace in minutes per mile
meters_per_mile <- 1609.34
half_points$pace_min_per_mile <- (half_points$time_sec / 60) / (half_points$distance_m / meters_per_mile)

# Find bounds for chicago from illinois as best as possible - zoom in/crop on the area of the race - SE of chicago
chicago <- rnaturalearth::ne_states(country = "United States of America", returnclass = "sf") %>%
  filter(name == "Illinois") %>%
  st_crop(xmin = -87.65, xmax = -87.5, ymin = 41.77, ymax = 41.855)  # approximate Chicago bbox

# Define raster grid covering Chicago
half_rast <- rast(
  xmin = st_bbox(chicago)$xmin,
  xmax = st_bbox(chicago)$xmax,
  ymin = st_bbox(chicago)$ymin,
  ymax = st_bbox(chicago)$ymax,
  resolution = 0.001,
  crs = st_crs(chicago)$proj4string)

# Count number of points per cell
pace_raster <- rasterize(vect(half_points), half_rast, field = "pace_min_per_mile", fun = mean, background = NA)

# Plot the half marathon pace and route over an approximation of the south eastern part of chicago
half_plot <- ggplot() +
  geom_sf(data = chicago, fill = "springgreen1", color = "black") +
  geom_spatraster(data = pace_raster, na.rm = TRUE) +
  scale_fill_viridis_c(option = "magma", na.value = NA) +
  coord_sf() +
  theme_dark() +
  annotation_north_arrow(location = "tl") +
  annotation_scale(location = "bl") +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(title = "Chicago Half Marathon",
       fill = "Pace (min/mile)",
       subtitle = "Moving time: 2:12:21",
       x = "Longitude",
       y = "Latitude",
       caption = "Data source: Wife's Strava")

half_plot

# Save and export my plot
ggsave(plot = half_plot,
       filename = "results/img/half_marathon_pace.png", # Export my file as png
       width = 8,
       height = 8)

################################################################################
# The map that I came up with using the .fit file and the Fit documentation found online - really struggled to get this file into a raster or sf to work with so ended up finding the .gpx file instead, but decided to leave this in here for you to see
half_fit <- readFitFile("data/raw/Chicago_Half_Marathon.fit")

half_records <- records(half_fit) %>%
  bind_rows() %>%
    arrange(timestamp)

list(half_records)

half_records

half_coords <- half_records %>%
  select(position_long, position_lat)

half_map <- half_coords %>%
  as.matrix() %>%
  leaflet() %>%
  addTiles() %>%
  addPolylines()

half_map


################################################################################
# practicing getting the mapview of chicago/illinois - wanted to put the .fit file over this, but was struggling
cities <- ne_states(country = "United States of America", returnclass = "sf")

# Chicago polygon (rough, by state first)
chicago <- cities %>%
  filter(name == "Illinois")  # then you can zoom in with mapview

mapview(chicago)
