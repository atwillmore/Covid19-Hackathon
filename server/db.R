###READ IN DATABASE HERE INSTEAD OF READ EXCEL
db <- reactive({
  Hospitals<-read_excel("Hospitals.xlsx")
})

output$hospital <- renderPrint({

  Hospitals <- db()

  if(input$ID %in% Hospitals$ID){
    Hospitals <- Hospitals %>% filter(ID == input$ID) %>%
      select(NAME,ZIP,BEDS)
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
  
  datatable(Hospital)
})






