#
# ===================================================================
# File name: global.R
# Purpose:   Armed Conflict Events Dashboard Shiny application global file for preprocessing data
# Author:    Soomin Park
# ===================================================================
#

library(data.table)
library(dplyr)
library(stringr)

data <- fread(file = "./ACLEDdata.csv")

inter_code <- data.frame("code"=1:8, "inter_desc"=c("Governments and State Security Services", 
                                              "Rebel Groups", 
                                              "Political Militias", 
                                              "Identity Militias",
                                              "Rioters",
                                              "Protesters",
                                              "Civilians",
                                              "External/Other Forces"))


interaction_code <- read.csv("./interaction_code.csv")

data$event_date <- as.Date(data$event_date, "%d %B %Y")
data$event_type <- str_to_title(data$event_type)

data <-data %>%
  left_join(inter_code, by=c('inter1'='code')) %>%
  left_join(inter_code, by=c('inter2'='code')) %>%
  left_join(interaction_code, by=c('interaction'='code')) %>%
  mutate(event_month = as.Date(data$event_date, "%d %B %Y") %>% format("%m/%Y")) %>%
  mutate(fatal_category = ifelse(fatalities==0, 0, 
                                 ifelse(fatalities<=10, 10, 
                                        ifelse(fatalities<=50, 50,
                                               ifelse(fatalities<=100, 100, 
                                                      ifelse(fatalities<=500, 500, 
                                                             ifelse(fatalities<=1000, 1000, 99999)))))),
         fatal_category_desc = ifelse(fatalities==0, "None", 
                                      ifelse(fatalities<=10, "1-10", 
                                             ifelse(fatalities<=50, "11-50",
                                                    ifelse(fatalities<=100, "51-100", 
                                                           ifelse(fatalities<=500, "101-500", 
                                                                  ifelse(fatalities<=1000, "501-1000", "More than 1000")))))),
         interaction_desc = str_to_title(interaction_desc),
         event_type = str_to_title(event_type), 
         event_type0 = ifelse(grepl('Battle', event_type), 'Battles',
                               ifelse(grepl('Violence Against Civilians', event_type), 'Violence against civilians',
                                      ifelse(grepl('Remote Violence', event_type), 'Remote violence',
                                             ifelse(grepl('Riots', event_type), 'Riots/protests', 'Others')))) 
         )

region_ch <- unique(data$region)
country_ch <- unique(data$country)
country_initial_ch <- unique(data[data$region == "Eastern Africa",]$country) #Initial country selection
admin1_ch <-  unique(data$admin1) 
admin2_ch <- unique(data$admin2)
admin3_ch <- unique(data$admin3)
#location_ch <- unique(data$location)
eventtype_ch <- unique(str_to_title(data$event_type))
actortype_ch <- unique(as.character(inter_code$inter_desc))
fatalities_ch <- c("None", "1-10", "11-50", "51-100", "101-500", "501-1000", "More than 1000")  #unique(data$fatal_category_desc)
