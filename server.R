#
# ===================================================================
# File name: server.R
# Purpose:   Armed Conflict Events Dashboard Shiny application server file
# Author:    Soomin Park
# ===================================================================
#

library(dplyr)
library(leaflet)
library(shinydashboard)
library(DT)
library(ggplot2)
library(shinyWidgets)
library(lubridate)
library(plotly)
library(stringr)
library(RColorBrewer)
library(ggmosaic)

shinyServer(function(input, output, session){
  observe({
    updateSelectizeInput(session, 'country_selected', choices = unique(data$country[data$region %in% input$region_selected]),
                         selected = "Somalia")
  })
  
  observeEvent(input$button, {
    # When the button is clicked
    # 1. prepare a large dataset applying the filters that user selected 
    selected_data <- data %>%
      filter(region %in% input$region_selected 
             & country %in% input$country_selected # & admin1 %in% input$admin1_selected &
             & str_to_title(event_type) %in% input$eventtype_selected & inter_desc.x %in% input$actortype_selected 
             & event_date>=input$dates[1] & event_date<=input$dates[2]
             & fatal_category_desc %in% input$fatal_selected
      )
    # a special dataset that will be used in the map
    map_data <- selected_data %>%
      group_by(country, location, event_type) %>%
      summarise(avglat=mean(latitude), avglng=mean(longitude), numEvents=n(), fatal=sum(fatalities)) %>%
      mutate(numEvents_ctg = ifelse(numEvents<10, 2, 
                                    ifelse(numEvents<50, 3,
                                           ifelse(numEvents<100, 5,
                                                  ifelse(numEvents<300, 8, 
                                                         ifelse(numEvents<500, 12, 
                                                                ifelse(numEvents<1000, 17, 25)))))), 
             fatal_ctg = ifelse(fatal==0, 1,
                                ifelse(fatal<10, 2,
                                       ifelse(fatal<50, 3,
                                              ifelse(fatal<100, 5,
                                                     ifelse(fatal<500, 8,
                                                            ifelse(fatal<1000, 10, 15))))))
      )
    
    
    #2. Develop a map - showing the number of events and fatalities on the regions selected. 
    output$mymap <- renderLeaflet({
      pal <- colorFactor("YlOrRd", map_data$fatal_ctg, n=7)
      #pal <- colorFactor("Dark2", selected_data$event_type)
      leaflet(map_data) %>%
        addTiles() %>%
        addProviderTiles(providers$Esri.WorldTopoMap) %>%
        addCircleMarkers(lat = ~avglat, 
                         lng = ~avglng, 
                         color = ~pal(fatal_ctg), 
                         radius = ~numEvents_ctg,
                         #opacity = 1,
                         popup = paste("<b>", map_data$location, "(", map_data$country, ")", "</b>", "<br>",
                                       "Number of Events: ", map_data$numEvents, "<br>", 
                                       "Fatalities: ", map_data$fatal, "<br>"),
                         popupOptions = popupOptions(closeOnClick = TRUE),
                         label = ~location,
                         layerId = ~location
                         #,clusterOptions = markerClusterOptions(),
        ) %>%
        addLegend("bottomright", pal=pal, values=~fatal_ctg,
                  #labels = c("None","1-10","11-50","51-100","101-500","501-1000","More than 1000"), 
                  opacity = 1, title = "Fatalities")
    })
    
    # a monthly dataset that will be used in trend charts
    eventtype_trendchart_data <- reactive({
      # When 'No. of Events' is selected on the radio button, create a dataset aggregated by a number of events.
      if(input$radio == 1) { 
        selected_data %>%
          group_by(event_date=floor_date(event_date, "month"), event_type0) %>%
          summarise(var=n()) %>%
          mutate(vartype = "Number of events")
      }
      # When 'Fatalities' is selected on the radio button, create a dataset aggregated by sum of fatalities.
      else { 
        selected_data %>%
          group_by(event_date=floor_date(event_date, "month"), event_type0) %>%
          summarise(var=sum(fatalities)) %>%
          mutate(vartype = "Fatalities")
      }
    })
    
    actortype_trendchart_data <- reactive({
      # When 'No. of Events' is selected on the radio button, create a dataset aggregated by a number of events.
      if(input$radio == 1) { 
        selected_data %>%
          group_by(event_date=floor_date(event_date, "month"), inter_desc.x) %>%
          summarise(var=n()) %>%
          mutate(vartype = "Number of events")
      }
      # When 'Fatalities' is selected on the radio button, create a dataset aggregated by sum of fatalities.
      else { 
        selected_data %>%
          group_by(event_date=floor_date(event_date, "month"), inter_desc.x) %>%
          summarise(var=sum(fatalities)) %>%
          mutate(vartype = "Fatalities")
      }
    })
    
    # 3. Trend charts (trend of the events by time (months))
    output$Eventtype_trendchart <- renderPlotly({
      trendchart_data = eventtype_trendchart_data()
      p <- trendchart_data %>%
        plot_ly(x = ~event_date, y = ~var, color=~event_type0, mode = 'scatter') %>%
        #hoverinfo = 'text', 
        #text = ~paste0(format(test_data$event_date, format="%b %Y"), " : ", numEvents)
        layout(
          xaxis = list(title=""),
          yaxis = list(title=trendchart_data$vartype[1])
          #legend = list(orientation="h", x=0.1, y=-0.1)
        )
      p
    })
    
    output$actortype_trendchart <- renderPlotly({
      trendchart_data = actortype_trendchart_data()
      p <- trendchart_data %>%
        plot_ly(x = ~event_date, y = ~var, color=~inter_desc.x, mode = 'scatter') %>%
        #hoverinfo = 'text', 
        #text = ~paste0(format(test_data$event_date, format="%b %Y"), " : ", numEvents)
        layout(
          xaxis = list(title=""),
          yaxis = list(title=trendchart_data$vartype[1])
        )
    })
    
    # 4. Bar plots showing No. of events or fatalities for each actor types/actors(top 10)
    output$actortype_barplot <- renderPlot({
      actortype_barchart_data <- reactive({
        # When 'No. of Events' is selected on the radio button, create a dataset aggregated by a number of events.
        if(input$radio == 1) { 
          selected_data %>%
            group_by(inter_desc.x) %>%
            summarise(var=n()) %>%
            top_n(10) %>%
            mutate(vartype = "Number of events")
        }
        # When 'Fatalities' is selected on the radio button, create a dataset aggregated by sum of fatalities.
        else { 
          selected_data %>%
            group_by(inter_desc.x) %>%
            summarise(var=sum(fatalities)) %>%
            top_n(10) %>%
            mutate(vartype = "Fatalities")
        }
      })
      actortype_barchart_data <- actortype_barchart_data() 
      actortype_barchart_data %>%
        ggplot(aes(x=reorder(str_wrap(inter_desc.x, 40), var), y=var, fill=var)) +
        geom_col() +
        coord_flip() +
        scale_fill_gradient(low="seashell3", high="firebrick") + theme_bw() +
        theme(legend.title = element_blank(),
              panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              axis.title.x = element_blank(),
              axis.title.y = element_blank(),
              axis.text.y = element_text(colour="grey20",size=11)) +
        ylab(actortype_barchart_data$vartype[1])
    })
    
    output$actor_barplot <- renderPlot({
      # Create datasets for the bar plots
      actor_barchart_data <- reactive({
        # When 'No. of Events' is selected on the radio button, create a dataset aggregated by a number of events.
        if(input$radio == 1) { 
          selected_data %>%
            group_by(actor1) %>%
            summarise(var=n()) %>%
            top_n(10) %>%
            mutate(vartype = "Number of events")
        }
        # When 'Fatalities' is selected on the radio button, create a dataset aggregated by sum of fatalities.
        else { 
          selected_data %>%
            group_by(actor1) %>%
            summarise(var=sum(fatalities)) %>%
            top_n(10) %>%
            mutate(vartype = "Fatalities")
        }
      })
      actor_barchart_data <- actor_barchart_data() 
      actor_barchart_data %>%
        ggplot(aes(x=reorder(str_wrap(actor1, 40), var), y=var, fill=var)) +
        geom_col() +
        coord_flip() +
        scale_fill_gradient(low="seashell3", high="firebrick") + theme_bw() +
        theme(legend.title = element_blank(),
              panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              axis.title.x = element_blank(),
              axis.title.y = element_blank(),
              axis.text.y = element_text(colour="grey20",size=11)) +
        ylab(actor_barchart_data$vartype[1])
    })
    
    
    # 5. Pie chart and Bar plot showing No. of events or fatalities for each event types/detailed event types
    output$eventtype_piechart <- renderPlotly({
      eventtype_piechart_data <- reactive({
        # When 'No. of Events' is selected on the radio button, create a dataset aggregated by a number of events.
        if(input$radio == 1) { 
          selected_data %>%
            group_by(event_type0) %>%
            summarise(var=n()) %>%
            mutate(vartype = "Number of events")
        }
        # When 'Fatalities' is selected on the radio button, create a dataset aggregated by sum of fatalities.
        else { 
          selected_data %>%
            group_by(event_type0) %>%
            summarise(var=sum(fatalities)) %>%
            mutate(vartype = "Fatalities")
        }
      })
      colors <- c('rgb(211,94,96)', 'rgb(128,133,133)', 'rgb(144,103,167)', 'rgb(171,104,87)', 'rgb(114,147,203)')
      
      eventtype_piechart_data <- eventtype_piechart_data()
      p <- eventtype_piechart_data %>%
        arrange(desc(var)) %>%
        plot_ly(values = ~var, labels = ~str_wrap(event_type0, 20), type='pie', 
                textposition='inside', textinfo='label+percent', insidetextfont = list(color = '#FFFFFF'),
                marker = list(colors = colors, line = list(color = '#FFFFFF', width = 1)),
                showlegend=F) %>%
        layout(
          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE)
        )
      p
    })

    output$eventtype_barplot <- renderPlotly({
      eventtype_barplot_data <- reactive({
        # When 'No. of Events' is selected on the radio button, create a dataset aggregated by a number of events.
        if(input$radio == 1) { 
          selected_data %>%
            group_by(event_type0, event_type) %>%
            summarise(var=n()) %>%
            mutate(vartype = "Number of events")
        }
        # When 'Fatalities' is selected on the radio button, create a dataset aggregated by sum of fatalities.
        else { 
          selected_data %>%
            group_by(event_type0, event_type) %>%
            summarise(var=sum(fatalities)) %>%
            mutate(vartype = "Fatalities")
        }
      })
      barplot_data <- eventtype_barplot_data()
      p <- barplot_data %>%
        plot_ly(y = ~var, x=~event_type0, color=~event_type, type='bar',
                colors = 'Set2') %>%
        layout(barmode='stack',
               xaxis = list(title=""),
               yaxis = list(barplot_data$vartype[1]),
               showlegend=F
        )
      p
    })
    
    output$interaction_barcharts <- renderPlotly({
      temp_data <- selected_data %>%
        group_by(interaction, interaction_desc) %>%
        summarise(count = n(), fatal = sum(fatalities)) %>%
        arrange(desc(count)) %>% head(15)
      
      p1 <- temp_data %>%
        plot_ly(x=~count, y=~reorder(interaction_desc, count), type='bar', orientation='h', 
                name = 'No. of events',
                marker = list(color = 'rgba(50, 171, 96, 0.6)',
                              line = list(color = 'rgba(50, 171, 96, 1.0)', width = 1))) %>%
        layout(yaxis = list(showgrid = FALSE, showline = FALSE, showticklabels = TRUE),
               xaxis = list(zeroline = FALSE, showline = FALSE, showticklabels = TRUE, showgrid = TRUE))
      
      p2 <- temp_data %>%
        plot_ly(x=~fatal, y=~reorder(interaction_desc, count), type='bar', orientation='h', 
                name = 'Total fatalities',
                marker = list(color = 'tomato',
                              line = list(color = 'firebrick', width = 1))) %>%
        layout(yaxis = list(showgrid = FALSE, showline = TRUE, showticklabels = FALSE,
                            linecolor = 'rgba(102, 102, 102, 0.8)', linewidth = 2, 
                            domain = c(0, 10)),
               xaxis = list(zeroline = FALSE, showline = FALSE, showticklabels = TRUE, showgrid = TRUE,
                            dtick = 20000))

      p <- subplot(p1, p2) %>%
        layout(legend = list(x = -0.1, y = 100, font = list(size = 10), orientation='h')
               #margin = list(l = 100, r = 20, t = 70, b = 70)
               )
      p
    })

    
    output$interaction_mosaicplot <- renderPlot({
      selected_data %>%
        mutate(inter_desc.x = str_wrap(inter_desc.x, 15), 
               inter_desc.y = str_wrap(inter_desc.y, 15), 
               region = str_wrap(region, 15)) %>%
        ggplot() + 
        geom_mosaic(aes(x=product(inter_desc.y, inter_desc.x), na.rm=T, fill=inter_desc.x)) +
        #labs(fill = "") +
        xlab("Actor 1") + ylab("Actor 2") +
        theme(axis.text.x  = element_text(angle=0, vjust=0.8), 
              legend.position = 'none')
    })

    output$selected_data <- DT::renderDataTable({ 
      dt_data <- selected_data %>%
        select('event_date', 'event_type', 'region','country', 'location', 'actor1', 'actor2','fatalities', 'notes')
      
      datatable(dt_data, 
                class = list('nowrap display', 'hover'),
                width = 12, 
                options = list(
                  scrollX = T, scrollY = T, pageLength = 20, lengthMenu = c(20,50,100)
                )
      )
    })
  }, ignoreNULL = FALSE)
})



# output$eventtypes_barplot <- renderPlot({
#   selected_data %>%
#     group_by(event_type) %>%
#     summarise(numEvents=n()) %>%
#     ggplot(aes(x=reorder(str_wrap(event_type, 25), numEvents), y=numEvents, fill=numEvents)) +
#     geom_col() +
#     coord_flip() +
#     scale_fill_gradient(low="seashell3", high="firebrick") + theme_bw() +
#     theme(legend.title = element_blank(),
#           panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
#           axis.title.x = element_blank(),
#           axis.title.y = element_blank(),
#           axis.text.y = element_text(colour="grey20",size=12)
#     ) +
#     ylab("Number of events")
# })

# output$pie_chart <- renderPlotly({
#   if (input$variable == 'Event Type') {
#     data <- selected_data %>%
#       group_by(event_type0) %>%
#       summarise(numEvents=n()) %>%
#       arrange(desc(numEvents)) %>%
#       rename('col'='event_type0')
#   }
#   else if (input$variable == 'Actor Type') {
#     data <- selected_data %>%
#       group_by(inter_desc.x) %>%
#       summarise(numEvents=n()) %>%
#       arrange(desc(numEvents))%>%
#       rename('col'='inter_desc.x')
#   }
#   else if (input$variable == 'Region') {
#     data <- selected_data %>%
#       group_by(region) %>%
#       summarise(numEvents=n()) %>%
#       arrange(desc(numEvents))%>%
#       rename('col'='region')
#   }
#   else {
#     data <- selected_data %>%
#       group_by(country) %>%
#       summarise(numEvents=n()) %>%
#       arrange(desc(numEvents))%>%
#       rename('col'='country')
#   }
#   
#   p <- data %>%
#     plot_ly(values = ~numEvents, labels = ~str_wrap(col, 20), type='pie', 
#             textposition='inside', textinfo='label+percent', insidetextfont = list(color = '#FFFFFF'),
#             marker = list(colors = brewer.pal(9, "Set2"), line = list(color = '#FFFFFF', width = 1)),
#             showlegend=F) %>%
#     layout(
#       xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
#       yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE)
#     )
#   p
# })
