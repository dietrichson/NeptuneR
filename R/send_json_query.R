#' Send a Raw query to Neptune
#'
#' @param ep Endpoint
#' @param jsonQuery The Raw Query (in JSON) to be sent
#' @param as how to return the results
#'
#' @return the result from POST (in JSON)
#' @export
neptune_raw_json_query <- function(ep, jsonQuery, as=c('parsed','text','raw')){
    res <- POST(neptune_base_url(ep), body=jsonQuery,content_type_json())
    content(res,as=match.arg(as))
}

# library(RCurl)
# library(httr)
# library(rjson)
