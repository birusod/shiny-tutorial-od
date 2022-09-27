# **********************************************************************
#                          MASTERING SHINY 
#                          Hadley Wickham
#                              2020


## Preface:-------------------------------------------------------------

# Package installation:

install.packages(c(
  "gapminder", "ggforce", "gh", "globals", "openintro", "profvis", 
  "RSQLite", "shiny", "shinycssloaders", "shinyFeedback", 
  "shinythemes", "testthat", "thematic", "tidyverse", "vroom", 
  "waiter", "xml2", "zeallot" 
))



## First Shiny App: ----------------------------------------------------



# library(shiny)
# There 2 ways to create a shiny app:
# - new dir + app.R file in 1 step: File > New Project > dir > Shiny Web Application 
# - file > New file > app.r (app.R file ready, use boilerplate:  “shinyapp” +  Shift+Tab)y typing “shinyapp” and pressing Shift+Tab.





# There are a few ways you can run this app:

  # Click the Run App (Figure 1.1) button in the document toolbar.
  # Use a keyboard shortcut: Cmd/Ctrl + Shift + Enter.
  # If Not in RStudio: 
      # (source()) the whole document, or 
      # call shiny::runApp() with the path to the dir containing app.R


# To stop the app, choose one of these options:

  # - Click the stop sign icon on the R console toolbar.
  # - Click on the console, then press Esc (Ctrl + C if using RStudio).
  # - Close the Shiny app window.




# Learning points:
 # - How to create, modify basic shiny app to make it reactive to user input.