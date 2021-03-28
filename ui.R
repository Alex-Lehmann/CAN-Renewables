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
                                    wellPanel(HTML("<p style='font-size:20px'>Based on the chart, it is visible that the majority of the renewable energy projects the Swarm selected were located in the province of Ontario. However, of the 13 provinces and territories in Canada, the Swarm only chose renewable energy projects from 6 provinces. British Columbia was the province with the second highest amount of renewable energy projects from the Swarm data, with 7 projects selected. While British Columbia had 7 projects selected, it is still about 1/3 of the quantity of projects for Ontario. Despite a small sample size, based on the Swarm data, the proportion of projects could be investigated on a national scale to see if the Ontario to British Columbia projects is approximately 3:1."))
                             ),
                             column(width=6, align="center",
                                    titlePanel(HTML("<h3>Proportion of Projects by Province<h3>")),
                                    plotlyOutput("provincesPie")
                             )
                         ),
                         fluidRow(
                             column(width = 6, align = "center",
                                    titlePanel(HTML("<h3>Cumulative Projects per Province</h3>")),
                                    plotlyOutput("provincesProjectsTS")
                             ),
                             column(width = 6,
                                    wellPanel(HTML("<p style = 'font-size:20px'>This chart represents the cumulative number of renewable energy projects in each province from the years 1890 to the 2021. The Y-axis represents the total number of renewable energy projects, while the X-axis represents time in years. The chart key shows which colours correspond to the individual Canadian provinces.
                                                    <p style = 'font-size:20px'>The information from the chart states that of the Swarm’s 43 energy projects, the first renewable energy project was located in Ontario and was built in 1890. Based on the chart, by 1943 there were only three renewable energy projects in operation, all of which were in Ontario. British Columbia was the second province to build a renewable energy project, though that was not until 1946. Development of these projects were slow until 1984 when there was a rapid increase among all provinces. By 1987, there was a total of 12 projects in operation. Ontario had a total of 12 projects, British Columbia had a total of 7 projects, Nova Scotia had a total of 4 projects,  New Brunswick had a total of 3 projects, Newfoundland and Labrador had a total of 2 projects, and Quebec had 1 built project. The most rapid growth was between 1998 and 2019 in Ontario where the cumulative total went from 12 projects to 43 projects. The most rapid growth for British Columbia, with the second largest cumulative total, was between 2012 and 2014 where it increased its total from 12 projects to 17 projects in 2016."))
                             )
                         ),
                         fluidRow(
                             column(width=6, align="center",
                                    titlePanel(HTML("<h3>Provincial Projects by Type</h3>")),
                                    plotlyOutput("provincesBar")
                             ),
                             column(width=6,
                                    HTML("<br>"),
                                    wellPanel(HTML("<p style='font-size:20px'>This chart represents the quantity of projects per each province. The x-axis has the names of the provinces, and the y-axis represents the number of projects. The legend highlights each of the six renewable energy sources that were chosen by the Swarm. This bar chart shows that in Ontario, the wind projects were the most abundant, with 9 projects. Also in Ontario, there were 4 solar projects, 8 hydroelectric, and 3 biomass projects. The only project selected from both Newfoundland and Labrador was hydroelectric. Nova Scotia has 2 biomass projects, 2 tidal, and 1 wind project. New Brunswick had 1 hydroelectric power project, and 2 wind projects, while Alberta has two solar and one wind project. Finally, British Columbia has 1 geothermal project 4 hydroelectric, 1 solar, and 1 wind project. It is evident that although wind, solar, and biomass projects are predominantly located in Ontario, there is a more even division of the other renewable energy sources throughout the other provinces."))
                             )
                         )
                ), # End of geography tab
                
                # Energy sources
                tabPanel("Energy Sources",
                    # Projects per province
                    fluidRow(
                        column(width = 6, align = "center",
                            titlePanel(h3("Proportion of Projects by Energy Source")),
                            plotlyOutput("energyType")
                        ),
                        column(width = 6,
                            wellPanel(HTML("<br><p style='font-size:20px'>This pie chart is representative of the division of projects by renewable energy sources that were selected by the Swarm. Of the 43 submitted projects, 32.6% were wind projects and 32.6% of then were hydroelectric projects. Of the remaining 15 projects, 7 were solar, 5 were biomass, 2 were tidal, and 1 was geothermal. Wind and hydroelectric were of equal popularity among the Swarm and geothermal was the least selected. If the selection of renewable energy sources was random, then this chart would not be representative of Canada’s distribution/ratio of renewable energy sources as it would not be an accurate sample of the country’s energy sources. However, further investigation could determine if there is an equal amount of wind and hydroelectric energy projects in operation in Canada. It could use the Swarm’s data as a benchmark to either support or refute comparisons such as the ratio of wind projects to solar projects within Canada, etc. If accurate representations of Canada’s renewable energy projects, these comparisons could be used to analyze the total energy contributions (MW) of each energy source and determine which is the most efficient and contributes the most to Canada’s energy consumption."))
                        )
                    ),
                    fluidRow(
                        column(width = 6,
                            wellPanel(HTML("<br><p style='font-size:20px'>This plot shows the distributions of output capacity for each type of renewable energy project studied by the swarm. Hydroelectric power has the highest capacities, but also the largest variance. Biomass and solar energy averages are comparable, but solar hs a wider interquartile range and and longer fences. Wind was also comparable on average, but had some low-capacity projects including a zero-value outlier representing an in-development project. Tidal energy generally had lower capacities than the other types, but was relatively consistent."))
                        ),
                        column(width = 6, align = "center",
                            titlePanel(h3("Distribution of Energy Capacity per Energy Source")),
                            plotlyOutput("typeCapacity")
                        )
                    ),
                    fluidRow(
                        column(width = 6, align = "center",
                            titlePanel(h3("Cumulative Projects by Type")),
                            plotlyOutput("typesProjectsTS")
                        ),
                        column(width = 6,
                            wellPanel(HTML("<br><p style = 'font-size:20px'>This cumulative frequency chart demonstrates the breakdown of the total number of renewable energy projects by energy source. The total value of all renewable energy projects is 43, and is represented on the Y-axis. The X-axis represents time (years). The chart key shows the colours on the chart that correspond to the renewable energy sources.
                                            <p style = 'font-size:20px'>Based on the chart, it is clear that of the Swarm’s data, from the years 1890 to 1982, there were only biomass projects within Canada. Only in 1983 was there the construction of a tidal project. In 1991, the first biomass project was built, in 2004, the first wind project was built, in 2013 the first solar project was built, and in 2017, the first geothermal project was built. The conclusions that can be drawn from this chart are that hydroelectric energy was the first renewable source to be utilized in Canada, and continues to be prominent today. Wind is a newer energy source in Canada, developed initially in 2004, though is equally as prominent in Canada."))
                        )
                    )
                ), # End of energy sources tab
                
                # Ownership
                tabPanel("Ownership",
                    fluidRow(
                        column(width = 6, align = "center",
                            titlePanel(h3("Associations Between Province, Ownership, and Energy Type")),
                            plotOutput("ownershipAlluvial")
                        ),
                        column(width = 6, align = "center",
                            titlePanel(h3("Distribution of Energy Capacity by Ownership Type")),
                            plotlyOutput("ownershipCapacity")
                        )
                    ),
                    fluidRow(
                        column(width = 6,
                            wellPanel(HTML("<br><p style = 'font-size:20px'>This chart shows the flow of renewable energy projects in Canada by province, by ownership type, and by renewable energy source. Beginning on the left is the province. Follow the line from the province to the middle y-axis, which is representative of the ownership type (joint, private, or public). Then, follow the flow of the line to the type of energy. From this chart, it is evident that all of Quebec’s renewable energy projects are public ownership, and are hydroelectric. Ontario has mainly private ownership, but has a wide variety of renewable energy sources, hence the thick line flowing from Ontario to “private” to hydroelectric, solar, tidal, wind and geothermal sources. The provinces with fewer projects are easier to trace with this graph as the lines are thinner. Additionally, this graph shows that the clear majority of projects are privately owned while publicly owned projects are second most common, and joint projects are the least common among the Swarm data."))
                        ),
                        column(width = 6,
                            wellPanel(HTML("<br><p style = 'font-size:20px'>The distribution of energy capacity is noticably different between the three types of ownership explored here. Jointly-owned projects had the lowest capacities with mean less than the 25th percentile of the other ownership types'. Private ownership also showed lower energy capacity than publicly-owned projects, although the upper 50% of privately owned projects overlapped with the publicly-owned projectgs' energy capacities."))
                        )
                    )
                )
            )
        ), # End of data visualization page
        
        tabPanel("Contributors",
            HTML("Jeff Jose<br>
                 Radhika Kamra<br>
                 Sabrina Khaddaj<br>
                 Zaynne Khamissa<br>
                 Farzal Khan<br>
                 Abhinav Khetarpal<br>
                 Cedric Knapp<br>
                 Ekaterina Kostina<br>
                 Peter Kouri<br>
                 Stefani Lague<br>
                 Julia Landry<br>
                 Brock Lariviere<br>
                 Nicole Laurin<br>
                 Nyah Lawryshyn<br>
                 Wendy Lee<br>
                 Austin Lee<br>
                 Nathan Lee<br>
                 Emily Lehman<br>
                 Alex Lehmann<br>
                 Jianghao Li<br>
                 Yongxi Li<br>
                 Milley Liu<br>
                 Shihao Liu<br>
                 Yuchen Liu<br>
                 Portia Loker-Fulcher<br>
                 Cameron Lopez-Smith<br>
                 Justin Low<br>
                 Suyan Lu<br>
                 Yongyi Lyu<br>
                 Zhiyu Ma<br>
                 Katelyn MacCormac<br>
                 MaryPat MacRae<br>
                 John Macmillan<br>
                 Anthony Maio<br>
                 Victor Makanju<br>
                 Kaiwen Mao<br>
                 Ellen Marciniak<br>
                 Krishna Mathiyaparanam<br>
                 David McConkey<br>
                 Shannon McNulty<br>
                 Darren Mes<br>
                 Logan Micucci<br>
                 Saba Mirza<br>
                 Dina Mohamed<br>
                 Menna Mohsen<br>
                 Wenqing Mu<br>
                 Kayley Kuizenga<br>
                 Cameron Lopez-Smith<br>
                 Marika Martineau")
        ) # End of contributors page
    )
))
