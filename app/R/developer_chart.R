vgSales <- read.csv("R/data/vgsales.csv")
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