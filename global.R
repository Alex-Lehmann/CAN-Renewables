library(shinythemes)
library(tidyverse)
library(leaflet)
library(plotly)

# Read in data
mapData = read_csv("data/map_data.csv")
provinceCounts = read_csv("data/province_counts.csv")