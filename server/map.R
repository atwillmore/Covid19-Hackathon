output$myMap <- renderLeaflet({
  
  #Dummy Data
  Hospital_List <- read_excel("Hospital List.xlsx")
  Hospitals <- Hospital_List %>% separate(`Place Name`, into = c("Hospital", "City", "State", "Country"), sep = ",")
  Hospitals$status <- rep(c("red", "orange", "green"), len = 59)
  
  icons <- awesomeIcons(
    icon = 'ambulance',
    iconColor = 'black',
    library = 'fa',
    markerColor = Hospitals$status
  )
  
  Hospitals %>% leaflet() %>%
    addTiles() %>%
    addAwesomeMarkers(lat = ~Latitude, lng = ~Longitude,  label = ~Hospital, popup = ~status, icon = icons)
})
