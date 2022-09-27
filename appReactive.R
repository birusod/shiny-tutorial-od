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
  
  dat <-  reactive({mtcars |> filter(cyl == input$cyl)})
  
  output$summary <- renderPrint({
    dat() |> summary()
  })
  
  output$table <- renderTable({
    dat() |> head(8)
  })
  
  output$plot <- renderPlot({
    p <- dat() |> 
      ggplot(aes(mpg, disp)) +
      geom_point(size = 10, color = input$cyl)+
      theme_light()
    p
  })
  
}


shinyApp(ui, server)