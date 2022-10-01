library(shiny)
library(tidyverse)
library(reactable)
library(lubridate)
library(plotly)
library(skimr)
library(palmerpenguins)
df <- penguins
ui <- fluidPage(
  ## Inputs
  sliderInput('rng', 'Select a number', min = 0, max = 100, value = 20),
  
  
  ## Outputs
  # Text
  textOutput('hdr'),
  textOutput('ttl'),
  textOutput('rpt'),
  textOutput('stc'),
  textOutput('dyc'),
  verbatimTextOutput('code'),
  tags$h2(tags$style("#hdr{
    color: brown; font-size: 30px; font-style: italic; font-weight: bold;}")),
  tags$h3(tags$style("#ttl{
    color: blue; font-size: 20px; font-style: normal; font-weight: bold;}")),
  tags$h4(tags$style("#stc{
    color: green; font-size: 10px; font-style: normal; font-weight: bold;}")),
  tags$h4(tags$style("#dyc{
    color: green; font-size: 10px; font-style: normal; font-weight: bold;}")),
  
  # Table
  tableOutput('static'),
  dataTableOutput('dynamic'),
  reactableOutput('reactbl1'),
  reactableOutput('reactbl2'),
  
  # Plots
  plotOutput('base'),
  plotOutput('ggp'),
  plotlyOutput('pty')
  
)

server <- function(input, output, session) {
  output$hdr <- renderPrint({
    HTML(paste0("This is a Header"))
  })
 
  output$ttl <- renderText(
    "This is a summary report of the dataset PalmersPinguins:"
  )
   
  output$rpt <- renderText({
    "We are presenting the summary statistics of all 8 columns"
  })
  output$code <- renderPrint({
    df |> skim()
  })
  
  output$stc <- renderText(
    "A static table showing all the data at once: 
    most useful for small, fixed summaries (e.g. model coefficients)"
  )
  output$static <- renderTable({
    df |> head(5)
  })
  output$dyc <- renderText(
    "A dynamic table showing a fixed number of rows along with controls 
    to change which rows are visible. Most appropriate if you want to expose a 
    complete data frame to the user."
  )
  output$dynamic <- renderDataTable(
    df, options = list(pageLength = 8)
  )
  
  output$reactbl1 <- renderReactable({
    df |> 
      reactable(
        searchable = TRUE,
        striped = TRUE,
        highlight = TRUE,
        bordered = TRUE,
        compact = TRUE,
        theme = reactableTheme(
          borderColor = "dodgerblue",
          stripedColor = "#f6f8fa",
          highlightColor = "crimson",
          cellPadding = "8px 6px",
          style = list(fontFamily = "-apple-system, BlinkMacSystemFont, Segoe UI, Helvetica, Arial, sans-serif"),
          searchInputStyle = list(width = "100%")
        )
      )
  })
  
  output$reactbl2 <- renderReactable({
    df |> 
      reactable(
        searchable = TRUE,
        striped = TRUE,
        highlight = TRUE,
        bordered = TRUE,
        compact = TRUE,
        columns = list(
          species = colDef(
            name = 'Species', width = 170, sticky = "left",
            style = list(borderRight = "1px solid #eee"),
            headerStyle = list(borderRight = "1px solid #eee",
                               backgroundColor = "#f7f7f7")))
      )
  })
  
  output$base <- renderPlot({
    plot(1:10, bg = 'cyan', cex = 3, col = 'red', pch=19)
  })
  
  output$ggp <- renderPlot({
    df |> ggplot(aes(bill_length_mm, body_mass_g, color = species)) +
      geom_point(size = 5)+
      labs(title = 'GGPLOT2 SCATTER', color = 'Species',
           x = 'Bill length (mm)', y = 'Body mass (g)') +
      theme_light()
  })
  
  output$pty <- renderPlotly({
    pp <- df |> 
      ggplot(aes(bill_length_mm, body_mass_g, color = species)) +
      geom_point(size = 2) +
      labs(title = 'PLOTLY SCATTER', color = 'Species',
           x = 'Bill length (mm)', y = 'Body mass (g)')
    ggplotly(pp)
  })
  
}

shinyApp(ui, server)