library(shiny)

shinyUI(fluidPage(theme=shinytheme("cosmo"),
    navbarPage("Canadian Renewable Energy Projects - Swarm C", id="nav",
        tabPanel("Dashboard",
            sidebarLayout(
                mainPanel(
                    # Map panel
                    wellPanel(
                        leafletOutput("map", height=520),
                        HTML("<i>Click for additional detail. Circle size corresponds to production capacity.</i>")
                    ), # End of map panel
                    
                    # Map settings panel
                    wellPanel(
                        titlePanel(HTML("<h2>Map Settings</h2>")),
                        fluidRow(
                            # Time and geography settings
                            column(width=6, align="center",
                                   fluidRow(
                                       sliderInput("paramYears", "Time span:",
                                                   min=min(mapData$Year), max=max(mapData$Year), value=c(min(mapData$Year), max(mapData$Year)),
                                                   ticks=FALSE, sep="")
                                   ),
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
                                 to the swarm.
                                 <p>The dashboard provides a simple way to interact and explore the collected data. See the Data Visualization page for interpretati
                                 on and analysis."),
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
                            titlePanel(HTML("<h3>Project Timeline</h3>")),
                            timevisOutput("projectTimeline"),
                            htmlOutput("timelineCitation")
                        ) #End of project information
                    )
                ) # End of sidebar
            ) # End of sidebar layout
        ), # End of dashboard page
        
        tabPanel("Data Visualization",
            # Introduction
            titlePanel(HTML("<h1><b>Introduction</h1></b>")),
            HTML("<p style='font-size:30px'>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliq
                 ua. Ut enim ad  minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehend
                 erit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia dese
                 runt mollit anim id est laborum."),
            hr(), # End of introduction
            tabsetPanel(type="tabs",
                # Geography
                tabPanel("Geography",
                         # Projects per province
                         fluidRow(
                             column(width=6, align="center",
                                    column(width=12, align="left",
                                           HTML("<br>"),
                                           wellPanel(
                                               HTML("<p style='font-size:30px'>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incidi
                                               dunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut ali
                                               quip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat
                                               nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est
                                               laborum.")
                                           )
                                    )
                             ),
                             column(width=6, align="center",
                                    titlePanel(HTML("<h3>Proportion of Projects by Province<h3>")),
                                    plotlyOutput("provincesPie")
                             )
                         ),
                         fluidRow(
                             column(width=6, align="center",
                                    titlePanel(HTML("<h3>Cumulative Projects per Province</h3>")),
                                    plotlyOutput("provincesProjectsTS")
                             ),
                             column(width=6, align="center",
                                    titlePanel(HTML("<h3>Provincial Projects by Type</h3>")),
                                    plotlyOutput("provincesBar")
                             )
                         ),
                         hr() # End of projects per province
                ), # End of geography tab
                
                # Energy sources
                tabPanel("Energy Sources",
                    # Projects per province
                    fluidRow(
                        column(width=6, align="center",
                            titlePanel(HTML("<h3>Proportion of Projects by Energy Source</h3>")),
                            plotlyOutput("energyType")
                        ),
                        column(width=6, align="center",
                            titlePanel(HTML("<h3>Cumulative Projects per Energy Source</h3>")),
                            plotlyOutput("typesProjectsTS")
                        )
                    ),
                    fluidRow(
                        column(width=6, align="center",
                            titlePanel(HTML("<h3>Distribution of Energy Capacity per Energy Source</h3>")),
                            plotlyOutput("typeCapacity")
                        ),
                        column(width=6, align="center",
                               column(width=12, align="left",
                                   HTML("<br>"),
                                   wellPanel(
                                       HTML("<p style='font-size:30px'>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incidi
                                               dunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut ali
                                               quip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat
                                               nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est
                                               laborum.")
                                      )
                               )
                        )
                    ),
                    hr() # End of projects per province
                ), # End of energy sources tab
                
                # Ownership
                tabPanel("Ownership",
                    fluidRow(
                        column(width=8, align="center",
                            titlePanel(HTML("<h3>Projects by Ownership Type</h3>")),
                            plotOutput("ownershipAlluvial")
                        ),
                        column(width=4, align="center",
                            titlePanel(HTML("<h3>Distribution of Energy Capacity by Ownership Type</h3>")),
                            plotlyOutput("ownershipCapacity")
                        )
                    ),
                    wellPanel(
                        HTML("<p style='font-size:30px'>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incidi
                                               dunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut ali
                                               quip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat
                                               nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est
                                               laborum.")
                    )
                )
            )
        ), # End of data visualization page
        
        tabPanel("Contributors",
            
        ) # End of contributors page
    )
))
