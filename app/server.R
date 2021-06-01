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
    # I should use renderUI/uiOutput right?
    # Getting same: "Warning: Error in checkHT: invalid 'n' -
    # must contain at least one non-missing element, got none."
    # when I called the other way with slider input in UI.
    # does this indicate a problem with my plot not my shiny?
   
    # publisherData <- longSales %>% 
    #   filter(Year %in% range(c(2000, 2005))) %>%
    #   filter(Region == "Global") %>% 
    #   arrange(desc(Sales)) %>% 
    #   head(100) %>% 
    #   group_by(Publisher) %>% 
    #   summarise(pubSales = sum(Sales)) %>% 
    #   arrange(desc(pubSales))
    output$selected_var <- renderText({ 
      paste("You have selected", input$radio)
    })
    
    
    output$publishers <- renderPlot({
      ggplot(publisherData(), aes(x = pubSales, col = Publisher)) +
        geom_histogram() +
        labs(title = "Sales Numbers for Publishers for Popular Games",
             # I need a way to tag each bin with the name of the developer"
             x = "Publisher",
             y = "Sales")
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