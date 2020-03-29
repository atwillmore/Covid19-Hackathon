tabItem(tabName = "db",
          fluidRow(
            box(
              title = "Input Hospital DB Information",
              solidHeader = TRUE,
              collapsible = TRUE,
              status = "primary",
              width = 4,
              numericInput("ID", label = "Enter Hospital ID", value = 182096919),
              
              tags$hr(),
              
              br(),
              
              numericInput("Ventilators", label = "Enter number of available ventilators", value = 0),
              numericInput("Neg_room", label = "Enter number of available negative pressure rooms", value = 0),
              numericInput("Beds", label = "Enter number of available ICU beds", value = 0),
              textInput("Shortages", label = "Indicate any other shortages i.e. staff, gloves", value = ""),
              radioButtons("Status", label = "What is the overall occupancy status of your hospital?",
                           choices = list("Low Capacity" = 1,
                                          "Nearing Capacity" = 2,
                                          "Max Capacity" = 3),
                           selected = 1),
              tags$hr(),
              
              actionButton("submit", label = "Submit to database")
            ),
            box(title = "Is this the hospital you are searching for?",
                solidHeader = TRUE,
                collapsible = TRUE,
                status = "primary",
                width = 8,
                verbatimTextOutput("hospital"),
                verbatimTextOutput("test"))
            
                
            )
          )
