library(shinythemes)
library(tidyverse)
library(leaflet)
library(plotly)

source("fn/map_scroll_bounds.R")

# Read in data
mapData = read_csv("data/map_data.csv")
provinceCounts = read_csv("data/province_counts.csv")
typeCounts = read_csv("data/type_counts.csv")