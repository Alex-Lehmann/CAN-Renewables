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
                                 <p>This project aims to present the data regarding Canada’s renewable energy projects in a way that shows the government’s dedication to the renewable energy generation sector. The interactive map is intended to see if there are any patterns among the data regarding the dispersion of renewable energy projects based on where they are located within Canada or if a certain type of energy project appears to be more successful than others. Together with the timeline data, this form of mapping is significant for researchers as they can then analyse variables that might contribute to the success or failure of the projects, including physical and geographical factors such as weather/climate, seasonality, but also the socioeconomic and political factors within a country."),
                            HTML("<br><br>"),
                            actionLink("projectsLink", "For a full list of included renewable energy projects, please see the Renewable Energy Projects tab."),
                            HTML("<h2>Contributors</h2>"),
                            actionLink("contributorsLink", "For a full list of swarm members who contributed to this project, please see the Contributors page."),
                            HTML("<h2>Source</h2>
                                 <a href='https://github.com/Alex-Lehmann/CAN-Renewables'>View the full source code on GitHub.</a>")
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
            tabsetPanel(type="tabs",
                # Geography
                tabPanel("Geography",
                         # Projects per province
                         fluidRow(
                             column(width=6,
                                    HTML("<br>"),
                                    wellPanel(HTML("<p style='font-size:30px'>Based on the chart, it is visible that the majority of the renewable energy projects the Swarm selected were located in the province of Ontario. However, of the 13 provinces and territories in Canada, the Swarm only chose renewable energy projects from 6 provinces. British Columbia was the province with the second highest amount of renewable energy projects from the Swarm data, with 7 projects selected. While British Columbia had 7 projects selected, it is still about 1/3 of the quantity of projects for Ontario. Despite a small sample size, based on the Swarm data, the proportion of projects could be investigated on a national scale to see if the Ontario to British Columbia projects is approximately 3:1."))
                             ),
                             column(width=6, align="center",
                                    titlePanel(HTML("<h3>Proportion of Projects by Province<h3>")),
                                    plotlyOutput("provincesPie")
                             )
                         ),
                         column(width = 12, align = "center",
                            titlePanel(HTML("<h3>Cumulative Projects per Province</h3>")),
                            plotlyOutput("provincesProjectsTS")
                         ),
                         
                         fluidRow(
                             column(width=6, align="center",
                                    titlePanel(HTML("<h3>Provincial Projects by Type</h3>")),
                                    plotlyOutput("provincesBar")
                             ),
                             column(width=6,
                                    HTML("<br>"),
                                    wellPanel(HTML("<p style='font-size:30px'>This chart represents the quantity of projects per each province. The x-axis has the names of the provinces, and the y-axis represents the number of projects. The legend highlights each of the six renewable energy sources that were chosen by the Swarm. This bar chart shows that in Ontario, the wind projects were the most abundant, with 9 projects. Also in Ontario, there were 4 solar projects, 8 hydroelectric, and 3 biomass projects. The only project selected from both Newfoundland and Labrador was hydroelectric. Nova Scotia has 2 biomass projects, 2 tidal, and 1 wind project. New Brunswick had 1 hydroelectric power project, and 2 wind projects, while Alberta has two solar and one wind project. Finally, British Columbia has 1 geothermal project 4 hydroelectric, 1 solar, and 1 wind project. It is evident that although wind, solar, and biomass projects are predominantly located in Ontario, there is a more even division of the other renewable energy sources throughout the other provinces."))
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
