library(magrittr)
library(dplyr)
library(ggvis)
library(xlsx)

# import dataset from Measure of America -- lists states and HD number and life expectancy
setwd("/Users/sethmoore/Library/Mobile Documents/com~apple~CloudDocs/Research/Climate v HD")
stateHdData <- read.xlsx("LifeExpectancyHD_Cleaned.xlsx", 1)
stateObesityData <- read.xlsx("obesityByState.xlsx", 1) # Obesity data also contains average temps

#There's a tab at the end of each state -- needs to be removed
stateObesityData$State <- gsub("\t", "", stateObesityData$State)

# Condense HD date down to 50 states - remove different ethnicity groups and gender divisions
# Combine two data frames for easier analysis
stateHdData <- stateHdData %>% filter(Race.Ethnicity == "ALL", Gender == "ALL", Year == 2010) 
stateCombinedData <- merge(stateHdData, stateObesityData, by = "State") %>% subset(select = -c(Gender, Race.Ethnicity))

# Changed this line to get different graphs
stateCombinedData %>% ggvis(~Median.Income, ~HD..Index) %>% layer_points() %>% add_axis("x", title = "Median Income") %>% add_axis("y", title = "Human Development Index", title_offset = 35)

write.xlsx(stateCombinedData, "combinedData.xlsx")

# correlation plot
library(corrplot)
cors <- cor(stateCombinedData[3:8])
corrplot(cors, method = "number", type = "lower")
