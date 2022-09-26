
library(shiny)
ui <- fluidPage(
  "Hello, world!"
)

server <- function(input, output, session){
  
}


# to run the app
shinyApp(ui, server)
