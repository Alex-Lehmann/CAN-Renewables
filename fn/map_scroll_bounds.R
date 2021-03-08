# Function to compute scroll bounds given a set of POIs on a map

map_scroll_bounds = function(vLat, vLng, buffer=15){
  
  # Compute ranges for latitude and longitude
  lat1 = min(vLat) - buffer
  lat2 = max(vLat) + buffer
  lng1 = min(vLng) - buffer
  lng2 = max(vLng) + buffer
  
  # Find centerpoints
  centerLat = mean(c(lat1, lat2))
  centerLng = mean(c(lng1, lng2))
  
  # Output
  out = list(mapCenter = c(centerLat, centerLng), scrollBox = c(lat1, lat2, lng1, lng2))
  return(out)
}
