library(shiny)

ui <- fluidPage(
  
  # free text
  textInput("first_last", "Full name:"),
  passwordInput("passw", "Enter password"),
  textAreaInput("story", "Tell me about yourself", rows = 2),
  
  #numeric input
  numericInput("age", "Age (in years)", value = 0, min = 0, max = 100),
  sliderInput("wgt", "Weight", value = 10, min = 5, max = 15, step = 0.5),
  sliderInput("hgt", "Height range", value = c(30, 50), min = 10, max = 80),
  sliderInput("sal", "Salary", value = 0, min = 0, max = 10000, step = 1000,
              pre = "$", sep = ",", animate = TRUE),
  sliderInput("anim", "Looping animation", min = 1, max = 2000,
              value = 1, step = 100, 
              animate = animationOptions(interval = 300, loop = TRUE))
  
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)