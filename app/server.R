library(shiny)
library(dplyr)
library(ggplot2)

vgSales <- read.csv("R/data/vgsales.csv")


# Each of us will source our own R file here
# Notice that the data folder is on the R folder
# Example:

source("R/genre_chart.R")

# Server
server <- function(input, output) {
    # Each of us will get his own input/output variable
    # For example, person who does genre will write:
    # output$genre <- renderPlot([his_function_here])
    output$topGames <- renderPrint({ input$nGames })
    output$market <- renderPrint({ input$radio })
    output$range <- renderPrint({ yearRange })
    developerData <- reactive({
      vgSales %>% 
        filter(Year %in% range(input$range)) %>%
        filter(region == input$radio) %>% 
        arrange(desc(Global_Sales)) %>% 
        head(input$topGames)
      
    })
    
}

shinyServer(server)