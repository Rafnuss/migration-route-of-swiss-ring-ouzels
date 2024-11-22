library(leaflet)
library(dplyr)

bird_data <- read.csv("https://zenodo.org/records/14191024/files/paths.csv") %>%
  filter(type=="most_likely")

# Generate a color palette for unique tag IDs
tag_ids <- unique(bird_data$tag_id)
color_palette <- colorFactor(palette = "Set1", domain = tag_ids)

leaflet_map <- leaflet(height = 600) %>% addTiles()

# Add polylines and markers for each tag_id
for (tag in tag_ids) {
  bird_subset <- bird_data %>% filter(tag_id == tag)
  leaflet_map <- leaflet_map %>%
    addPolylines(
      lng = ~lon,
      lat = ~lat,
      data = bird_subset,
      color = color_palette(tag),
      weight = 2,
      popup = ~paste0("Tag ID: ", tag_id, "<br>Step: ", stap_id)
    ) %>%
    addCircleMarkers(
      lng = ~lon,
      lat = ~lat,
      data = bird_subset,
      color = color_palette(tag),
      radius = 4,
      fillOpacity = 0.8,
      popup = ~paste0("Tag ID: ", tag_id, "<br>Step: ", stap_id)
    )
}

# Add a legend
leaflet_map <- leaflet_map %>%
  addLegend(
    position = "topright",
    pal = color_palette,
    values = tag_ids,
    title = "Bird Trajectories",
    opacity = 1
  )

# Display the map
leaflet_map
