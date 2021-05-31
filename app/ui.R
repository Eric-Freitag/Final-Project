library(shiny)


ui <- fluidPage(
    titlePanel("Video Game Sales"),
    tabsetPanel(
        # Each of us will edit one tab panel
        
        tabPanel("Tab 1"),
        
        tabPanel("Tab 2"),
        
        tabPanel("Publisher Histogram",
                 sidebarPanel(
                     uiOutput("topGames"),
                     uiOutput("market"),
                     uiOutput("range")             
                 ),
                 
                 mainPanel(
                     plotOutput("publishers")
                 )
        )
    )
)

shinyUI(ui)