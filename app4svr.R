library(shiny)

ui <- fluidPage(
  textInput('name', 'Enter your name', placeholder = 'Enter name here'),
  textOutput("gtg")
)

server <- function(input, output, session) {
  # rct_expr <- reactive(
  #   paste0('Hello ', input$name,'! ', ' How are you?')
  #   )
  # output$gtg <- renderText(rct_expr())
  
  
  ## using observeEvent()
  rct_expr <- reactive(
    paste0('Hello ', input$name,' ! ,', ' How are you?')
  )
  output$gtg <- renderText(rct_expr())
  observeEvent(input$name, {
    message("Greeting performed and complete!")
  })
}

shinyApp(ui, server)