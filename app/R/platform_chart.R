library(tidyverse)
library(tidyr)

vgdata <- read.csv("R/data/vgsales.csv")

renameVG<- vgdata
colnames(renameVG)[colnames(renameVG)
                        %in% c("NA_Sales","EU_Sales",
                               "JP_Sales","Other_Sales",
                               "Global_Sales")] <- c(
                                 "North America",
                                 "Europe",
                                 "Japan",
                                 "Other",
                                 "Global"
                               )

longRegion <- pivot_longer(renameVG, 7:11,
                          names_to="Region",values_to="Sales")

