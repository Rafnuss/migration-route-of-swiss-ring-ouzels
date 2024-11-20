# See https://raphaelnussbaumer.com/GeoPressureManual/geopressuretemplate-workflow.html

library(GeoPressureR)

# Run workflow step-by-step for a single tag
id <- "16LF" # Run a single tag
geopressuretemplate_config(id)
tag <- geopressuretemplate_tag(id)
graph <- geopressuretemplate_graph(id)
geopressuretemplate_pressurepath(id)


## Run workflow for all tags
list_id <- tail(names(yaml::yaml.load_file("config.yml", eval.expr = FALSE)), -1)

list_id <- c("16LF", "18IS", "20OE", "20OA", "22QQ") # Light only: "22TD" "22SQ", "22TE", "22SO")

for (id in list_id){
  cli::cli_h1("Run geopressuretemplate_tag for {id}")
  geopressuretemplate_tag(id)
}

# Manual checking of coherence
id = "16LF"
geopressureviz(id)

# Add wind
for (id in list_id){
  cli::cli_h1("Run tag_download_wind for {id}")
  load(glue::glue("./data/interim/{id}.RData"))
  tag_download_wind(tag)
}

# Run graph
for (id in list_id){
  cli::cli_h1("Run geopressuretemplate_graph for {id}")
  geopressuretemplate_graph(id)
}

id <- "20OA"
load(glue::glue("./data/interim/{id}.RData"))

# Run pressurepath
for (id in list_id){
  cli::cli_h1("Run pressurepath for {id}")
  geopressuretemplate_pressurepath(id)
}
