library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(
  
  # Application title.
  titlePanel("First Appearances Calculator"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Find the oldest representative of a group, based on data from the Paleobiology Database"),
      
      textInput("taxon", "Enter a taxon name:","Omaliinae"),
      
      helpText("Warning: large taxonomic groups may require
               a few seconds (or more) to load."),
      
      submitButton("Submit"),
      
      h5("If you use this information in a publication, please acknowledge the Paleobiology Database"),
      
      h6("Comments or suggestions? Email mclapham@ucsc.edu")
                  
    ),

    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Plot", plotOutput("plot"),
                           downloadButton("downloadData", "Download occurrences")
                           ), 
                  tabPanel("Table", h3("Oldest occurrences"),
                           tableOutput("table1"),
                           h3("Oldest occurrences of classified species"),
                           tableOutput("table2"))
        )
    )
  )
))
