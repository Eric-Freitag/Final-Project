library(tidyverse)
library(scales)

data <- read.csv("R/data/vgsales.csv", stringsAsFactors=FALSE)

length(unique(data$Genre))
salesData <- data %>% 
    pivot_longer(
        cols = ends_with("Sales"),
        names_to = "Region",
        names_pattern = "(.*)_Sales",
        values_to = "Sales"
    )

salesData <- filter(salesData, Year != "N/A")

getGenrePlotData <- function(region, period) {
    start <- min(period)
    end <- max(period)
    plotData <- salesData %>% 
        filter(Region == region, Year >= start, Year <= end) %>% 
        group_by(Genre) %>% 
        summarise(Total_Sales = sum(Sales)) %>% 
        filter(Total_Sales != 0.0)
    return(plotData)
}

getGenrePlot <- function(plotData) {
        plot <- ggplot(plotData, aes(x = Genre, y = Total_Sales)) +
        geom_bar(stat = "identity", fill = "blue") +
        scale_y_continuous(breaks = pretty_breaks()) +
        geom_text(aes(label=Total_Sales), vjust=-0.25, size = 5) +
        labs(x = "Genre", y = "Total sales (in millions)", title = "Video Game Sales By Genre") + 
        theme(
            plot.title = element_text(size=16, face="bold"),
            axis.title = element_text(size=14),
            axis.text = element_text(size=12)
        )
    return(plot)
}



