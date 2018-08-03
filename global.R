## global.r ##

library(data.table)
library(dplyr)

data <- fread(file = "./ACLEDdata.csv")

inter_code <- data.frame("code"=1:8, "inter_desc"=c("Governments and State Security Services", 
                                              "Rebel Groups", 
                                              "Political Militias", 
                                              "Identity Militias",
                                              "Rioters",
                                              "Protesters",
                                              "Civilians",
                                              "External/Other Forces"))


interaction_code <- read.csv("./interation_code..csv")

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
                                                                  ifelse(fatalities<=1000, "501-1000", "More than 1000")))))))

data$event_date <- as.Date(data$event_date, "%d %B %Y")
data$event_type <- toupper(data$event_type)


region_ch <- unique(data$region)
country_ch <- unique(data$country)
admin1_ch <-  unique(data$admin1) 
admin2_ch <- unique(data$admin2)
admin3_ch <- unique(data$admin3)
#location_ch <- unique(data$location)
eventtype_ch <- unique(toupper(data$event_type))
actortype_ch <- unique(inter_code$inter_desc)
fatalities_ch <- c("None", "1-10", "11-50", "51-100", "101-500", "501-1000", "More than 1000")  #unique(data$fatal_category_desc)
