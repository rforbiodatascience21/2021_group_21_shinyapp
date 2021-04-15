library(shiny)
library(shinythemes)
library(ggplot2)
library(readxl)
library(tidyverse)
library(reshape2)
library(rsconnect)


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
                titlePanel("Covid-19 Cases Among Students in Denmark"),
                sidebarLayout(
                  sidebarPanel(
                    selectInput("region", 
                                label = "Region", 
                                choices=c("All",unique(student_corona_dk$region)),
                                selected= "All"),
                    
                    
                    selectInput("municipality", 
                                label = "Municipality", 
                                choices= c("")
                    )
                  ),
                  mainPanel(
                    
                    plotOutput(outputId = "plot"),
                    
                    tags$h5("Data obtained from Danmarks Statistik"),
                    
                    tags$style(type="text/css",
                               ".shiny-output-error { visibility: hidden; }",
                               ".shiny-output-error:before { visibility: hidden; }"
                    )
                    
                  )
                  
                ),
)

# Server
server <- function(input, output,session) {
  observe({
    
    x <- input$region
    
    if (x == "All") {
      updateSelectInput(session, "municipality", choices = c("All"))
    } else {
      updateSelectInput(session, "municipality", choices = c("All", unique(student_corona_dk %>% 
                                                                             filter(region == input$region) %>% 
                                                                             select(municipality))))
    }

    updateSelectInput(session, "municipality", choices = c("All", unique(student_corona_dk %>% 
                                                                           filter(region == input$region) %>% 
                                                                           select(municipality))))
  })
  
    output$plot <- renderPlot({
      
      if (input$municipality == "All" & input$region == "All") {
        student_corona_dk_filter <- student_corona_dk
      }
      
      if (input$municipality == "All" & input$region != "All") {
        student_corona_dk_filter <- student_corona_dk %>% 
          filter(region==input$region)
      }
      
      if (input$municipality != "All" & input$region != "All") {
        student_corona_dk_filter <- student_corona_dk %>% 
          filter(region==input$region & municipality==input$municipality)
      } 
      

      ggplot(student_corona_dk_filter, aes(x=date)) + 
        geom_line(aes(y = tested_students, color="royalblue3")) +
        geom_line(aes(y = positive_students,color="red")) +
        scale_color_identity(name = "Line",
                             breaks = c("royalblue3", "red"),
                             labels = c("Tested Students", "Positive Students"),
                             guide = "legend")+
        theme_minimal() +
        labs(title = "Covid-19 Cases Among Students in Denmark",
             caption = url) +
        xlab("Date") +
        ylab("Total students")
  })
}


# Create Shiny App
shinyApp(ui = ui, server = server)


# Publish at Shiny App
