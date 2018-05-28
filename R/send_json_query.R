#' Send a Query to Neptune
#'
#' @param ep Endpoint
#' @param query The Query (in selected type) to be sent
#' @return the result from POST (in JSON)
#' @export
#' 
neptune_send_json_query <- function(ep,query,as=c('parsed','text','raw'),...){
  jsonQuery<- paste0("{",'"',"gremlin",'"',":",'"',query,'"',"}",sep="")
  res <- POST(neptune_base_url(ep), body=jsonQuery, content_type_json(),...)
  
  if(res$status_code == 200){
    print("Succesful query")
  }
  else{
    print("Query produced an error!")
    error<-content(res,as=match.arg(as))
    print(error$`status`$`code`)
  }
  return(content(res,as=match.arg(as)))
}