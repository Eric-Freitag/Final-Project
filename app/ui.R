library(shiny)
library(shinythemes)

ui <- fluidPage(
    theme = shinytheme("sandstone"),
    titlePanel("Video Game Sales"),
    tabsetPanel(
        # Each of us will edit one tab panel
        
        tabPanel("Tab 1"),
        
        
        #### HUGH
        tabPanel(
            "Genre comparision",
            
            sidebarLayout(
                sidebarPanel(
                    radioButtons("region", label = h3("Select a region"),
                                 choices = list("North America" = "NA",
                                                "Europe" = "EU",
                                                "Japan" = "JP",
                                                "Other" = "Other",
                                                "Global" = "Global")
                    ),
                    
                    hr(),
                    
                    sliderInput("period", label = h3("Select time frame"),
                                min = 1980, max = 2020, value = c(1980, 2020))
                ),
                
                mainPanel(h4(textOutput("textChart")), plotOutput("genreChart"))
            ),
            
            br(),
            
            h4(strong("Note: dataset only contains video games with sales greater than 100,000 copies")),
            
            h4("According to our data, platform in general was the most popular genre in the pre-2000 era.
               The Super Mario franchise seemed to be the greatest contributor to this trend. However, after 2000,
               action is considered to be the most dominant genre globally. I think the reason for this trend is that
               having good combat or good story-telling is appeal to a lot of people regardless of ages."),
            
            h4("Another thing we can see from the graph is that, after 2000, puzzle and strategy, in general, have lower sales
               compare to other genres, which is expected since those two are kind of niche genres. Not a lot of people find it fun to
               play games that require a lot of thinking."),
            
            h4("One interesting thing is that even though action genre is still the most popular genre globally after 2015,
               shooter genre follows very closely. In North America, shooter genre actually has roughly 33% more sales than 
               action genres. The Call of Duty franchises is the biggest contributor to this trend in North America.")
        ),
        
        
        #### ERIC
        tabPanel("Publisher Histogram",
                 sidebarPanel(
                     sliderInput("nGames",
                                 "Number of Top Games",
                                 min = 5,
                                 max = 500,
                                 value = 100),
                     radioButtons("radio",
                                  "Which Market?",
                                  choices = list("North America" = "North America",
                                                 "Europe" = "Europe",
                                                 "Japan" = "Japan",
                                                 "Other" = "Other",
                                                 "Global" = "Global"),
                                 selected = "North America"),
                     sliderInput("yearRange",
                                 "Years to Select",
                                 min = 1980, 
                                 max = 2016,
                                 value = c(2010, 2015))
                 ),
                 
                 mainPanel(
                     plotOutput("publishers"),
                     textOutput("selected_var")
                     
                 )
        )
    )
)

shinyUI(ui)