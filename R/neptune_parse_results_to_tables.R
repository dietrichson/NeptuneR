#' Title
#'
#' @param data
#'
#' @return a igraph object
#' @import dplyr
#' @export neptune_parse_results_to_tables

neptune_parse_results_to_tables <- function(data){
  library(dplyr)
  gdata <- data$result$data
  vertices <- lapply(gdata$`@value`,function(x){
    if(x$`@type`=='g:Vertex'){
      VertexDF <- data.frame(x$`@value`[c('id','label')]) #Get ID and label for Vertex
      properties <- gremlin_properties_to_table(x$`@value`$properties)
     if(!is.null(properties))
       cbind(VertexDF,properties)
      else
        VertexDF
#      vDF
#    VertexDF
    }
  }
  ) %>% data.table::rbindlist(fill = TRUE)-> res
  edges <- lapply(gdata$'@value', function(x){
    if(x$`@type`=='g:Edge'){
      edgeDF <- data.frame(x$`@value`[c('id','label','inVLabel','outVLabel','inV','outV')])
      properties<- gremlin_edge_properties_to_table(x$`@value`$properties)
      if(!is.null(properties)){
        cbind(edgeDF,properties)
      }
      else
        edgeDF
      #browser()
      #myProperties <- gremlin_parse_properties_to_data_frame(x$`@value`$properties)
      #cbind(VertexDF,properties )
    }
  }) %>% data.table::rbindlist(fill = TRUE)-> res
  list(vertices=vertices,edges=edges)
}


#' Pastes all properties of an element to a data frame
#' @param x Element
#' @return Returns a data frame with all of the element's properties
#'
#'
#' @import dplyr
#' @export
#' 

gremlin_properties_to_table <- function(x){
  properties<-0
  properties <- as.data.frame(properties)
  for (i in x) {
    for (j in i) {
      if(!is.character(j$`@value`$value)){
        prop<-j$`@value`$value$`@value`
        prop<-as.data.frame(prop)
      }else{
        prop<-j$`@value`$value
        prop<-as.data.frame(prop)
        }
      names(prop)<-j$`@value`$label
      properties<-cbind(properties,prop)
    }
    
  }
  names<-names(properties)[-1]
  properties<-properties[,-1]
  names(properties)<-names
  properties
}

gremlin_edge_properties_to_table <- function(x){
  properties<-0
  properties <- as.data.frame(properties)
  for (i in x) {
    if(is.list(i$`@value`$value)){
      prop<-i$`@value`$value$`@value`
      prop<-as.data.frame(prop,stringAsFactor=FALSE)
    }else{
      prop<-i$`@value`$value
      prop<-as.data.frame(prop,stringAsFactor=FALSE)
    }
      names(prop)<-i$`@value`$key
      properties<-cbind(properties,prop)
    }
  names<-names(properties)[-1]
  properties<-properties[,-1]
  properties<-as.data.frame(properties)
  names(properties)<-names
  properties
}