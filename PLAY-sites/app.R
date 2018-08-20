#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Helper functions
# source("R/Cap.all.R")


# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("PLAY Sites"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         # sliderInput("bins",
         #             "Number of bins:",
         #             min = 1,
         #             max = 50,
         #             value = 30)
        selectInput(inputId  = "selectMeasure",
                    label    = "Select a measure",
                    choices  = names(county_demo_data)[2:9],
                    selected = 1),
        selectInput(inputId = "selectState",
                    label = "Select a state",
                    choices = c("new york", "pennsylvania"),
                    selected = 1)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("whitePlot"),
         plotOutput("blackPlot"),
         plotOutput("hispPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$whitePlot <- renderPlot({
     selected_county_fips <- county.regions %>%
       filter(state.name == input$selectState) %>%
       select(region)
     county_demo_data$value <- county_demo_data[,"percent_white"]
     county_choropleth(county_demo_data, 
                        title        = paste0("Percent White Population of Counties in ", Cap.all(input$selectState)),
                        legend       = input$selectMeasure,
                        num_colors   = 1,
                        county_zoom = selected_county_fips$region)
   })
   output$blackPlot <- renderPlot({
     selected_county_fips <- county.regions %>%
       filter(state.name == input$selectState) %>%
       select(region)
     county_demo_data$value <- county_demo_data[,"percent_black"]
     county_choropleth(county_demo_data, 
                       title        = paste0("Percent Black Population of Counties in ", Cap.all(input$selectState)),
                       legend       = input$selectMeasure,
                       num_colors   = 1,
                       county_zoom = selected_county_fips$region)
   })
   output$hispPlot <- renderPlot({
     selected_county_fips <- county.regions %>%
       filter(state.name == input$selectState) %>%
       select(region)
     county_demo_data$value <- county_demo_data[,"percent_hispanic"]
     county_choropleth(county_demo_data, 
                       title        = paste0("Percent Hispanic Population of Counties in ", Cap.all(input$selectState)),
                       legend       = input$selectMeasure,
                       num_colors   = 1,
                       county_zoom = selected_county_fips$region)
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

