#' Full Download data from database
#'
#' @param ep Endpoint
#' @param element Element type (Vertices or Edges) 
#'
#' @return Data frame with all selected elements
#' @export
#' 

neptune_download <- function(ep,element='Vertices'){
  
  if(element=="Vertices"){
    data<-neptune_send_json_query(ep,"g.V()",as="parsed")
    result<-neptune_parse_results_to_tables(data)
    result<-result$vertices
  }
    else if(element=="Edges"){
      data<-neptune_send_json_query(ep,"g.E()",as="parsed")
      result<-neptune_parse_results_to_tables(data)  
      result<-result$edges
    }
  else stop("Invalid element type")
}
  

#' Download data from database within a defined range
#'
#' @param ep Endpoint
#' @param element Element type (Vertices or Edges) 
#' @param from Inferior limit of the range
#' @param to Upper limit of the range
#'
#' @return Data frame with all selected elements within the range
#' @export
#' 

neptune_range_download <- function(ep,from,to,element='Vertices'){
  
  
  if(element=="Vertices"){
    query<-paste("g.V().range(",from,",",to,")",sep="")
    data<-neptune_send_json_query(ep,query,as="parsed")
    result<-neptune_parse_results_to_tables(data)
    result<-result$vertices
  }
  else if(element=="Edges"){
    query<-paste("g.E().range(",from,",",to,")",sep="")
    data<-neptune_send_json_query(ep,query,as="parsed")
    result<-neptune_parse_results_to_tables(data)  
    result<-result$edges
  }
  else stop("Invalid element type")
  
  }