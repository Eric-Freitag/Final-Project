library(shiny)
library(dplyr)
library(ggplot2)

vgSales <- read.csv("../app/R/data/vgsales.csv")


# Each of us will source our own R file here
# Notice that the data folder is on the R folder
# Example:

source("R/genre_chart.R")
source("R/developer_chart.R")

# Server
server <- function(input, output) {
  
    #### ERIC'S PART 
  
    # Each of us will get his own input/output variable
    # For example, person who does genre will write:
    # output$genre <- renderPlot([his_function_here])
  
    publisherData <- reactive({
      longSales %>% 
        filter(Year %in% range(c(input$yearRange[1],input$yearRange[2]))) %>%
        filter(Region == input$radio) %>% 
        arrange(desc(Sales)) %>% 
        head(input$nGames) %>% 
        group_by(Publisher) %>% 
        summarise(pubSales = sum(Sales)) %>% 
        arrange(desc(pubSales))
    })
   
    # publisherData <- longSales %>% 
    #   filter(Year %in% range(c(2000, 2005))) %>%
    #   filter(Region == "Global") %>% 
    #   arrange(desc(Sales)) %>% 
    #   head(100) %>% 
    #   group_by(Publisher) %>% 
    #   summarise(pubSales = sum(Sales)) %>% 
    #   arrange(desc(pubSales))
    output$caption <- renderText({ 
      paste("The top selling", input$nGames, " games for the years", 
            input$yearRange[1], " to ", input$yearRange[2], 
            " were published by ", nrow(publisherData()), "companies.")
    })
    
    
    output$publishers <- renderPlot({
      ggplot(publisherData(), aes(x = Publisher, y = pubSales), 
             position = position_dodge(preserve = 'single')) +
        geom_bar(stat='identity') +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
        # labs(title = "Sales Numbers for Publishers of Popular Games",
        #      # I need a way to tag each bin with the name of the developer"
        #      x = "Publisher",
        #      y = "Sales")
    })
    
    
    #### HUGH'S PART
    gernePlotData <- reactive({getGenrePlotData(input$region, input$period)})
    
    output$genreChart <- renderPlot({
      if (nrow(gernePlotData()) != 0) {
        getGenrePlot(gernePlotData())
      }
    })
    
    output$textChart <- renderText({
      if (nrow(gernePlotData()) == 0) {
        return("There are no genres in the selected subset that have non-trivial sales figures.")
      }
    })
    
    
    #### DAVID's PART
}

shinyServer(server)