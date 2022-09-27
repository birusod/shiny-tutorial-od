library(shiny)

ui <- fluidPage(
    print("you can quickly add the app boilerplate by typing “shinyapp” and pressing Shift+Tab")
  
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
