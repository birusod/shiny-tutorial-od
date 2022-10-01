library(shiny)
source("help4func1.R")

# App contruction:
ui <- fluidPage(
  fluidRow(
    column(4,
           'Distribution 1',
           numericInput('n1', 'N', value = 1000, min = 1),
           numericInput('mean1', 'µ', value = 0, min = 1, step = 0.1),
           numericInput('sd1', 'σ', value = 1, min = .5, step = 0.1)
           ),
    
    column(4,
           'Distribution 2',
           numericInput('n2', 'N', value = 1000, min = 1),
           numericInput('mean2', 'µ', value = 0, min = 1, step = 0.1),
           numericInput('sd2', 'σ', value = 1, min = .5, step = 0.1)
           ),
    
    column(4,
           'Freqpoly polygon',
           numericInput('bw', 'Bin width', value = .1, step = .1),
           sliderInput('range', 'Range', value = c(-3, 3), min = -5, max = 5)
           )
  ),
  
  fluidRow(
    column(9,plotOutput('hist')),
    column(3,verbatimTextOutput('ttest'))
  )
)

server <- function(input, output, session) {
  output$hist <- renderPlot({
    x1 <- rnorm(input$n1, input$mean1, input$sd1)
    x2 <- rnorm(input$n2, input$mean2, input$sd2)
    
    freqpoly(x1, x2, binwidth = input$bw, xlim = input$range)
  }
  )
  
  output$ttest <- renderText({
    x1 <- rnorm(input$n1, input$mean1, input$sd1)
    x2 <- rnorm(input$n2, input$mean2, input$sd2)
    
    t_test(x1, x2)
  })
  
}

shinyApp(ui, server)
