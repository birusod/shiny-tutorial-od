library(shiny)
library(tidyverse)
library(lubridate)
animals <- c("dog", "cat", "mouse", "bird")
city <- c("Seattle", "Tacoma", "Bellevue", "Everret")
dishes <- c("Egg", "Milk", "Bread", "Meatballs", "Cookies", "Juice")

gender <- c("teen", "adult", "senior")
gender_lab <- setNames(as.list(gender), c("TEEN", "ADULT", "SENIOR"))

hobbies <- c("Hike", "Swim", "Jog", "Rowing", "Soccer", "Hunt")


ui <- fluidPage(
  # headers and texts
  h1("Page Title"),
  h2("This is an", em("awesome"), "subtitle"),
  strong("Bold text"), br(),
  em("awesome"), br(),
  strong(span(style="color:blue", "Blue Colored Text")), br(),
  div(
    HTML(
      paste("This text is ", tags$span(style="color:red", "red colored"), sep = ""))
  ), br(),
  p("This is apragraph to descibe a the data: 
    Today, Shiny is used in almost as many niches and industries as R itself is. 
    It’s used in academia as a teaching tool for statistical concepts, a way to 
    get undergrads excited about learning to write code, a splashy medium for 
    showing off novel statistical methods or models."),
  p("It’s used by big pharma companies to speed collaboration between scientists 
    and analysts during drug development. It’s used by Silicon Valley tech companies 
    to set up realtime metrics dashboards that incorporate advanced analytics."),
  
  # free text
  textInput("first_last", "Full name:", placeholder = "Your name"),
  passwordInput("passw", "Enter password"),
  textAreaInput("story", "Tell me about yourself", rows = 2),
  
  # numeric input
  numericInput("age", "Age (in years)", value = 0, min = 0, max = 100),
  sliderInput("wgt", "Weight", value = 10, min = 5, max = 15, step = 0.5),
  sliderInput("hgt", "Height range", value = c(30, 50), min = 10, max = 80),
  sliderInput("sal", "Salary", value = 0, min = 0, max = 10000, step = 1000,
              pre = "$", sep = ",", animate = TRUE),
  sliderInput("anim", "Looping animation", min = 1, max = 2000,
              value = 1, step = 100, 
              animate = animationOptions(interval = 300, loop = TRUE)),
  sliderInput("date", "Date", min = ymd("2022-01-01"), max = ymd("2022-12-31"),
              value=ymd("2022-07-01")),
  
  
  # dates
  dateInput("dob", "Date of birth"),
  dateRangeInput("pto", "Vacations period"),
  
  # limited choices:
  selectInput(inputId = 'pet', label = "What is your favorite pet?", animals),
  selectInput(inputId = 'food', label = "What did you get for diner?", dishes,
              multiple = TRUE),
  radioButtons(inputId = 'city', label = "Where do you live?", city),
  radioButtons(inputId = 'agegrp', label = "Age group", 
               choiceValues = list("teen", "adult", "senior"),
               choiceNames = list("TEEN", "ADULT", "SENIOR")),
  radioButtons(inputId = 'agegrp2', label = "AGE CAT", 
               choices = gender_lab),
  radioButtons("sex", "Gender", c("Male", "Female")),
  radioButtons("dist", "Distribution type:",
               c("NORMAL" = "norm",
                 "UNIFORM" = "unif",
                 "LOG-NORMAL" = "lnorm",
                 "EXPONETIAL" = "exp")),
  
  checkboxInput("rprog", "R programming skills?", value = TRUE),
  checkboxInput("pprog", "Python programming skills?"),
  checkboxGroupInput("hob", "Your favorite hobbies?", hobbies),
  
  # File uploads
  fileInput("doc", "Upload", multiple = TRUE)
  
  # Action buttons
   # actionButton("click", "Click me!", class = "btn-sm btn-danger"),
   # actionButton("drink", "Drink me!", icon = icon("cocktail")),
   # actionButton("drink", "Drink me!", class = "btn-lg btn-success")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)