library(shiny)

shinyServer(function(input, output, session){
    values = reactiveValues()
    
    ################################################################################################################################################################
    # Map of renewable energy projects #############################################################################################################################
    
    # Map color palette
    mapPalette = colorFactor(c("brown", "red", "#add8e6", "orange", "#00008B", "green"), c("Biomass", "Geothermal", "Hydroelectric", "Solar", "Tidal", "Wind"))
    
    # Filtering for map display options
    toMap = reactive({
        filter(mapData,
               Year >= input$paramYears[1], Year <= input$paramYears[2],
               Province %in% input$paramProvince,
               Ownership %in% input$paramOwnership,
               Capacity >= input$paramCapacity[1], Capacity <= input$paramCapacity[2],
               Type %in% input$paramTypes,
               Status %in% input$paramStatus)
    })
    
    # Map definition
    output$map = renderLeaflet({
        m = leaflet(data=toMap(), options=leafletOptions(minZoom=3)) %>%
            addProviderTiles(providers$Stamen.TonerLite, options=providerTileOptions(noWrap=TRUE)) %>%
            setView(-99, 53, zoom=4)
        if (nrow(toMap()) > 0){
            m = m %>%
                addCircleMarkers(~Longitude, ~Latitude,
                           radius=~log(Capacity, 1.2), color=~mapPalette(Type), stroke=FALSE, fillOpacity=0.5,
                           label=~Name, popup=~PopupText, layerId=~Name,
                           popupOptions=popupOptions(closeButton=FALSE)) %>%
                addLegend("bottomright", pal=mapPalette, values=sort(unique(toMap()$Type)))
        }
        m
    })
    
    # Marker click EH
    observeEvent(input$map_marker_click,{
        updateSelectInput(session, "selectProject", selected=input$map_marker_click$id)
        updateTabsetPanel(session, "sidebarTabs", selected="Renewable Energy Projects")
    })
    
    # Selected project update EH
    observeEvent(input$selectProject,{
        if (input$selectProject != ""){
            project = filter(mapData, Name == input$selectProject)
            leafletProxy("map") %>%
                flyTo(project$Longitude, project$Latitude, 6)
        }
    })
    
    ################################################################################################################################################################
    # Project details ##############################################################################################################################################
    
    # Template data
    output$projectTemplate = renderUI({
        # Grab chosen project
        project = filter(mapData, Name == input$selectProject)
        
        # Build output
        fluidRow(
            column(width=6,
                HTML(project$Template1)
            ),
            column(width=6,
                HTML(project$Template2)
            )
        )
    })
    
    ################################################################################################################################################################
    # About the App panel link EHs #################################################################################################################################
    
    # Projects link
    observeEvent(input$projectsLink,{
        updateTabsetPanel(session, "sidebarTabs", "Renewable Energy Projects")
    })
    
    # Contributors link
    observeEvent(input$contributorsLink,{
        updateTabsetPanel(session, "nav", "Contributors")
    })
    
    # Citations link
    observeEvent(input$referencesLink,{
        updateTabsetPanel(session, "nav", "References")
    })
    
    ################################################################################################################################################################
    # Plots ########################################################################################################################################################
    
    # Geography
    output$provincesPie = renderPlotly({
        mapData %>%
            group_by(Province) %>%
            summarize(Count = n(), .groups="drop") %>%
            plot_ly(labels=~Province, values=~Count,
                      type="pie") %>%
            config(displayModeBar=FALSE)
    })
    
    output$provincesBar = renderPlotly({
        fig = mapData %>%
            group_by(Province, Type) %>%
            summarize(Count = n(), .groups="drop") %>%
            ggplot(aes(x=Province, y=Count, fill=Type)) +
            geom_bar(position="dodge", stat="identity") +
            xlab(element_blank()) +
            theme(axis.text.x=element_text(angle=45))
        ggplotly(fig) %>%
            layout(xaxis=list(fixedrange=TRUE),
                   yaxis=list(fixedrange=TRUE)) %>%
            config(displayModeBar = FALSE)
    })
    
    output$provincesProjectsTS = renderPlotly({
        fig = provinceCounts %>%
            ggplot(aes(x=Year, y=Count, fill=Province)) +
            geom_area()
        ggplotly(fig) %>%
            layout(xaxis=list(fixedrange=TRUE),
                   yaxis=list(fixedrange=TRUE)) %>%
            config(displayModeBar = FALSE)
    })
    ################################################################################################################################################################
})
