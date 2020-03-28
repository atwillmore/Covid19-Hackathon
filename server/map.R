output$myMap <- renderLeaflet({
  Hospital_List <- read_excel("Hospital List.xlsx")
  Hospitals <- Hospital_List %>% separate(`Place Name`, into = c("Hospital", "City", "State", "Country"), sep = ",")
  
  Hospitals %>% leaflet() %>%
    addTiles() %>%
    addMarkers(popup = as.list(Hospitals$Hospital))
})
