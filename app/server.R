library(shiny)
library(dplyr)
library(ggplot2)

vgSales <- read.csv("R/data/vgsales.csv")


# Each of us will source our own R file here
# Notice that the data folder is on the R folder
# Example:

source("R/genre_chart.R")
source("R/developer_chart.R")
source("R/platform_chart.R")
# Server
server <- function(input, output) {
  
    #### ERIC'S PART 
  
    # Each of us will get his own input/output variable
    # For example, person who does genre will write:
    # output$genre <- renderPlot([his_function_here])
  
    # I do not know of a way to put reactive({}) in a helper file
    # If so I could clean this up quite a bit
    publisherData <- reactive({
      longSales %>% 
        filter(Year %in% range(input$yearRange)) %>%
        filter(Region == input$radio) %>% 
        arrange(desc(Sales)) %>% 
        head(input$topGames) %>% 
        group_by(Publisher) %>% 
        summarise(pubSales = sum(Sales)) %>% 
        arrange(desc(pubSales))
    })
    # I should use renderUI/uiOutput right?
    # Getting same: "Warning: Error in checkHT: invalid 'n' -
    # must contain at least one non-missing element, got none."
    # when I called the other way with slider input in UI.
    # does this indicate a problem with my plot not my shiny?
    output$topGames <- renderUI({ sliderInput("nGames",
                                              "Number of Top Games",
                                              min = 5,
                                              max = 500,
                                              value = 100) })
    output$market <- renderUI({ radioButtons("radio",
                                             "Which Market?",
                                             choices = list("North America" = 1,
                                                            "Europe" = 2,
                                                            "Japan" = 3,
                                                            "Other" = 4,
                                                            "Global" = 5),
                                                            selected = 1) })
    output$range <- renderUI({ sliderInput("yearRange",
                                           "Years to Select",
                                           min = 1980, 
                                           max = 2016,
                                           value = c(2010, 2015)) })
    
    
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
    PlatformData <- reactive({
      vg <- filter(longRegion, input$region == Region)
      return(vg)
    })
    
    output$platformChart <- renderPlot({
      updateData <- PlatformData()
      updateData %>% ggplot(aes(x = Platform, y = Sales))
      geom_bar()
    })
}

shinyServer(server)