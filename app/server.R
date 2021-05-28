library(shiny)

# Each of us will source our own R file here
# Notice that the data folder is on the R folder
# Example:

source("R/genre_chart.R")

# Server
server <- function(input, output) {
    # Each of us will get his own input/output variable
    # For example, person who does genre will write:
    # output$genre <- renderPlot([his_function_here])
    
}

shinyServer(server)