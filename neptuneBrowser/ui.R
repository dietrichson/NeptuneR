#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(visNetwork)
# Define UI for application that draws a histogram
shinyUI(
  fluidPage(

    # Application title
    titlePanel("Neptune Query Browser"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
      sidebarPanel(
        textAreaInput('query','Query: ',value='g.V().limit(1)', height = '400px' ),
        actionButton('runQuery','Run',icon=icon('play')),
        hr(),
        fluidRow(
          column(9,
                 textInput('url','Neptune URL: ', value = 'http://ec2-52-201-125-3.compute-1.amazonaws.com')
          ),
          column(3,
                 numericInput('port','Port: ', value=8182)
          )
        )
      ),

      # Show a plot of the generated distribution
      mainPanel(
        tabsetPanel(id='results',
                    tabPanel('Vertices',
                             DT::dataTableOutput('Vertices')),
                    tabPanel('Edges',
                             DT::dataTableOutput('Edges')),
                    tabPanel('Visualization',
                             fluidPage(
                               fluidRow(column(4,
                                               selectInput('edgesMap', 'Edges Map to:', choices = c()))),
                               fluidRow(visNetworkOutput('network',height = '800px'))
                             )
                    ),
                    tabPanel('Post Request'),
                    tabPanel('Raw Results',
                             textAreaInput('rawResults','Raw Results',height = '600px',width = '600px'))

        )
      )
    )
  )
)

