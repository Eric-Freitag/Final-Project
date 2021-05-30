library(shiny)


ui <- fluidPage(
    titlePanel("Video Game Sales"),
    tabsetPanel(
        # Each of us will edit one tab panel
        
        tabPanel("Tab 1"),
        
        tabPanel("Tab 2"),
        
        tabPanel("Developer Histogram",
                 sidebarPanel(
                     sliderInput("nGames",
                                 "Number of Top Games",
                                 min = 5,
                                 max = 500,
                                 value = 100),
                     radioButtons("radio",
                                  "Which Market?",
                                  choices = list("North America" = 1,
                                                 "Europe" = 2,
                                                 "Japan" = 3,
                                                 "Other" = 4,
                                                 "Global" = 5), 
                                  selected = 1),
                     sliderInput("yearRange",
                                 "Years to Select",
                                 min = 1980, 
                                 max = 2016,
                                 value = c(2010, 2015))
                     
                 ),
                 mainPanel(
                     plotOutput("developers")
                 )
        )
    )
)

shinyUI(ui)