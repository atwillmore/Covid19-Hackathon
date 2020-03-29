hospital_data <- reactive({
  
  #Dummy Data
  Hospital_List <- read_excel("Hospital List.xlsx")
  Hospitals <- Hospital_List %>% separate(`Place Name`, into = c("Hospital", "City", "State", "Country"), sep = ",")
  Hospitals$status <- rep(c("red", "orange", "green"), len = 59)
  
  Hospitals
})

output$myMap <- renderLeaflet({
  
  Hospitals <- hospital_data()
  
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

output$table <- renderDataTable({
  Hospitals <- hospital_data()
  datatable(Hospitals,
            options = list(lengthMenu = c(50,100,200,500)))
  
})