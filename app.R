library(shiny)

ui <- fluidPage(
  titlePanel(""),
  sidebarLayout(
    sidebarPanel(
      
      
    )
  ),
  mainPanel(
    
  )
)

server <- function(input, output) {
  
  
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)