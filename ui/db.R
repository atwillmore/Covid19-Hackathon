tabItem(tabName = "db",
          fluidRow(
            box(
              title = "Input Hospital DB Information",
              solidHeader = TRUE,
              collapsible = TRUE,
              status = "primary",
              width = 4,
              textInput("ID", label = "Enter Hospital ID"),
              numericInput("Respirators", label = "Enter number of available respirators", value = 0)
            )
            )
          )
