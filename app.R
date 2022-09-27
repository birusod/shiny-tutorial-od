library(shiny)
library(tidyverse)
data("mtcars")

ui <- fluidPage(
  selectInput("cyl", label = "Cylinders", choices = unique(mtcars$cyl)),
  verbatimTextOutput("summary"),
  tableOutput("table"),
  plotOutput("plot")
)

server <- function(input, output, session) {
  output$summary <- renderPrint({
    mtcars |> 
      filter(cyl == input$cyl) |> 
      summary()
  })
  
  output$table <- renderTable({
    mtcars |> 
      filter(cyl == input$cyl) |> 
      head(8)
  })
  
  output$plot <- renderPlot({
    p <- mtcars |> 
      filter(cyl == input$cyl) |>
      ggplot(aes(mpg, disp)) +
      geom_point(size = 10, color = input$cyl)+
      theme_light()
    p
  })
  
}


shinyApp(ui, server)