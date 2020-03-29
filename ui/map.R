tabItem(tabName = "map",
        leafletOutput("myMap"),
        
        #filter capability for map
        absolutePanel(top = 70, right = -80,
                      checkboxGroupInput("capacity", label = "Filter by Available Resources",
                                         choices = list("Max Capacity" = 1,
                                                        "Nearing Capacity" = 2,
                                                        "Low Capacity" = 3),
                                         selected = c(1,2,3))),
        
        tags$hr(),
        
        dataTableOutput("table")
)