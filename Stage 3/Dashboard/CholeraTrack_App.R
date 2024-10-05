# Load necessary libraries
library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)
library(readr)
library(shinydashboard)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)

# Read the CSV files and process initial data
cholera_reported_cases <- read.csv('data/number of reported cases.csv', stringsAsFactors = FALSE)
cholera_reported_cases$Year <- as.numeric(cholera_reported_cases$Year)
cholera_reported_cases$Number.of.reported.cases.of.cholera <- as.numeric(cholera_reported_cases$Number.of.reported.cases.of.cholera)
cholera_reported_cases$Countries..territories.and.areas <- as.factor(cholera_reported_cases$Countries..territories.and.areas)

cholera_case_fr <- read.csv('data/implied case fatality rate.csv', stringsAsFactors = FALSE) 
cholera_case_fr$Year <- as.numeric(cholera_case_fr$Year)
cholera_case_fr$Countries..territories.and.areas <- as.factor(cholera_case_fr$Countries..territories.and.areas)
cholera_case_fr$Cholera.case.fatality.rate <- as.factor(cholera_case_fr$Cholera.case.fatality.rate)

cholera_reported_deaths <- read.csv('data/number of reported deaths.csv', stringsAsFactors = FALSE)
cholera_reported_deaths$Year <- as.numeric(cholera_reported_deaths$Year)
cholera_reported_deaths$Countries..territories.and.areas <- as.factor(cholera_reported_deaths$Countries..territories.and.areas)
cholera_reported_deaths$Number.of.reported.deaths.from.cholera <- as.factor(cholera_reported_deaths$Number.of.reported.deaths.from.cholera)


# Merge the 3 datasets
merged_data <- cholera_case_fr %>%
  full_join(cholera_reported_deaths, by = c("Year", "Countries..territories.and.areas")) %>%
  full_join(cholera_reported_cases, by = c("Year", "Countries..territories.and.areas"))

# Rearrange columns
rearranged_data <- merged_data %>%
  select(Countries..territories.and.areas, 
         Number.of.reported.cases.of.cholera, 
         Number.of.reported.deaths.from.cholera, 
         Cholera.case.fatality.rate, 
         everything())

# Define UI
ui <- fluidPage(
  # Add the logo to the UI
  tags$div(
    tags$img(src = "holera.png", class = "logo-img", alt = "Cholera Logo"),
    class = "logo-container",  # Updated path
    style = "text-align: center; margin-bottom: 20px;"  # Center the logo
  ),
  # Add the logo to the UI
  theme = bslib::bs_theme(
    version = 4,
    bg = "#f7f7f7",  # Light grey base
    fg = "#2c2c2c",  # Dark grey font for contrast
    primary = "#607d8b",  # Blue-grey primary color
    secondary = "#37474f",  # Darker grey for secondary elements
    base_font = bslib::font_google("Roboto"),
    heading_font = bslib::font_google("Roboto Slab")
  ),
  
  tags$head(
    # Custom CSS for the new layout
    tags$style(HTML("
      body {
        background-color: #f7f7f7; /* Simple light grey background */
      }
      .logo-img {
        width: 50%;  /* Make the image take full width */
        max-width: 400px;  /* Limit max width to 400px */
        height: auto;  /* Keep height proportional */
        object-fit: contain;  /* Maintain aspect ratio and fit within the bounds */
      }
      .logo-container {
  background: linear-gradient(to right, #e0f7fa, #b0bec5);  /* Blue to grey gradient */
  padding: 20px;  /* Optional padding */
  text-align: center;
  margin-bottom: 20px;
}
      
      .navbar {
        background: linear-gradient(to right, #e0f7fa, #b0bec5); /* Very light blue-grey gradient */
        border-bottom: 1px solid #cfcfcf;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        color: #ffffff;
      }
      .navbar-title {
        color: #ffffff;
        font-size: 1.8em;
        font-weight: bold;
        padding-left: 20px;
      }
      .sidebar {
        background-color: #ffffff;
        padding: 20px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        border-radius: 8px;
      }
      .content-card {
  background-color: #ffffff;
  padding: 30px;
  border-radius: 12px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}
     
      
      h2 {
        font-weight: 700;
        color: #37474f;
        font-size: 1.8em;
      }
      p {
        font-size: 1.1em;
        color: #444444;
      }
      .btn-primary {
  background-color: #607d8b;
  border: none;
  font-size: 1.2em;
  padding: 10px 20px;
  border-radius: 6px;
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
  transition: background-color 0.3s ease;
}
.btn-primary:hover {
  background-color: #546e7a;  /* Slightly darker blue-grey on hover */
}

      
    "))
  ),
  
  
  
  
  
  # TabsetPanel with icons for navigation instead of sidebar
  tabsetPanel(
    id = "tabs", 
    type = "tabs",  # Use "tabs" type for the tab layout
    
    # Home Section with "home" icon
    tabPanel(
      title = tagList(icon("home"), "Home"),  # Adding home icon
      value = "home",  # Ensure value is set to "home"
      div(class = "home-section",
          h2("Welcome to the Cholera Outbreak Visualization Dashboard!"),
          p("Welcome to our interactive Cholera Outbreak Visualization Dashboard, your go-to resource for analyzing global cholera outbreak data and insights. Developed in partnership with experts in antimicrobial resistance (AMR) epidemiology and front-end bioinformatics, this Shiny app allows users to visualize cholera trends from 1949 to the present and generate detailed reports for individual countries."),
          h4("What can you assess?"),
          p("Our dashboard is developed to give a complete and straightforward experience, which allows users to:"),
          tags$ul(
            tags$li("Explore Global Cholera Outbreaks: Interactive maps and infographics show the global distribution of cholera cases and deaths. To identify major patterns and epidemics, apply filters to certain geographies and time periods."),
            tags$li("Get Insightful Reports: With a few clicks, you can produce detailed reports that describe cholera outbreaks in any country. These reports, created using our epidemiologists' proprietary templates, feature key indicators including case counts, fatality rates, and outbreak durations."),
            tags$li("Interactive Features: Customize your experience by selecting nations, changing time frames, and investigating how cholera has affected various places over time. Whether you're a scholar, a public health official, or simply interested, our tool streamlines and visualizes cholera data.")
          ),
          h4("Why use our dashboard?"),
          p("Cholera remains a global health problem, particularly in vulnerable areas with limited access to clean water and sanitation. Understanding the patterns and trends of cholera epidemics is critical to preventive and response efforts. This tool integrates historical and current data, allowing you to evaluate, report on, and better understand the severity and spread of cholera outbreaks."),
          p("We hope that this tool will help health professionals, researchers, and policymakers make rational choices to battle cholera around the world."),
          h4("Start exploring now for more insight into one of the world's leading public health challenges!")
      )
    ),
    
    # Interactive Plots Section with "chart-line" icon
    tabPanel(
      title = tagList(icon("chart-line"), "Interactive Plots"),  # Adding chart-line icon
      value = "interactive_plots",  # Ensure value is set to "interactive_plots"
      h2("Interactive Cholera Plots"),
      plotlyOutput("interactive_plot2"),
      plotlyOutput("interactive_graph3"),
      plotlyOutput("interactive_graph4")
    ),
    
    # Country Calculation Section with "globe" icon
    tabPanel(
      title = tagList(icon("globe"), "Calculation per Country"),  # Adding globe icon
      value = "country_calculation",  # Ensure value is set to "country_calculation"
      selectInput("selected_country", "Select a Country:", 
                  choices = unique(rearranged_data$Countries..territories.and.areas),
                  selected = unique(rearranged_data$Countries..territories.and.areas)[1]
      ),
      sliderInput("year_range", "Select Year Range:", 
                  min = min(rearranged_data$Year, na.rm = TRUE), 
                  max = max(rearranged_data$Year, na.rm = TRUE),
                  value = c(min(rearranged_data$Year, na.rm = TRUE), max(rearranged_data$Year, na.rm = TRUE))
      ),
      actionButton("generate_report", "Generate Country Report"),
      
      # Nested tabsetPanel for Map, Charts, and Summary inside Calculation per Country
      tabsetPanel(
        tabPanel("Charts", 
                 plotlyOutput("case_trend_chart"),
                 plotlyOutput("death_trend_chart"),
                 plotlyOutput("fatality_trend")
        ),
        tabPanel("Summary", verbatimTextOutput("country_report"))
      )
    )
  )
)



# Define Server
server <- function(input, output, session) {
  
  
  
  # Interactive Plot 2 (Global Comparison of Cholera Cases)
  data <- read.csv("data/number of reported cases.csv")
  
  graph2 <- ggplot(data, aes(x = Year, y = Number.of.reported.cases.of.cholera)) +
    geom_bar(stat = "identity", fill = "skyblue") +
    ylab("Number of cases") +
    xlab("Years") +
    ggtitle("Global Comparison of Cholera Cases by Year") +
    scale_x_continuous(breaks = unique(data$Year)) +  # Ensure all years are displayed
    scale_y_continuous(labels = function(x) format(x, scientific = FALSE)) +  # No commas or scientific notation
    theme_classic() +
    theme(
      plot.title = element_text(face = "bold", size = 10),
      axis.text.y = element_text(size = 10),
      axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 6)  # Rotate the years by 90 degrees
    )
  
  output$interactive_plot2 <- renderPlotly({
    ggplotly(graph2)
  })
  
  
  # Interactive Plot 3 (Global Comparison of Cholera Deaths)
  data2 <- read.csv("data/number of reported deaths.csv")
  data2 <- data2 %>% rename(death = Number.of.reported.deaths.from.cholera)
  data2$death <- as.numeric(data2$death)
  data2$Year <- as.factor(data2$Year)
  
  graph3 <- ggplot(data2, aes(x = Year, y = death)) +
    geom_bar(stat = "identity", fill = "#90EE90") +
    xlab("Years") +
    ylab("Number of deaths") +
    ggtitle("Global Comparison of Cholera Deaths by Year") +
    scale_y_continuous(labels = function(x) format(x, scientific = FALSE)) +  # Ensure y-axis shows full numbers
    theme_classic() +
    theme(
      plot.title = element_text(face = "bold", size = 10),
      axis.text.x = element_text(angle = 90, hjust = 1, size = 8)  # Rotate years on x-axis for better visibility
    )
  
  output$interactive_graph3 <- renderPlotly({
    ggplotly(graph3)
  })
# interactive 4 (fatality rate )
    data3 <- read.csv("data/implied case fatality rate.csv")  
    data3 <- data3 %>% rename(fatality.rate = Cholera.case.fatality.rate)
    data3$fatality.rate <- as.numeric(data3$fatality.rate)
    data3$Year <- as.factor(data3$Year)
    
    graph4 <- ggplot(data3, aes(x = Year, y = fatality.rate)) +
      geom_bar(stat = "identity", fill = "#c886db") +
      xlab("Years") +
      ylab("fatality rate") +
      ggtitle("Global Comparison of Case Fatality Year by Year") +
      scale_y_continuous(labels = function(x) format(x, scientific = FALSE)) +  # Ensure y-axis shows full numbers
      theme_classic() +
      theme(
        plot.title = element_text(face = "bold", size = 10),
        axis.text.x = element_text(angle = 90, hjust = 1, size = 8)  # Rotate years on x-axis for better visibility
      )
    output$interactive_graph4 <- renderPlotly({
      ggplotly(graph4)
    
      })
  
  
  # Calculate Cholera Data by Country
  filtered_data <- reactive({
    rearranged_data %>%
      filter(Countries..territories.and.areas == input$selected_country,
             Year >= input$year_range[1] & Year <= input$year_range[2])
  })
  
  
  
  output$case_trend_chart <- renderPlotly({
    case_trend <- filtered_data() %>%
      group_by(Year) %>%
      summarize(Total_Cases = sum(as.numeric(Number.of.reported.cases.of.cholera), na.rm = TRUE))
    
    plot_ly(case_trend, x = ~Year, y = ~Total_Cases, type = 'scatter', mode = 'lines+markers', name = 'Cases') %>%
      layout(title = "Cholera Cases Trend", xaxis = list(title = 'Year'), yaxis = list(title = 'Total Cases'))
  })
  
  output$death_trend_chart <- renderPlotly({
    death_trend <- filtered_data() %>%
      group_by(Year) %>%
      summarize(Total_Deaths = sum(as.numeric(Number.of.reported.deaths.from.cholera), na.rm = TRUE))
    
    plot_ly(death_trend, x = ~Year, y = ~Total_Deaths, type = 'scatter', mode = 'lines+markers', name = 'Deaths') %>%
      layout(title = "Cholera Deaths Trend", xaxis = list(title = 'Year'), yaxis = list(title = 'Total Deaths'))
  })
  
  output$fatality_trend <- renderPlotly({
    fatality_trend <- filtered_data() %>%
      group_by(Year) %>%
      summarize(Total_rate = sum(as.numeric(Cholera.case.fatality.rate), na.rm = TRUE))
    
    plot_ly(fatality_trend, x = ~Year, y = ~Total_rate, type = 'scatter', mode = 'lines+markers', name = 'Cases') %>%
      layout(title = "Cholera Cases fatality rate Trend", xaxis = list(title = 'Year'), yaxis = list(title = 'Total rate'))
  })
  
  output$country_report <- renderPrint({
    report <- filtered_data() %>%
      summarize(Total_Cases = sum(as.numeric(Number.of.reported.cases.of.cholera), na.rm = TRUE),
                Total_Deaths = sum(as.numeric(Number.of.reported.deaths.from.cholera), na.rm = TRUE),
                Total_Rate = sum(as.numeric(Cholera.case.fatality.rate), na.rm = TRUE))
    
    paste("Country:", input$selected_country,
          "Total Cases:", report$Total_Cases,
          "Total Deaths:", report$Total_Deaths)
  })
}

#library(rsconnect)
#rsconnect::setAccountInfo(name='',
             #             token='',
               #           secret='')



# Run the application 
shinyApp(ui = ui, server = server)

#rsconnect::deployApp(appName = "", account = "", server = "", appId = "", appFiles = "")
