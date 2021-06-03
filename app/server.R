library(shiny)
library(dplyr)
library(ggplot2)

vgSales <- read.csv("../app/R/data/vgsales.csv")


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
   
   
    output$caption <- renderText({ 
      paste("The top selling", input$nGames, " games for the years", 
            input$yearRange[1], " to ", input$yearRange[2], " in the selected 
            region were published by ", nrow(publisherData()), "companies.",
            "Among these, ", publisherData()$Publisher[1], "sold the most
            copies from among these top games with", 
            publisherData()$pubSales[1], "million units sold. Second and 
            third place went to ", publisherData()$Publisher[2], " and ",
            publisherData()$Publisher[3], " with ", publisherData()$pubSales[2],
            " and ", publisherData()$pubSales[3], " units sold respectively."
            )
    })
    
    output$note <- renderText({
      paste("Not that this visualization does not plot the total sales in the
            year range and region input by the user. Instead, it finds the top
            games in a year range and location, then sums the sales for those 
            games as grouped by developer. The datast only includes games 
            released on a dedicated gaming platform, (not PC or mobile) which
            sold at least 100,000 copies.")
    })
    
    
    output$publishers <- renderPlot({
      ggplot(publisherData(), aes(x = Publisher, y = pubSales), 
        position = position_dodge(preserve = 'single')) +
        geom_bar(stat='identity', fill = "blue") +
        # x axis labels vertical for space
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1, 
              face="bold"), text=element_text(size=12)) +
        # prevent data labels from being cut off
        expand_limits(y = max(publisherData()$pubSales * 1.10)) + 
        geom_text(aes(label = pubSales), vjust=-0.25, size = 4) +
        labs(title = "Sales Numbers for Publishers of Popular Games",
              x = "Publisher", y = "Sales (millions of units)")
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
      vg <- longRegion %>% 
        filter(Region == input$region1) %>% 
        group_by(Platform) %>% 
        summarise(SalesForEach = sum(Sales))
    })
    
    output$platform_Chart <- renderPlot({
      updateData <- PlatformData()
      updateData %>% 
        ggplot(aes(x = Platform, y = SalesForEach, fill = unique(Platform))) +
        geom_bar(stat = "identity") +
        ylab("Sales of each platform in Millions")
    })
}

shinyServer(server)