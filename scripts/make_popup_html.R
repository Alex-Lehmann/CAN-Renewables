# Script to create an HTML column for map labels

library(tidyverse)

# Load original data
renewableProjects = read_csv("data/renewable_projects.csv")

# Create a column with HTML popup text
mapData = mutate(renewableProjects,
                 PopupText = paste0("<b>", Name, "</b><br>",
                                    "<b>Production:</b> ", Type, ", ", format(Capacity, big.mark=","), " MW<br>",
                                    "<b>Year:</b> ", Year, "<br>",
                                    "<b>Status:</b> ", Status),
                 Template1 = paste0("<b>Name:</b> ", Name,
                                    "<br><b>Province:</b> ", Province,
                                    "<br><b>Latitude:</b> ", Latitude, "&deg",
                                    "<br><b>Longitude:</b> ", Longitude, "&deg",
                                    "<br><b>Year:</b> ", Year),
                 Template2 = paste0("<b>Type:</b> ", Type,
                                    "<br><b>Capacity:</b> ", format(Capacity, big.mark=","), " MW",
                                    "<br><b>Status:</b> ", Status,
                                    "<br><b>Owner:</b> ", Owner,
                                    "<br><b>Ownership:</b> ", Ownership))

# Save new data
write.csv(mapData, "data/map_data.csv", row.names=FALSE)
