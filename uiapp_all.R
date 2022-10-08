library(shiny)
library(tidyverse)
library(lubridate)

df <- read_csv('neiss/books.csv') |> 
  mutate(date = mdy(date),
         format = factor(format),
         pubID = factor(pubID))

format <- df |> select(format) |> distinct() |> pull()
pub <- df |> select(pubID) |> distinct() |> pull()
language <- df |> select(language) |> distinct() |> pull()



ui <- fluidPage(
  fluidRow(
    h1("SHINY UI LAYOUT")
    ),
  fluidRow(
    h2(span(style="color:blue","This is an", em("example"), "of UI layout"))
    ),
  br(),
  fluidRow(
    h4(
      p(
    "There are 95 books to explore in this dataset: We can explore them by 
    date, publisher, number of pages, print size and price.")
    )
  ),
  br(),br(),
  sliderInput('pages', label = 'Number of pages', 
              min = 10, max = 3000,value = c(200, 800)),
  selectInput('format', label = 'Book format', 
              choices = df$format |> unique()),
  selectInput('pub', label = 'Publisher', pub, multiple = TRUE,
              choices = df$pubID |> unique()),
  radioButtons('lang', label = 'Language', 
               choices = df$language |> unique()),
  checkboxInput('chdout', label = 'Checked out', 
                value = TRUE),
  dateRangeInput('dtrange', 'Date range',
                 start = min(df$date), end = max(df$date))
  
  
  
)
  

server <- function(input, output, session) {
  
}

shinyApp(ui, server)