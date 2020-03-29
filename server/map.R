###Load in, filter data###
hospital_data <- reactive({
  
  #Data from https://hifld-geoplatform.opendata.arcgis.com/datasets/hospitals/data?geometry=94.054%2C-16.829%2C-124.970%2C72.120&selectedAttribute=BEDS
  Hospital_List <- read_excel("Hospitals.xlsx")
  
  #Filter for open and > 200 BEDS
  Hospital_List <- Hospital_List %>% filter(STATUS == "OPEN", BEDS > 200, TYPE == "CRITICAL ACCESS" |
                                              TYPE == "GENERAL ACUTE CARE" |
                                              TYPE == "CHILDREN")
  
  #Dummy assignment of status
  Hospital_List$status <- rep(c("red", "orange", "green"), len = 1533)
  
  #Assign icon for children's hospital vs general
  for(row in 1:nrow(Hospital_List)){
    if(Hospital_List[row,"TYPE"] == "CHILDREN"){
      Hospital_List[row,"icon"] = "child"
    }
    else{
      Hospital_List[row,"icon"] = "h-square"
    }
  }
  
  #Return dataset to be used by leaflet and dt
  Hospital_List
})

###Make map###
output$myMap <- renderLeaflet({
  
  Hospitals <- hospital_data()
  
  #make icons
  icons <- awesomeIcons(
    icon = Hospitals$icon,
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