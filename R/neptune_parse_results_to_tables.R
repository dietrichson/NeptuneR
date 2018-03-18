#' Title
#'
#' @param data
#'
#' @return a igraph object
#' @import dplyr
#' @export neptune_parse_results_to_tables


gremlin_parse_properties_to_data_frame <- function(x){
  #parses gremlin json lists to a data.frame
  myNames <- names(x)
  lapply(myNames,function(myName){ #Data frame for properties
    #Default node type is text node - it has no tag
    nodeValue <- x[[myName]][[1]]$`@value`$value
    if(!is.character(nodeValue)){
      nodeValue <- x[[myName]][[1]]$`@value`$value$`@value`
    }
    tDF <- data.frame( nodeValue)
    names(tDF) <- x[[myName]][[1]]$`@value`$label
    tDF
  }) %>% do.call(cbind,.)
}

neptune_parse_results_to_tables <- function(data){
  library(dplyr)
  gdata <- data$result$data
  vertices <- lapply(gdata$`@value`,function(x){
    if(x$`@type`=='g:Vertex'){
      VertexDF <- data.frame(x$`@value`[c('id','label')]) #Get ID and label for Vertex
      properties <- gremlin_parse_properties_to_data_frame(x$`@value`$properties)
     if(!is.null(properties))
       cbind(VertexDF,properties )
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
      #browser()
      #myProperties <- gremlin_parse_properties_to_data_frame(x$`@value`$properties)
      #cbind(VertexDF,properties )
    }
  }) %>% data.table::rbindlist(fill = TRUE)-> res
  list(vertices=vertices,edges=edges)
}
