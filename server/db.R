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
  dbClearResult(hosp_info)
  dbDisconnect(hdb)
  
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
  login <- readLines("login.txt")
  loginTxt <- unlist(strsplit(login, split = "\\t"))
  hdb = dbConnect(MySQL(), 
                  user=loginTxt[1], 
                  password = loginTxt[2], 
                  dbname="hospital_db", 
                  host="hospitaldb2.cbchdqimrdp1.us-east-2.rds.amazonaws.com")
   
   
   sql <- "UPDATE hospitals_19oct7 SET ventilators = ?vent, 
   BEDS = ?beds,
   negative_rooms = ?neg,
   shortages = ?short,
   entry_date = ?date
   WHERE id = ?ID;"
   query <- sqlInterpolate(hdb, sql, vent = input$Ventilators,
                           beds = input$Beds,
                           neg = input$Neg_room,
                           short = input$Shortages,
                           date = input$date,
                           ID = input$ID)
   dbGetQuery(hdb, query)
   
   dbDisconnect(hdb)
  
  db()
  
})

output$success <- renderPrint({
  Hospitals <- x()
  print("Upload Successful")
  
})





