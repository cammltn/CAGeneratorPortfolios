# Global

#----------------------------------------

# Assign all libraries in use for the Generator and Constraints Tabs to
# gencon_lib
maps_lib <- c ("shiny", "leaflet", "tidyr", "tidyverse", "leaflet.extras", 
                "DBI", "viridis", "sp", "pillar", "DT", "shinyTime", "shinythemes", 
                "shinycssloaders", "lubridate", "shinyTime", "grDevices", "crosstalk", 
                "rlang", "htmltools", "data.table", "igraph", "sf", "rgdal", "haven", 
                "dplyr", "raster", "conflicted", "png", "shinyWidgets", "geojsonR", 
                "leaflet.extras", "shinycssloaders", "lemon", "plyr", "maptools", "PCIT", "readxl", "sf")
# conflicted package identies packages that contain functions with the
# same name.  if it finds conflicts, follow the error instructions to
# tell r which package to use.


# Load in all libraries set in gencon_lib with the lapply function
lapply (maps_lib, library, character.only = TRUE)

conflict_prefer("select", "dplyr")
conflict_prefer("filter", "dplyr")
#----------------------------------------


#----------------------------------------

# Tables in use for Generator Portfolios Tab


CA <- California_Electric_Generator

# top_mps is a query of the gen_table - used on the Map Legend to filter
# for the Top Ten MPs based on filters used


CA <- CA %>% filter (!is.na(X))

CA$X <- as.numeric (CA$X)
CA$Y <- as.numeric (CA$Y)

CA$X <- jitter (CA$X, factor = 2.0)
CA$Y <- jitter (CA$Y, factor = 2.0)

data.SP <- SpatialPointsDataFrame (CA[c(1,2)], CA[c(1,2)])
#----------------------------------------



#----------------------------------------




# Use the readLines function to access a GeoJSON file I created with
# ArcGIS Online - this will load in full CA transmission line system
# made with data from the California Energy Commission
topodata <- readLines ("https://opendata.arcgis.com/datasets/260b4513acdb4a3a8e4d64e69fc84fee_0.geojson") %>% 
  paste (collapse = "\n")


# Use the make Icon function to read a png file of a symbol - to be
# used to mark constraint point locations
constraint_point <- makeIcon (iconUrl   = "https://image.flaticon.com/icons/png/512/37/37713.png", 
                              iconWidth = 30, iconHeight = 30)


  