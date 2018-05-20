#' Counts total of edges and vertices
#'
#' @param ep Endpoint
#' @param result Select vertices, edges or both
#' @return Displays ammount of vertices, edges or both
#'
#'
#' @export
#' 
#' 
neptune_count_elements<-function(ep,result=c('both','vertices','edges')){
  if(missing(result)){
    result<-"both"
  }
  
  if(result=='vertices'){
    res<-neptune_send_json_query(ep,"g.V()")
    count<-length(res$result$data$`@value`)
  }
  else if(result=='edges'){
    res<-neptune_send_json_query(ep,"g.E()")
    count<-length(res$result$data$`@value`)
  }else{
    res<-neptune_send_json_query(ep,"g.V()")
    vcount<-length(res$result$data$`@value`)
    res<-neptune_send_json_query(ep,"g.E()")
    ecount<-length(res$result$data$`@value`)
    res3<-c(vcount,ecount)
    names(res3)<-c("Vertices","Edges")
    count<-as.data.frame(t(res3))
  }
  
  return(count)
  
}