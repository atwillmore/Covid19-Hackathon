output$myMap <- renderLeaflet({
  
  #Dummy Data
  Hospital_List <- read_excel("Hospital List.xlsx")
  Hospitals <- Hospital_List %>% separate(`Place Name`, into = c("Hospital", "City", "State", "Country"), sep = ",")
  Hospitals$status <- rep(c("red", "orange", "green"), len = 59)
  
  icons <- awesomeIcons(
    icon = 'ios-close',
    iconColor = 'black',
    library = 'ion',
    markerColor = Hospitals$status
  )
  
  Hospitals %>% leaflet() %>%
    addTiles() %>%
    addAwesomeMarkers(lat = ~Latitude, lng = ~Longitude,  label = ~Hospital, popup = ~status, icon = icons)
})
