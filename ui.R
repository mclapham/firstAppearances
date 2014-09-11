library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(
  
  # Application title.
  titlePanel("First Appearances Calculator"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("taxon", "Enter a taxon name:","Omaliinae"),
      
      helpText("Warning: large taxonomic groups may require
               a few seconds (or minutes) to load."),
      
      submitButton("Submit")
              
    ),

    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Plot", plotOutput("plot")), 
                  tabPanel("Table", h3("Oldest occurrences"),
                           tableOutput("table1"),
                           h3("Oldest occurrences of classified species"),
                           tableOutput("table2"))
        )
    )
  )
))
