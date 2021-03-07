library(shiny)

shinyServer(function(input, output, session){
    values = reactiveValues()
    
    #######################################################################################
    # Map of renewable energy projects ####################################################
    
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
                addCircles(~Longitude, ~Latitude,
                           radius=~log(Capacity, 1.001)*20, color=~mapPalette(Type), stroke=FALSE, fillOpacity=0.7,
                           label=~Name, popup=~PopupText, layerId=~Name) %>%
                addLegend("bottomright", pal=mapPalette, values=sort(unique(toMap()$Type)))
        }
        m
    })
    
    # Marker click EH
    observeEvent(input$map_shape_click,{
        updateSelectInput(session, "selectProject", selected=input$map_shape_click$id)
        updateTabsetPanel(session, "sidebarTabs", selected="Renewable Energy Projects")
    })
    
    #######################################################################################
    # Project details #####################################################################
    
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
    
    #######################################################################################
    # About the App panel link EHs ########################################################
    
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
})
