tabItem(tabName = "map",
        leafletOutput("myMap"),
        
        tags$hr(),
        
        dataTableOutput("table")
)