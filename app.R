library(shiny)
library(shinythemes)
library(ggplot2)
library(readxl)
#library(tidyverse)

# How to import data
url <- "https://www.dst.dk/ext/2147486843/0/formid/Smitte-med-ny-coronavirus-blandt-elever-i-grundskolen-(excel)--xls"
destfile <- "student-corona-dk.xls"
curl::curl_download(url, destfile)
student_corona_dk <- read_excel(destfile,6)


ui <- fluidPage(theme = shinytheme("united"),
  titlePanel("Covid-19 cases among students in Denmark"),
  sidebarLayout(
    sidebarPanel(
      selectInput("region", label = "Region", choices=unique(df$region))
      
    ),
    mainPanel(
      
    )
  ),
)

server <- function(input, output) {
  
  
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)