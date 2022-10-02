# Controlling timing of evaluation
  # Timed invalidation: reactiveTimer()
  # On click: actionButton()

library(shiny)
library(tidyverse)
source('help4func1.R')

ui <- fluidPage(
  fluidRow(
    column(3,
           numericInput('lambda1', 'lambda 1', value = 3),
           numericInput('lambda2', 'lambda 2', value = 5),
           numericInput('n', 'N', value = 1e4, min = 0),
           actionButton('sim', 'Simulate')
           ),
    column(9,
           plotOutput('hist')
           )
  ),
  fluidRow(
    column(9,
           plotOutput('hist2')
           )
  )
)

server <- function(input, output, session) {
  ### Using reactiveTimer()
  # timer <- reactiveTimer(2000) # 500 ms => plot will update twice a second
  # x1 <- reactive({
  #   timer()
  #   rnorm(input$n, input$lambda1)}
  #   )
  # x2 <- reactive({
  #   timer()
  #   rnorm(input$n, input$lambda2)}
  # )
  
  ### Using actionButton():  click on simulate button updates x1() and x2()
  # x1 <- reactive({
  #   input$sim
  #   rnorm(input$n, input$lambda1)}
  # )
  # x2 <- reactive({
  #   input$sim
  #   rnorm(input$n, input$lambda2)}
  # )
  
  ### Using eventReactive(): 
  x1 <- eventReactive(input$sim, {
    rnorm(input$n, input$lambda1)
  })
  x2 <- eventReactive(input$sim, {
    rnorm(input$n, input$lambda2)
  })
  
  output$hist <- renderPlot({
    freqpoly(x1(), x2(), binwidth = 1, xlim = c(0, 40))
  })
  
  output$hist2 <- renderPlot({
    tibble(var = c(x1(), x2())) |> 
      ggplot(aes(var)) + geom_histogram(bins = 20, color = 'blue', fill = 'wheat') +
      theme_light()
  })
}

shinyApp(ui, server)