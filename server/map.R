###Load in, filter data###
hospital_data <- reactive({
  
  #####LOAD IN DATABASE HERE INSTEAD OF READ EXCEL, ASSIGN IT TO Hospital_List#####
  #Data from https://hifld-geoplatform.opendata.arcgis.com/datasets/hospitals/data?geometry=94.054%2C-16.829%2C-124.970%2C72.120&selectedAttribute=BEDS
  login <- readLines("login.txt")
  loginTxt <- unlist(strsplit(login, split = "\\t"))
  hdb = dbConnect(MySQL(), 
                  user=loginTxt[1], 
                  password = loginTxt[2], 
                  dbname="hospital_db", 
                  host="hospitaldb2.cbchdqimrdp1.us-east-2.rds.amazonaws.com")
  hosp_info <- dbSendQuery(hdb, "select * from hospitals_19oct7")
  Hospital_List <-fetch(hosp_info, n=-1)
  
  #Filter for open and > 200 BEDS
  Hospital_List <- Hospital_List %>% filter(STATUS == "OPEN", BEDS > 150, TYPE == "CRITICAL ACCESS" |
                                              TYPE == "GENERAL ACUTE CARE" |
                                              TYPE == "CHILDREN")
  
  #Dummy assignment of status
  Hospital_List$status <- rep(c("max capacity", "nearing capacity", "open resources"), len = 1933)
  
  #Assign colors for markers
  for(row in 1:nrow(Hospital_List)){
    if(Hospital_List[row, "status"] == "max capacity"){
      Hospital_List[row, "marker"] = "red"
    }
    else if (Hospital_List[row, "status"] == "nearing capacity"){
      Hospital_List[row, "marker"] = "orange"
    }
    else{
      Hospital_List[row,"marker"] = "green"
    }
  }
  
  #Check for input of filters on available capacity
  if(1 %in% input$capacity == FALSE){
    Hospital_List <- Hospital_List %>% filter(status != "max capacity")
  }
  
  if(2 %in% input$capacity == FALSE){
    Hospital_List <- Hospital_List %>% filter(status != "nearing capacity")
  }
  
  if(3 %in% input$capacity == FALSE){
    Hospital_List <- Hospital_List %>% filter(status != "open resources")
  }
  
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
    markerColor = Hospitals$marker
  )
  
  #create leaflet map
  Hospitals %>% leaflet() %>%
    addTiles() %>%
    addAwesomeMarkers(lat = ~LATITUDE, lng = ~LONGITUDE,  label = ~NAME, icon = icons, popup = paste("Status:", Hospitals$status, "<br>",
                                                                                                     "Beds Available:", Hospitals$BEDS))
})

###Generate output table###
output$table <- renderDataTable({
  Hospitals <- hospital_data()
  #select relevant columns to display
  Hospitals <- Hospitals %>% select(NAME:ZIP,BEDS, status)
  
  datatable(Hospitals,
            options = list(lengthMenu = c(25,50,100,200)),
            selection = "single")
  
})