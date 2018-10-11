#
# ===================================================================
# File name: ui.R
# Purpose:   Armed Conflict Events Dashboard Shiny application UI file
# Author:    Soomin Park
# ===================================================================
#

library(shinydashboard)
library(leaflet)
library(DT)
#library(shinythemes)
library(shinyWidgets)
library(plotly)
library(markdown)

shinyUI(
  dashboardPage (skin = "black",
  dashboardHeader(title = "Armed Conflict Events Dashboard", 
                  titleWidth = 400),
  dashboardSidebar(width=300,
      #disable = TRUE
      #h4("Filters"),
      pickerInput("region_selected", "Region", region_ch, multiple=T, options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"), selected = 'Eastern Africa'),
      pickerInput("country_selected", "Country", country_ch, multiple=T, options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"), selected = country_initial_ch),
      pickerInput("eventtype_selected", "Event Type", eventtype_ch, multiple=T, options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"), selected = eventtype_ch),
      pickerInput("actortype_selected", "Actor Type", actortype_ch, multiple=T, options = list(`actions-box` = TRUE, size = 10), selected = actortype_ch),
      #selectizeInput("region_selected", "Region", region_ch, multiple=F),
      #selectizeInput("country_selected", "Country", "", multiple=TRUE),
      #selectizeInput("admin1_selected", "States/Provinces", "", multiple=TRUE),
      #selectizeInput("eventtype_selected", "Event Type", eventtype_ch, multiple=TRUE),
      #selectizeInput("actortype_selected", "Actor Type", actortype_ch, multiple=TRUE),
      dateRangeInput("dates", label = ("Date range"), start = min(data$event_date), end = max(data$event_date), 
                     min = min(data$event_date), max = max(data$event_date)),
      pickerInput("fatal_selected", "Fatalities", fatalities_ch, multiple=T, options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"), selected = fatalities_ch),
      #sliderInput("fatalities", label = "fatalities", min = 0, 
        #          max = max(data$fatalities), value = c(0, max(data$fatalities))),
      actionButton("button", label = "Submit")
  ),
    
  dashboardBody(
    tabsetPanel(type = "tabs",
                tabPanel("About", 
                         fluidRow(
                           box(
                             width = 12,   
                             includeMarkdown("AppDescription.md")
                           )
                         )
                ),
                tabPanel("Dashboard", 
                        fluidRow(
                          box(#title = "Global Map", 
                              #background = "aqua", 
                              solidHeader = T, width = 12,
                            #dataTableOutput("mymap")
                            #verbatimTextOutput("mymap")
                            leafletOutput("mymap",  height = 450)
                            )
                        ),
                        
                        radioButtons("radio", label = NULL, choices = list("Number of Events"=1, "Fatalities"=2), 
                                     selected = 1, inline = T ),
                        # # The radio buttons (for selecting no.of events or fatalities) are only shown when the submit button is clicked(active).
                        # conditionalPanel(
                        #   condition = "input.button > 0", 
                        #   radioButtons("radio", label = NULL, choices = list("Number of Events"=1, "Fatalities"=2), 
                        #                selected = 1, inline = T )
                        # ),
                        fluidRow(
                          tabBox(
                            id = "tabbox1", width = 12, #height = "250px",
                            tabPanel("Event Type Trend", 
                                     plotlyOutput("Eventtype_trendchart", height = 300)),
                            tabPanel("Actor Type Trend",
                                     plotlyOutput("actortype_trendchart", height = 300))
                            )
                        ),
                        fluidRow(
                          tabBox(
                            tabPanel("Actor Types", 
                                     plotOutput("actortype_barplot", height = 300)), 
                            tabPanel("Top 10 Actors", 
                                     plotOutput("actor_barplot", height = 300))
                          ),
                          tabBox(
                            tabPanel("Event Types", 
                                     plotlyOutput("eventtype_piechart", height = 300)),
                            tabPanel("Detailed Event Types", 
                                     plotlyOutput("eventtype_barplot", height = 300))
                          )
                        ),
                        fluidRow(
                          box(
                            title = "Interaction - No. of events VS. fatalities", 
                            solidHeader = T, width = 7,
                            plotlyOutput("interaction_barcharts",  height = 450)
                          ),
                          box(
                            title = "Interaction Scale",
                            solidHeader = T, width = 5,
                            plotOutput("interaction_mosaicplot", height = 450)
                          )
                        )
                ),
                
                tabPanel("Impact Analysis",
                          fluidRow(
                            # pie graphs for various variables
                            box(#title = "Global Map", 
                              #background = "aqua", 
                              solidHeader = T, width = 6,
                              selectInput(inputId = "variable",
                                          label = "Select category: ",
                                          choices = c('Event Type', 'Actor Type', 'Region', 'Country'),
                                          selected = 'Event Type', 
                                          width = '50%'),
                              plotlyOutput("pie_chart")
                            )
                          )
                          ),
                
                tabPanel("Data table",
                           box(DT::dataTableOutput("selected_data"), width = 12)
                         )
    )
    )
))








