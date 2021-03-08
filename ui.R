library(shiny)

shinyUI(fluidPage(theme=shinytheme("cosmo"),
    navbarPage("Canadian Renewable Energy Projects - Swarm C", id="nav",
        tabPanel("Dashboard",
            sidebarLayout(
                mainPanel(
                    # Map panel
                    wellPanel(
                        leafletOutput("map", height=520)
                    ), # End of map panel
                    
                    # Map settings panel
                    wellPanel(
                        titlePanel(HTML("<h2>Map Settings</h2>")),
                        fluidRow(
                            # Time and geography settings
                            column(width=6, align="center",
                                sliderInput("paramYears", "Time span:",
                                            min=min(mapData$Year), max=max(mapData$Year), value=c(min(mapData$Year), max(mapData$Year)),
                                            ticks=FALSE, sep=""),
                                checkboxGroupInput("paramProvince", "Province:",
                                                   choices=sort(unique(mapData$Province)), selected=sort(unique(mapData$Province)),
                                                   inline=TRUE),
                                checkboxGroupInput("paramOwnership", "Ownership:",
                                                   choices=sort(unique(mapData$Ownership)), selected=sort(unique(mapData$Ownership)),
                                                   inline=TRUE)
                            ), # End of time and geography settings
                            
                            # Power generation settings
                            column(width=6, align="center",
                                sliderInput("paramCapacity", "Capacity:",
                                            min=min(mapData$Capacity), max=max(mapData$Capacity), value=c(min(mapData$Capacity), max(mapData$Capacity)),
                                            ticks=FALSE, sep=",", post=" MW"),
                                checkboxGroupInput("paramTypes", "Types:",
                                                   choices=sort(unique(mapData$Type)), selected=sort(unique(mapData$Type)),
                                                   inline=TRUE),
                                checkboxGroupInput("paramStatus", "Status:",
                                                   choices=sort(unique(mapData$Status)), selected=sort(unique(mapData$Status)),
                                                   inline=TRUE)
                            ) # End of power generation settings
                        )
                    ) # End of map settings panel
                ), # End of main panel
                
                sidebarPanel(
                    tabsetPanel(id="sidebarTabs",
                                
                        # About section
                        tabPanel("About the App",
                            HTML("<h2>Overview</h2>
                                 <p>This app allows users to visualize the data collected by members of Swarm C, TSES 3002 Energy and Sustainability, Carleton Unive
                                 rsity Winter 2021. Members of the swarm each collected data about a Canadian renewable energy project, then contributed their data 
                                 to the swarm."),
                            HTML("<br><br>"),
                            actionLink("projectsLink", "For a full list of included renewable energy projects, please see the Renewable Energy Projects tab."),
                            HTML("<h2>Contributors</h2>"),
                            actionLink("contributorsLink", "For a full list of swarm members who contributed to this project, please see the Contributors page."),
                            HTML("<h2>Source</h2>
                                 <a href='https://github.com/Alex-Lehmann/CAN-Renewables'>View the full source code on GitHub.</a>"),
                            HTML("<br>"),
                            actionLink("referencesLink", "For a full list of citations, please see the References page."),
                        ), # End of about section
                        
                        # Project information section
                        tabPanel("Renewable Energy Projects",
                            HTML("<br>"),
                            selectInput("selectProject", "Select a project:",
                                        choices=c("", sort(mapData$Name))),
                            
                            # Template
                            titlePanel(HTML("<h3>Template Data</h3>")),
                            uiOutput("projectTemplate"),
                            
                            # Timeline
                            titlePanel(HTML("<h3>Project Timeline</h3>"))
                        ) #End of project information
                    )
                ) # End of sidebar
            ) # End of sidebar layout
        ), # End of dashboard page
        
        tabPanel("Data Visualization",
        
        ), # End of data visualization page
        
        tabPanel("Contributors",
            
        ), # End of contributors page
        
        tabPanel("References",
            
        ) # End of reference page
    )
))
