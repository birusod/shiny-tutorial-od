library(shiny)

ui <- fluidPage(
  textInput('name', 'Enter your name', placeholder = 'name '),
  textOutput("gtg")
)

server <- function(input, output, session) {
  rct_expr <- reactive(
    paste0('Hello ', input$name,'! ', ' How are you?')
    )
  output$gtg <- renderText(rct_expr())
}

shinyApp(ui, server)