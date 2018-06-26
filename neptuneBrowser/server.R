#
# Server Logic for Shiny App to Connect and Interact with AWS Neptune.
#

library(shiny)
library(neptune)
library(jsonlite)
library(dplyr)
# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  ns <- session$ns
  
  ds <- reactiveValues(vertices = data.frame(),
                       edges = data.frame(),
                       request = character(0))
  
  output$Vertices <- DT::renderDataTable(
    ds$vertices
  )
  
  output$Edges <- DT::renderDataTable(
    ds$edges
  )
  
  observeEvent(input$runQuery,{
    
    ep <- connect_to_neptune_endpoint('http://ec2-52-201-125-3.compute-1.amazonaws.com')
    withProgress(message = 'Executing Query',
                 res <- tryCatch(
                   neptune_raw_json_query(ep,paste0('{"gremlin":"',input$query,'"}')),
                   error=function(e){
                     showModal(modalDialog('Connection Error',e))
                   })
    )
    
    
    updateTextAreaInput(session = session, inputId = 'rawResults' ,
                        value = toJSON(res) %>%
                          prettify %>% as.character
    )
    
    res <- neptune_parse_results_to_tables(res)
    if(res$vertices %>% nrow!= 0 & res$vertices %>% nrow!=0){
      ds$vertices <- res$vertices
      updateTabsetPanel(session = session, 'results',selected = 'Vertices')
    }
    if(res$edges %>% nrow!= 0 & res$edges %>% nrow!=0){
      ds$edges <- res$edges
      updateTabsetPanel(session = session, 'results',selected = 'Edges')
    }
    
    ds$edges <- res$edges
  }) #observeEvent
  
  output$network <- renderVisNetwork({
    # if(is.null(ds$edges$id)&is.null(ds$vertices$id)) {
    #   validate(need(TRUE,"No edges or vertices to visualize"))
    # }
    
    
    
    #myVs <- ds$vertices
    #if(is.null(myVs$id)){ #nothing there
    #  myVds <- data.frame(id=unique(ds$edges$id))
    #}
    
    visNetwork(nodes=ds$vertices,ds$edges %>% mutate(from=outV,to=inV))
    #visEdges<-ds$edges
    #rename(visEdges, from = outV, to = inV)
    #visNetwork(nodes=ds$vertices,edges = visEdges)
  })
  
})
