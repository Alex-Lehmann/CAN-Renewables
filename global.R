library(shinythemes)
library(tidyverse)
library(leaflet)
library(plotly)
library(timevis)
library(ggalluvial)

source("fn/map_scroll_bounds.R")

# Read in data
mapData = read_csv("data/map_data.csv")
provinceCounts = read_csv("data/province_counts.csv")
typeCounts = read_csv("data/type_counts.csv")

# Color palettes
energyTypes =  c("Biomass", "Geothermal", "Hydroelectric", "Solar"  , "Tidal"  , "Wind")
energyColors = c("#8D4153", "#DA6749"   , "#FAAC7C"      , "#FFDC7C", "#2C4D59", "#38998E")

provinces =      c("Ontario", "British Columbia", "Nova Scotia", "New Brunswick", "Alberta", "Quebec" , "Newfoundland and Labrador")
provinceColors = c("#F0E57D", "#F9C672"         , "#F18C63"    , "#B84052"     , "#8A2B6C", "#49245D", "#2C2449")
