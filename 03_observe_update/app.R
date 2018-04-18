##03 - Observe/update
#Sys.setlocale("LC_ALL", "C")
library(fivethirtyeight)
library(shiny)
library(tidyverse)

##Load in the helper functions
source("helper.R")
data(biopics)
myDataFrame <- biopics
categoricalVars <- get_category_variables(myDataFrame)
numericVars <- get_numeric_variables(myDataFrame)

ui <- shinyUI(
  fluidPage(
    fileInput("file1", "Choose csv file to upload", accept = ".csv"),
    selectInput("x_variable","Select X Variable",numericVars, 
                selected=numericVars[1]),
    selectInput("y_variable", "Select Y Variable", numericVars, 
                selected = numericVars[2]),
    plotOutput("scatter_plot")
  )
)

server <- function(input, output, session) {
  
  myData <- reactive({
    inFile <- input$file1
    ##need to test whether input$file1 is null or not
    if (is.null(inFile)) {
      d <- myDataFrame
    } else {
      d <- read.csv(inFile$datapath)
    }
    return(d)
  })
  
  output$scatter_plot <- renderPlot({
    ggplot(myData(), aes_string(y=input$y_variable, 
                                       x=input$x_variable)) +
      geom_point() 

  })
  
  
  ##observe runs the code whenever myData() changes
  observe({
    #get the new numeric variables when the data is loaded
    num_vars <- get_numeric_variables(myData())
    
    ##update the selectInput with choices
    updateSelectInput(session, "x_variable",
                      choices = num_vars,
                      selected = num_vars[1])
    ##make the selected different for y_variable
    updateSelectInput(session, "y_variable", 
                      choices=num_vars,
                      selected= num_vars[2])
  })
  

}

shinyApp(ui, server)