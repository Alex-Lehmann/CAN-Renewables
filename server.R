library(shiny)

shinyServer(function(input, output, session){
    values = reactiveValues()
    
    ################################################################################################################################################################
    # Map of renewable energy projects #############################################################################################################################
    
    # Map color palette
    mapPalette = colorFactor(energyColors, energyTypes)
    
    # Filtering for map display options
    toMap = reactive({
        filter(mapData,
               (Year >= input$paramYears[1] & Year <= input$paramYears[2]) | ("In Development" %in% input$paramStatus & Status == "In Development"),
               Province %in% input$paramProvince,
               Ownership %in% input$paramOwnership,
               Capacity >= input$paramCapacity[1], Capacity <= input$paramCapacity[2],
               Type %in% input$paramTypes,
               Status %in% input$paramStatus)
    })
    
    # Map definition
    output$map = renderLeaflet({
        # Get map center and scroll bounds
        scrollBounds = map_scroll_bounds(toMap()$Latitude, toMap()$Longitude)
        mapCenter = scrollBounds$mapCenter
        scrollBox = scrollBounds$scrollBox
        
        m = leaflet(data=toMap(), options=leafletOptions(minZoom=4)) %>%
            addProviderTiles(providers$Stamen.TonerLite, options=providerTileOptions(noWrap=TRUE)) %>%
            setView(mapCenter[1], mapCenter[2], zoom=4) %>%
            setMaxBounds(lat1=scrollBox[1], lat2=scrollBox[2],
                         lng1=scrollBox[3], lng2=scrollBox[4])
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
    
    # Timeline file loader
    timelineData = reactive({
        fileRef = input$selectProject %>%
            str_replace_all("\\s", "") %>%
            str_to_lower()
        fileName = (paste0("timeline_", fileRef, ".csv"))
        if (fileName %in% list.files("data")){
            return(read_csv(paste0("data/", fileName), col_types=cols()))
        } else {
            return(NULL)
        }
    })
    
    # Timeline
    output$projectTimeline = renderTimevis({
        # Blank if no project selected
        if (is.null(timelineData())) {return(NULL)}
        
        # Reformat for timevis timeline
        data = data.frame(
            id=row.names(timelineData()),
            content=timelineData()$Event,
            start=timelineData()$Date
        )
        
        # Generate timeline
        timevis(data,
                fit=TRUE, showZoom=FALSE) %>%
            setOptions(list(showCurrentTime=FALSE))
    })
    
    output$timelineCitation = renderUI({
        # Blank if no project selected
        if (is.null(timelineData())) {return(NULL)}
        
        # Instructions if no citation selected
        if (is.null(input$projectTimeline_selected)) {return(HTML("<i>Click on an event for citation</i>"))}
        
        # Get citation
        citation = timelineData()[input$projectTimeline_selected,]$Citation
        
        # Generate HTML element
        HTML(paste0("<b>Citation:</b> ", citation))
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
        # Sort order
        df = mapData %>%
            group_by(Province) %>%
            summarize(Count = n(), .groups="drop")
        sortOrder = df %>%
            arrange(Count) %>%
            pull(Province)
        
        # Plot
        fig = df%>%
            mutate(Province = factor(Province, levels=sortOrder)) %>%
            ggplot(aes(x=Count, y=Province, fill=Province)) +
            geom_segment(aes(x=0, xend=Count, y=Province, yend=Province, size=1.5)) +
            geom_point(aes(size=2)) +
            scale_fill_manual(values=provinceColors, breaks=provinces)
        ggplotly(fig) %>%
            style(hovertemplate="%{fullData.name}<br>%{x:.0f} Projects<extra></extra>") %>%
            layout(xaxis=list(fixedrange=TRUE), yaxis=list(fixedrange=TRUE)) %>%
            config(displayModeBar=FALSE)
    })
    
    output$provincesProjectsTS = renderPlotly({
        # Sort provinces by cumulative total for legend ordering
        legendOrder = provinceCounts %>%
            filter(Year == max(mapData$Year)) %>%
            arrange(desc(Count)) %>%
            pull(Province)
        
        # Create plot
        fig = provinceCounts %>%
            mutate(Province = factor(Province, levels=legendOrder)) %>%
            ggplot(aes(x=Year, y=Count, fill=Province)) +
            geom_area() +
            scale_fill_manual(values=provinceColors, breaks=provinces)
        ggplotly(fig) %>%
            style(hovertemplate="%{x:.0f}<br>%{y:.0f} Projects") %>%
            layout(xaxis=list(fixedrange=TRUE), yaxis=list(fixedrange=TRUE)) %>%
            config(displayModeBar=FALSE)
    })
    
    output$provincesBar = renderPlotly({
        fig = mapData %>%
            group_by(Province, Type) %>%
            summarize(Count = n(), .groups="drop") %>%
            ggplot(aes(x=Province, y=Count, fill=Type)) +
            geom_bar(position=position_dodge2(preserve="single"), stat="identity") +
            xlab(element_blank()) +
            theme(axis.text.x=element_text(angle=45)) +
            scale_fill_manual(values = energyColors, breaks = energyTypes)
        ggplotly(fig) %>%
            style(hovertemplate="%{fullData.name}<br>%{y:.0f} Projects<extra></extra>") %>%
            layout(xaxis=list(fixedrange=TRUE), yaxis=list(fixedrange=TRUE)) %>%
            config(displayModeBar=FALSE)
    })
    
    # Energy source
    output$energyType = renderPlotly({
        mapData %>%
            group_by(Type) %>%
            summarize(Count = n(), .groups="drop") %>%
            plot_ly(type="pie", labels=~Type, values=~Count,
                    texttemplate="%{label}", textposition="inside",
                    hovertemplate="%{value} Projects<br>%{percent}<extra>%{label}</extra>",
                    showlegend=FALSE) %>%
            config(displayModeBar=FALSE)
    })
    
    output$typesProjectsTS = renderPlotly({
        # Sort provinces by cumulative total for legend ordering
        legendOrder = typeCounts %>%
            filter(Year == max(mapData$Year)) %>%
            arrange(desc(Count)) %>%
            pull(Type)
        
        # Create plot
        fig = typeCounts %>%
            mutate(Type = factor(Type, levels=legendOrder)) %>%
            ggplot(aes(x=Year, y=Count, fill=Type)) +
            geom_area() +
            scale_fill_manual(values = energyColors, breaks = energyTypes)
        ggplotly(fig) %>%
            style(hovertemplate="%{x:.0f}<br>%{y:.0f} Projects", ".00<br>", "<br>") %>%
            layout(xaxis=list(fixedrange=TRUE), yaxis=list(fixedrange=TRUE)) %>%
            config(displayModeBar=FALSE)
    })
    
    output$typeCapacity = renderPlotly({
        fig = mapData %>%
            ggplot(aes(x=Type, y=log(Capacity), fill=Type)) +
            geom_boxplot() +
            xlab("Renewable Energy Source") +
            scale_fill_manual(values = energyColors, breaks = energyTypes)
        ggplotly(fig) %>%
            layout(xaxis=list(fixedrange=TRUE), yaxis=list(fixedrange=TRUE)) %>%
            config(displayModeBar=FALSE)
    })
    
    # Ownership
    output$ownershipAlluvial = renderPlot({
        mapData %>%
            mutate(Ownership = ifelse(Ownership == "Private", "Private",
                               ifelse(Ownership == "Joint", "Joint", "Public"))) %>%
            select(Ownership, Province, Type) %>%
            group_by(Ownership, Type, Province) %>%
            summarize(Count = n(), .groups="drop") %>%
            
            ggplot(aes(y=Count, axis1=Province, axis2=Ownership, axis3=Type)) +
            geom_alluvium(aes(fill=Ownership), width=1/12) +
            geom_stratum(width=1/6, fill="black", color="white") +
            geom_label(stat="stratum", aes(label=after_stat(stratum))) +
            
            scale_x_discrete(limits=c("Province", "Ownership Type", "Renewable Energy Source"), expand=c(.05, .05)) +
            theme(text=element_text(size=16),
                  axis.text.x=element_text(size=16))
    })
    
    output$ownershipCapacity = renderPlotly({
        fig = mapData %>%
            mutate(Ownership = ifelse(Ownership == "Private", "Private",
                               ifelse(Ownership == "Joint", "Joint", "Public"))) %>%
            ggplot(aes(x=Ownership, y=log(Capacity), fill=Ownership)) +
            geom_boxplot() +
            xlab("Ownership")
        ggplotly(fig) %>%
            layout(xaxis=list(fixedrange=TRUE), yaxis=list(fixedrange=TRUE)) %>%
            config(displayModeBar=FALSE)
    })
    
    ################################################################################################################################################################
})
