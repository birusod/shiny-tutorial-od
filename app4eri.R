library(shiny)
library(vroom)
library(tidyverse)
library(lubridate)

injuries <- vroom::vroom("neiss/injuries_2017.csv")

products1 <- vroom::vroom("neiss/products_2017.csv", delim = ',')
lst <- injuries |> select(prod1) |> pull()  
products <- products1 |>  filter(code %in% lst) |> head(50)

pop <- vroom::vroom("neiss/population_2017.csv") |> select(-1) |> 
  mutate(sex = str_to_title(sex))


# Done early for primary EDA and cleaning:
  ## selected <- injuries  |>  filter(prod1 == 649) #prod_code
  ## summary <- selected |>
#   count(age, sex, wt = weight) |> 
#   left_join(pop, by = c('age', 'sex')) |> 
#   mutate(rate = n / population * 1e4)


prod_codes <- setNames(products$code, products$title)

ui <- fluidPage(
  h1(strong("SHINY PRACTICE")),
  h2(strong("Case study:", em("ER injuries"))),
  br(),
  em("DATASET: neiss"), br(),
  tags$a(href="https://github.com/hadley/neiss", "neiss source"),
  strong(span(style="color:blue", "NEISS")), br(),
  div(
    HTML(
      paste0("Explore data from the ", 
            tags$span(style="color:red", 
                      "National Electronic Injury Surveillance System (NEISS)"), 
            " , collected by the Consumer Product Safety Commission"))
  ), 
  br(),
  p("In this chapter, I’m going to focus on just the data from 2017"),
  
  fluidRow(
    column(6,selectInput('code', 'Product type', choices = prod_codes))
  ),
  fluidRow(
    column(4, tableOutput('diag')),
    column(4, tableOutput('body_part')),
    column(4, tableOutput('location'))
  ),
  fluidRow(
    column(12, plotOutput('age_sex'))
  )
)

server <- function(input, output, session) {
  
  # data
  selected <- reactive(injuries |> filter(prod1 == input$code))
  summary <- reactive({
    selected() |> 
      count(age, sex, wt = weight) |> 
      left_join(pop, by = c('age', 'sex')) |> 
      mutate(rate = n / population * 1e4)
  })
  
  #Tables
  output$diag <- renderTable({
    selected() |> count(diag, wt = weight, sort = TRUE)
  })
  output$body_part <- renderTable({
    selected() |> count(body_part, wt = weight, sort = TRUE)
  })
  output$location <- renderTable({
    selected() |> count(location, wt = weight, sort = TRUE)
  })
  
  #Plot
  output$age_sex <- renderPlot({
    summary() |> 
      ggplot(aes(age, n, color = sex)) +
      geom_line() +
      labs(y = "Estimated number of injuries")
  })
}

shinyApp(ui, server)