###READ IN DATABASE HERE 
db <- reactive({
  login <- readLines("login.txt")
  loginTxt <- unlist(strsplit(login, split = "\\t"))
  hdb = dbConnect(MySQL(), 
                  user=loginTxt[1], 
                  password = loginTxt[2], 
                  dbname="hospital_db", 
                  host="hospitaldb2.cbchdqimrdp1.us-east-2.rds.amazonaws.com")
  hosp_info <- dbSendQuery(hdb, "select * from hospitals_19oct7")
  Hospital_List <-fetch(hosp_info, n=-1)
  
  Hospital_List
})

output$hospital <- renderPrint({

  Hospitals <- db()

  if(input$ID %in% Hospitals$ID){
    Hospitals <- Hospitals %>% filter(ID == input$ID) %>%
      select(NAME,ZIP,BEDS,ventilators, negative_rooms, shortages, entry_date)
    print(as.data.frame(Hospitals))
  }
  else{
    print("No hospital found with that ID")
  }

})

x <- eventReactive(input$submit, {
  ###MAKE UPDATES TO DATABASE HERE
  
  #Loop through for ID, update that ID's columns with inputted info
  Hospitals<-read_excel("Hospitals.xlsx")
  for (row in 1:nrow(Hospitals)){
    if(Hospitals[row,"ID"] == input$ID){
      Hospitals[row, "Ventilators"] = input$Ventilators
      Hospitals[row, "BEDS"] = input$Beds
      Hospitals[row, "Negative Rooms"] = input$Neg_room
      Hospitals[row, "Shortages"] = input$Shortages
      Hospitals[row, "status"] = input$Status
      Hospitals[row, "date"] = input$date
      break()
    }
    
    
  }
  
  Hospitals[row,]
  
})

output$tab <- renderDataTable({
  Hospital <- x()
  
  Hospital <- Hospital %>% select(NAME,ZIP,BEDS)

# dbSendQuery(hdb,  dbEscapeStrings(hdb, "update hospitals_19oct7 
#                  set ventilators = input$Ventilators, 
#                      negative_rooms = input$Neg_room,
#                      shortages = input$Shortages,
#                      entry_date = str_to_date(input$date, '%Y-%m-%d'),
#                      beds = input$Beds
#                 where id =input$ID"     ))
  
  dbSendQuery(hdb,  dbEscapeStrings(hdb, "update hospitals_19oct7 
                 set ventilators = input$Ventilators, 
                     negative_rooms = input$Neg_room,
                where id =input$ID"     ))
update <- dbSendQuery(hdb,  dbEscapeStrings(hdb, "select * from hosp_info_19oct7 where id = input$ID"))
  fetch(update)
  
  
  datatable(Hospital)
})






