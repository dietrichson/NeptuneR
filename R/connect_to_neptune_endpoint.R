#' Title
#'
#' @param host
#' @param port Port for the connection (defaults to 8182)
#' @param https
#' @param type c('gremlin', 'sparql')
#'
#' @return
#' @export
connect_to_neptune_endpoint <- function(host,
                                        port = 8182,
                                        https = FALSE,
                                        type=c('gremlin','sparql')
) {

  ep <- list(http_host = host,
             http_port = port,
             type = match.arg(type))
  class(ep) <- "neptune_endpoint"
  ep
}



#' Title
#'
#' @param ep Endpoint
#'
#' @return Full URL
#' @export
neptune_base_url <- function(ep){
  paste(ep$http_host, ":", ep$http_port,"/",ep$type, sep = "")
}

#' @title Print method for Neptune Endpoint
#' @description Prints theNeptune Endpoint object.
#' @param ep A neptune endpoint
#' @method print couch_connection
print.neptune_endpoint <- function(ep) {
  full_url <-
  print(
    paste("Neptune Endpoint: (", neptune_base_url(ep), ")")
  )
}
