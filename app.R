library(shiny)
library(shinythemes)
library(ggplot2)
library(readxl)
library(tidyverse)

# Import data
url <- "https://www.dst.dk/ext/2147486843/0/formid/Smitte-med-ny-coronavirus-blandt-elever-i-grundskolen-(excel)--xls"
destfile <- "student-corona-dk.xls"
curl::curl_download(url, destfile)
student_corona_dk <- read_excel(destfile, 6)
names(student_corona_dk) <- c("region", "municipality", "test_week", "total_students", "tested_students", "positive_students")

# User Interface
ui <- fluidPage(theme = shinytheme("united"),
                titlePanel("Covid-19 cases among students in Denmark"),
                sidebarLayout(
                  sidebarPanel(
                    selectInput("region", 
                                label = "Region", 
                                choices=unique(student_corona_dk$region),
                                selected= "Nordjylland"),
                    
                    
                    selectInput("municipality", 
                                label = "Municipality", 
                                choices= c("")
                    )
                  ),
                  mainPanel(
                    
                  ),
                  tags$h3("Data obtained from Danmarks Statistik"),
                  tags$h4(url)
                ),
)

# Server
server <- function(input, output,session) {
  observe({
    x <- input$region
    
    updateSelectInput(session, "municipality", choices = student_corona_dk %>% 
                        filter(region == x) %>% 
                        select(municipality))
  })
  
  
  
  
  
  
  
  
  
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)