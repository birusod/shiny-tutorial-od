library(shiny)
library(vroom)
library(tidyverse)
library(lubridate)

injuries <- vroom::vroom("neiss/injuries_2017.csv")

products <- vroom::vroom("neiss/products_2017.csv", delim = ',')
lst <- injuries |> 
  count(prod1, sort = TRUE) |> 
  head(100)|> 
  select(prod1) |> 
  pull()  
products2 <- products |>  filter(code %in% lst) 

pop <- vroom::vroom("neiss/population_2017.csv") |> select(-1) |> 
  mutate(sex = str_to_title(sex))


mytop5 <- function(df, var, n = 5){
  df |> 
    mutate({{var}} := fct_lump(fct_infreq({{var}}), n = n)) |> 
    group_by({{var}}) |> 
    summarise(tot = as.integer(sum(weight)))
}


# Done early for primary EDA and cleaning:
  ## selected <- injuries  |>  filter(prod1 == 649) #prod_code
  ## summary <- selected |>
#   count(age, sex, wt = weight) |> 
#   left_join(pop, by = c('age', 'sex')) |> 
#   mutate(rate = n / population * 1e4)


prod_codes <- setNames(products$code, products$title)
prod_codes2 <- setNames(products2$code, products2$title)

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
    column(6,
           selectInput('code', 'Product type', choices = prod_codes2
             # for size =>width = '50%'
             )),
    column(6,
           selectInput('y', 'Y axis', c('Count', 'Rate')))
  ),
  fluidRow(
    column(4, tableOutput('diag')),
    column(4, tableOutput('body_part')),
    column(4, tableOutput('location'))
  ),
  fluidRow(
    column(12, plotOutput('age_sex'))
  ),
  
  fluidRow(
    column(2, actionButton('story', 'Tell me a story')),
    column(10, textOutput('narrative'))
  )
  #width = 12
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
  
  #Tables: imporving table output with fnction 'mytop5()'
  # output$diag <- renderTable({
  #   selected() |> count(diag, wt = weight, sort = TRUE)
  # })
  # output$body_part <- renderTable({
  #   selected() |> count(body_part, wt = weight, sort = TRUE)
  # })
  # output$location <- renderTable({
  #   selected() |> count(location, wt = weight, sort = TRUE)
  # })
  
  output$diag <- renderTable(mytop5(selected(), diag), 
                             width = "100%"
  )
  
  output$body_part <- renderTable(mytop5(selected(), body_part), 
                                  width = "100%"
  )
  
  output$location <- renderTable(mytop5(selected(), location), 
                                 width = "100%"
  )
  
  #Plot
  output$age_sex <- renderPlot({
    if (input$y == 'Count'){
      summary() |> 
        ggplot(aes(age, n, color = sex)) +
        geom_line() +
        labs(y = "Estimated number of injuries")
    } else {
      summary() |> 
        ggplot(aes(age, rate, color = sex)) +
        geom_line() +
        labs(y = "Injuries per 10,000 people")
    }
  })
  
  #story
  narrative_sample <- eventReactive(
    list(input$story, selected()),
    selected() %>% pull(narrative) %>% sample(1)
  )
  output$narrative <- renderText(narrative_sample())
}

  # With option to select Count or Rate:

shinyApp(ui, server)