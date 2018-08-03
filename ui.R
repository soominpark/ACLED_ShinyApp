## ui.R ##

library(shinydashboard)
library(leaflet)
library(DT)
#library(shinythemes)
library(shinyWidgets)

shinyUI(dashboardPage (skin = "black",
  dashboardHeader(title = "Armed Conflict Events Dashboard", 
                  titleWidth = 400),
  dashboardSidebar(width=300,
      #disable = TRUE
      #h4("Filters"),
      pickerInput("region_selected", "Region", region_ch, multiple=T, options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3")),
      pickerInput("country_selected", "Country", country_ch, multiple=T, options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3")),
      pickerInput("eventtype_selected", "Event Type", eventtype_ch, multiple=T, options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3")),
      pickerInput("actortype_selected", "Actor Type", actortype_ch, multiple=T, options = list(`actions-box` = TRUE, size = 10)),
      #selectizeInput("region_selected", "Region", region_ch, multiple=F),
      #selectizeInput("country_selected", "Country", "", multiple=TRUE),
      #selectizeInput("admin1_selected", "States/Provinces", "", multiple=TRUE),
      #selectizeInput("eventtype_selected", "Event Type", eventtype_ch, multiple=TRUE),
      #selectizeInput("actortype_selected", "Actor Type", actortype_ch, multiple=TRUE),
      dateRangeInput("dates", label = ("Date range"), start = '2001-01-01'),
      pickerInput("fatal_selected", "Fatalities", fatalities_ch, multiple=T, options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3")),
      #sliderInput("fatalities", label = "fatalities", min = 0, 
        #          max = max(data$fatalities), value = c(0, max(data$fatalities))),
      actionButton("button", label = "Submit")
  ),
    
  dashboardBody(
    tabsetPanel(type = "tabs",
                tabPanel("Dashboard", 
                        fluidRow(
                          box(#title = "Global Map", 
                              #background = "aqua", 
                              solidHeader = T, width = 12,
                            #dataTableOutput("mymap")
                            #verbatimTextOutput("mymap")
                            leafletOutput("mymap",  height = 700)
                            )
                        ),
                        fluidRow(
                          tabBox(
                            id = "tabbox1", #height = "250px",
                            tabPanel("Event", 
                                     plotOutput("Event_lineplot")),
                            tabPanel("Fatalities",
                                     plotOutput("Fatal_lineplot"))
                            ),
                          
                          tabBox(
                            tabPanel("Actors", 
                                     plotOutput("actor_barplot")),
                            tabPanel("Event Types",
                                     plotOutput("eventtype_barplot"))
                          )
                        )
                ),
                
                tabPanel("Data table",
                           box(DT::dataTableOutput("selected_data"), width = 12)
                         )
                
                ,tabPanel("Terminology"
                         #, box(DT::dataTableOutput("map_data"), width = 12)
                         
                )
    )
  
    )
))








