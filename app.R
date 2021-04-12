library(shiny)
library(shinythemes)
library(ggplot2)
library(readxl)
library(tidyverse)
library(reshape2)

# Import data
url <- "https://www.dst.dk/ext/2147486843/0/formid/Smitte-med-ny-coronavirus-blandt-elever-i-grundskolen-(excel)--xls"
destfile <- "student-corona-dk.xls"
curl::curl_download(url, destfile)
student_corona_dk <- read_excel(destfile, 6)
names(student_corona_dk) <- c("region", "municipality", "test_week", "total_students", "tested_students", "positive_students")
student_corona_dk <- student_corona_dk %>% mutate(date = as.Date(paste(test_week,'-1',sep=""), format= "%YU%U-%u")) %>% 
  drop_na()


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
                    
                    plotOutput(outputId = "plot"),
                    
                    tags$h5("Data obtained from Danmarks Statistik"),
                    
                    tags$h6(url)
                  )
                  
                ),
)

# Server
server <- function(input, output,session) {
  observe({
    x <- input$region

    updateSelectInput(session, "municipality", choices = c("All", unique(student_corona_dk %>% 
                                                                           filter(region == input$region) %>% 
                                                                           select(municipality))))
  })
  
  

  
    output$plot <- renderPlot({
      student_corona_dk_filter <- student_corona_dk %>% 
        filter(region==input$region & municipality==input$municipality)

      ggplot(student_corona_dk_filter, aes(x=date)) + 
        geom_line(aes(y = tested_students), color="steelblue") +
        geom_line(aes(y = positive_students), color="red") +
        theme_minimal() +
        labs(title = "Covid-19 Cases Among Students in Denmark",
             caption = "Caption can be added") +
        xlab("Date") +
        ylab("Total students")
  })
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)