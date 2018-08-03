## server.R ##
library(dplyr)
library(leaflet)
library(shinydashboard)
library(DT)
library(ggplot2)
library(shinyWidgets)


shinyServer(function(input, output, session){
  observe({
    updateSelectizeInput(session, 'country_selected', choices = unique(data$country[data$region %in% input$region_selected]))
  })
  observe({
    updateSelectizeInput(session, 'admin1_selected', choices = unique(data$admin1[data$country %in% input$country_selected]))
  })
  

  observeEvent(input$button, {
    selected_data <- data %>%
      filter(region %in% input$region_selected 
             & country %in% input$country_selected # & admin1 %in% input$admin1_selected &
             & toupper(event_type) %in% input$eventtype_selected & inter_desc.x %in% input$actortype_selected 
             & event_date>=input$dates[1] & event_date<=input$dates[2]
             & fatal_category_desc %in% input$fatal_selected
             )
    
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
    
    output$mymap <- renderLeaflet({
      pal <- colorFactor("YlOrRd", map_data$fatal_ctg, n=7)
      #pal <- colorFactor("Dark2", selected_data$event_type)
      leaflet(map_data) %>%
        addTiles() %>%
        addProviderTiles(providers$Esri.WorldTopoMap) %>%
        addCircleMarkers(lat = ~avglat, lng = ~avglng, 
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
        #addLegend(pal=pal, values=~event_type, opacity = 1, title = "Event types")
      
                                 #,clusterOptions = markerClusterOptions())
      # pal <- colorFactor("Dark2", selected_data$event_type)
      # leaflet(selected_data) %>%
      #   addTiles() %>%
      #   addProviderTiles(providers$Esri.WorldStreetMap) %>%
      #   addCircleMarkers(lat = ~latitude, lng = ~longitude, 
      #                    color = ~pal(event_type), 
      #                    radius = ~
      #                    #,clusterOptions = markerClusterOptions()
      #                    ) %>%
      #   addLegend(pal=pal, values=~event_type, opacity = 1, title = "Event types")
      
    })
    
    # observe({
    #   click <- input$mymap_shape_click
    #   sub = selected_data[selected_data$location == input$mymap_shape_click$id, c('country')]
    #   country = sub$country
    #   
    #   if(is.null(click))
    #     return()
    #   else
    #     output$Event_lineplot <- renderPlot(
    #       selected_data %>% 
    #         group_by(event_date, event_type) %>%
    #         summarise(numEvents=n()) %>%
    #         ggplot(aes(x=event_date, y=numEvents, color=event_type, group=1)) + theme_bw() +
    #         geom_line(size=0.6) +
    #         theme(legend.position = "bottom", legend.direction = "horizontal", legend.title = element_blank(),
    #               panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
    #               axis.title.x = element_blank()) +
    #         ylab("Number of events"))
    #     
    # })
    
    output$Event_lineplot <- renderPlot(
       selected_data %>%
        group_by(event_date, event_type) %>%
        summarise(numEvents=n()) %>%
        ggplot(aes(x=event_date, y=numEvents, color=event_type, group=1)) + theme_bw() +
        geom_line(size=0.6) +
        theme(legend.position = "bottom", legend.direction = "horizontal", legend.title = element_blank(),
              panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              axis.title.x = element_blank()) +
        ylab("Number of events"))
  
  # renderPlotly({
  #   print(
  #     ggplotly(selected_data %>% 
  #                group_by(event_date, event_type) %>%
  #                summarise(numEvents=n()) %>%
  #                ggplot(aes(x=event_date, y=numEvents, color=event_type, group=1)) + theme_bw() +
  #                geom_line() +
  #                theme(legend.position = "bottom", legend.direction = "horizontal", legend.title = element_blank(),
  #                      panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
  #                      axis.title.x = element_blank()) +
  #                ylab("Number of events"))
  #   )
  # })
    
    output$Fatal_lineplot <- renderPlot(
      selected_data %>% 
        group_by(event_date, event_type) %>%
        summarise(fatal=sum(fatalities)) %>%
        ggplot(aes(x=event_date, y=fatal, color=event_type, group=1)) + theme_bw() +
        geom_line(size=0.6) +
        theme(legend.position = "bottom", legend.direction = "horizontal", legend.title = element_blank(),
              panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
              axis.title.x = element_blank()) +
        ylab("Fatality")
    )
    
    output$actor_barplot <- renderPlot(
      selected_data %>%
        group_by(actor1) %>%
        summarise(numEvents=n()) %>%
        top_n(15) %>%
        ggplot(aes(x=reorder(actor1, numEvents), y=numEvents, fill=numEvents)) +
        geom_col() +
        coord_flip() +
        scale_fill_gradient(low="blue", high="red") + theme_bw() +
        theme(legend.title = element_blank(),
              panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
              axis.title.y = element_blank()) +
        xlab("Number of events")
    )
    
    output$eventtype_barplot <- renderPlot(
      selected_data %>%
        group_by(event_type) %>%
        summarise(numEvents=n()) %>%
        ggplot(aes(x=reorder(event_type, numEvents), y=numEvents, fill=numEvents)) +
        geom_col() +
        coord_flip() +
        scale_fill_gradient(low="blue", high="red") + theme_bw() +
        theme(legend.title = element_blank(),
              panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
              axis.title.y = element_blank()) +
        xlab("Number of events")
    )
    
    output$selected_data <- DT::renderDataTable({ 
      dt_data <- selected_data %>%
        select('event_date', 'event_type', 'region','country', 'location', 'actor1', 'actor2','fatalities', 'notes')

      datatable(dt_data, 
                class = list('nowrap display', 'hover'),
                width = 12, 
                options = list(
                  scrollX = T, scrollY = T, pageLength = 20, lengthMenu = c(10,20,50,100)
                )
      )
    })
    
    output$map_data <- DT::renderDataTable({ 
      dt_data <- map_data 
      
      datatable(dt_data, 
                class = list('nowrap display', 'hover'),
                width = 12, 
                options = list(
                  scrollX = T, scrollY = T, pageLength = 20, lengthMenu = c(10,20,50,100)
                )
      )
    })
    
  })
})
  
  
  
  
  
