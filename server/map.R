###Load in, filter data###
hospital_data <- reactive({
  
  #Data from https://hifld-geoplatform.opendata.arcgis.com/datasets/hospitals/data?geometry=94.054%2C-16.829%2C-124.970%2C72.120&selectedAttribute=BEDS
  Hospital_List <- read_excel("Hospitals.xlsx")
  
  #Filter for open and > 200 BEDS
  Hospital_List <- Hospital_List %>% filter(STATUS == "OPEN", BEDS > 200)
  
  #Dummy assignment of status
  Hospital_List$status <- rep(c("red", "orange", "green"), len = 1639)
  
  #Return dataset to be used by leaflet and dt
  Hospital_List
})

###Make map###
output$myMap <- renderLeaflet({
  
  Hospitals <- hospital_data()
  
  #make icons
  icons <- awesomeIcons(
    icon = 'ambulance',
    iconColor = 'black',
    library = 'fa',
    markerColor = Hospitals$status
  )
  
  #create leaflet map
  Hospitals %>% leaflet() %>%
    addTiles() %>%
    addAwesomeMarkers(lat = ~LATITUDE, lng = ~LONGITUDE,  label = ~NAME, popup = ~status, icon = icons)
})

###Generate output table###
output$table <- renderDataTable({
  Hospitals <- hospital_data()
  #select relevant columns to display
  Hospitals <- Hospitals %>% select(NAME:ZIP,BEDS)
  
  datatable(Hospitals,
            options = list(lengthMenu = c(25,50,100,200)),
            selection = "single")
  
})