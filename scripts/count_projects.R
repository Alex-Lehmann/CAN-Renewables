# Computes the cumulative number of observed renewable projects for each province and saves as a CSV

library(tidyverse)

# Read in data
renewableProjects = read_csv("data/renewable_projects.csv")

# Get counts of new projects each year in each province
countsNew = tibble(Year = (min(renewableProjects$Year)-1):max(renewableProjects$Year))
for (prov in unique(renewableProjects$Province)){
  v = rep(-1, nrow(countsNew))
  for (j in 1:length(v)){
    v[j] = renewableProjects %>%
      filter(Province == prov,
             Year == min(renewableProjects$Year) + j - 1) %>%
      summarize(n())
  }
  
  toAdd = tibble(v)
  colnames(toAdd) = prov
  countsNew = cbind(countsNew, toAdd)
}

# Get counts of cumulative projects for each year in each province
countsTotal = countsNew %>%
  mutate(across(!matches("Year"), cumsum)) %>%
  pivot_longer(!Year, names_to="Province", values_to="Count")

# Save as a CSV
write.csv(countsTotal, "data/province_counts.csv", row.names=FALSE)
