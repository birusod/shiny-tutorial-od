library(shiny)
library(shinydashboard)
library(tidyverse)
library(scales)
library(lubridate)
library(reactable)
library(plotly)

df <- read_csv('neiss/books.csv') |> 
  mutate(date = mdy(date),
         formattype = factor(formattype),
         pubID = factor(pubID)) |> 
  drop_na()

#formattype <- df |> select(format) |> distinct() |> pull()
#pub <- df |> select(pubID) |> distinct() |> pull()
#language <- df |> select(language) |> distinct() |> pull()

avg_function <- function(data, grp, col){
  df |> 
    group_by({{grp}}) |> 
    summarise(avg = round(mean({{col}}), 0)) |> 
    arrange(desc(avg))
}
#df |> avg_function(formattype, pages)

count_func <- function(data, ctg){
  data |> 
    count({{ctg}}, sort = TRUE)
}
#count_func(df, formattype)

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
    
    fluidRow(
      column(3,
             textInput('pubname', label = 'Enter a publisher name:',
                       placeholder = 'publisher')),
      column(3,
             selectInput('pub', label = 'Publisher', multiple = TRUE,
                         choices = df$pubID |> unique())),
      column(3,
             selectInput('format', label = 'Book format', 
                         choices = df$formattype |> unique())),
      column(3,
             dateRangeInput('dtrange', 'Date range',
                            start = min(df$date), end = max(df$date)))
    ),
    
    fluidRow(
      column(9,
             sliderInput('pages', label = 'Number of pages', 
            min = 10, max = 3000, value = c(200, 800), width = '100%')),
      column(3,
             numericInput('nbin', label = 'Enter number per bins:',
             value = 30))
      ),
            
    fluidRow(
      column(4,
             radioButtons('lang', label = 'Language', 
               choices = df$language |> unique())),
      column(4,
             checkboxInput('chdout', label = 'Checked out', 
                value = TRUE)),
      column(4,
             selectInput('barcat', label = 'Select a categogry',
               choices = c('formattype', 'pubID')))
      ),
  
    fluidRow(
      column(6, dataTableOutput('fmtpage')),
      column(6, dataTableOutput('fmtprice'))
    ),
    
    br(), br(),
    fluidRow(
      column(6, dataTableOutput('pubpage')),
      column(6, dataTableOutput('pubprice'))
    ),
    
    fluidRow(
      column(6, tableOutput('dfhead')),
      column(3, tableOutput('dfcount'), offset = 3)
      ),
    br(), br(),
    
    dataTableOutput('dfall'), #width="125px"
    reactableOutput('dfreact'),
    
    plotOutput('hist'),
    
    fluidRow(
      column(7, plotOutput('barfmt')),
      column(5, plotOutput('scatr'))
    )
    
)
  

server <- function(input, output, session) {
  
  df_filtered <- reactive(
    df |> filter(
      formattype == input$format,
      pages >= input$pages[1] & pages <= input$pages[2])
    )
  
  dfc <-  reactive({count_func(df, formattype)})
  
  df_lang <- reactive(
    df |> filter(
      language == input$lang)
  )
  
  output$fmtpage <- renderDataTable({
    df |> avg_function(formattype, pages) |> 
      rename('BOOK FORMAT' = 1, 'AVERGARE # PAGES' = 2)
  })
  output$pubpage <- renderDataTable({
    df |> avg_function(pubID, pages) |> 
      rename('BOOK PUBLISHER' = 1, 'AVERGARE # PAGES' = 2)
  })
  output$fmtprice <- renderDataTable({
    df |> avg_function(formattype, price) |> 
      mutate(avg = scales::dollar(avg)) |> 
      rename('BOOK FORMAT' = 1, 'AVERGARE PRICE' = 2)
  })
  output$pubprice <- renderDataTable({
    df |> 
      avg_function(pubID, price) |> 
      mutate(avg = dollar(avg)) |> 
      rename('BOOK PUBLISHER' = 1, 'AVERGARE PRICE' = 2)
  })
  
  
  output$dfhead <- renderTable({df_filtered() |> head(4)})
  
  output$dfcount <- renderTable({dfc()})
  
  output$dfall <- renderDataTable(
    df, 
    options = list(pageLength = 4)
    )
  
  output$dfreact <- renderReactable({
    df |> reactable(
      searchable = TRUE,
      striped = TRUE,
      highlight = TRUE,
      bordered = TRUE,
      compact = TRUE,
      height = '300px',
      columns = list(
        formattype = colDef(
          name = 'Format', width = 170, sticky = "left",
          style = list(borderRight = "1px solid #eee"),
          headerStyle = list(borderRight = "1px solid #eee",
                             backgroundColor = "#f7f7f7")
          )
        )
      )
  })
  
  
  
  output$hist <- renderPlot({
    df |> ggplot(aes(price)) +
      geom_histogram(bins = input$nbin, fill = 'dodgerblue', color = 'white') +
      theme_light() 
  })
  
  output$barfmt <- renderPlot({
    if (input$barcat == 'formattype'){
      df |> 
        count_func(formattype)   |> 
        mutate(formattype = fct_reorder(formattype, n)) |> 
        ggplot(aes(formattype, n, fill = formattype)) +
        geom_col(show.legend = FALSE) + theme_light() + 
        labs(x = '', title = 'BOOK DISTRIBUTION BY FORMAT')
    } else {
      df |> 
        count_func(pubID)   |> 
        mutate(pubID = fct_reorder(pubID, n)) |> 
        ggplot(aes(pubID, n, fill = pubID)) +
        geom_col(show.legend = FALSE) + theme_light() + 
        labs(x = '', title = 'BOOK DISTRIBUTION BY PUBLISHER')
    }
  })
  
  output$scatr <- renderPlot({
    df_lang() |> 
      ggplot(aes(pages, price)) + 
      geom_point(size = 4, color = 'tomato') +
      theme_light() + 
      labs(title = 'REALTIONSHIP BETWEEN NUMBER OF PAGES & PRICE', 
           subtitle = 'Select the language to explore:',
           x = 'Nb of Pages', y='Book Price')
  })
}

shinyApp(ui, server)