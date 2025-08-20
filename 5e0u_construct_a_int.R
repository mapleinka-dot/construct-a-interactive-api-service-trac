# Interactive API Service Tracker in R

# Load necessary libraries
library(shiny)
library(httr)
library(jsonlite)
library(data.table)

# Define API endpoint and credentials
api_endpoint <- "https://example.com/api/endpoint"
api_key <- "your_api_key_here"
api_secret <- "your_api_secret_here"

# Create a function to make API requests
make_api_request <- function(endpoint, key, secret, params = list()) {
  headers <- c(`Content-Type` = "application/json",
               `Authorization` = paste0("Bearer ", key))
  response <- POST(endpoint, body = toJSON(params), headers = headers)
  stop_for_status(response)
  content(response, as = "text") %>% fromJSON()
}

# Create a Shiny UI
ui <- fluidPage(
  titlePanel("API Service Tracker"),
  sidebarLayout(
    sidebarPanel(
      textInput("api_key", "API Key: "),
      textInput("api_secret", "API Secret: "),
      actionButton("submit", "Submit"),
      hr(),
      textInput("params", "Parameters (JSON): ")
    ),
    mainPanel(
      tableOutput("api_response")
    )
  )
)

# Create a Shiny server
server <- function(input, output) {
  api_response <- eventReactive(input$submit, {
    make_api_request(api_endpoint, input$api_key, input$api_secret, 
                      fromJSON(input$params))
  }, ignoreNULL = FALSE)
  
  output$api_response <- renderTable({
    api_response()
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)