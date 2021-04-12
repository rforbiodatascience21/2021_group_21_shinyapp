library(shiny)
library(shinythemes)
library(ggplot2)
#library(tidyverse)

ui <- fluidPage(theme = shinytheme("united"),
  titlePanel("Covid-19 cases among students in Denmark"),
  sidebarLayout(
    sidebarPanel(
      selectInput("region", 
                  label = "Region", 
                  choices=unique(df$region)),
      
      selectInput("kom", 
                  label = "Municipality", 
                  choices= df %>% filter('region' == input$region) %>% 
                    select('kom') %>% distinct()
                    )
    ),
    mainPanel(
      
    )
  ),
)

server <- function(input, output) {
  
  
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)