vgSales <- read.csv("R/data/vgsales.csv")

# Rename column using basic R: an exercise in clunkiness :)
renameVgSales <- vgSales
colnames(renameVgSales)[colnames(renameVgSales)
                        %in% c("NA_Sales","EU_Sales",
                               "JP_Sales","Other_Sales",
                               "Global_Sales")] <- c(
                                 "North America",
                                 "Europe",
                                 "Japan",
                                 "Other",
                                 "Global"
                               )
                       
longSales <- pivot_longer(renameVgSales, 7:11,
                          names_to="Region",values_to="Sales")

# This does not get the total sales for the top publishers in yearRange.
# Instead it gets the sales for the top X games and groups them by publisher.
# Then it computes the sum of sales for each publisher in the top X games

publisherData <- longSales %>% 
    filter(Year %in% range(c(2000, 2005))) %>%
    filter(Region == "Global") %>% 
    arrange(desc(Sales)) %>% 
    head(100) %>% 
    group_by(Publisher) %>% 
    summarise(pubSales = sum(Sales)) %>% 
    arrange(desc(pubSales))