#' Send a Query to Neptune
#'
#' @param ep Endpoint
#' @param query The Query (in selected type) to be sent
#' @param  type The type (language) of query to use
#' @return the result from POST (in JSON)
#' @export
#' 
neptune_send_json_query <- function(ep,query,type=c("gremlin","sparql"),as=c('parsed','text','raw'),...){
  ifelse (type=="gremlin",jsonQuery<- paste0("{",'"',type,'"',":",'"',query,'"',"}",sep=""),"sparql")
  res <- POST(neptune_base_url(ep), body=jsonQuery, content_type_json(),...)
  content(res,as=match.arg(as))
}

