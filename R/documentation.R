#' Functions to Interact with a AWS Neptune Instance
#'
#'
#' This package contains functions to  interact with AWS Neptune  - a graph
#' databse.
#'
#' Neptune supports both Triple Stores (RDF) and Labeled Property Graphs (LPG}.
#' You can access you graph using gremlin or SPARQL
#' This package provides wrapper functions to the http interface for both.
#'
#' \code{
#' myConn  <- neptune_http_endpoint("http:://<your neptune endpoint>/")
#' }
#'
#' The variable "myConn" can now be used as parameters to other functions.
#'
#' For convenience a default endpoint can also be created with
#' \link{neptune_set_default_endpoint} using the same parameters.
#'
#' Once a endpoint object exists, you may want to make sure it is connecting
#' correctly with the \link{neptune_ping} function. If you are properly connected
#' the response should be like:
#' \preformatted{
#' Response [http://localhost:5984]
#' Status: 200
#' Content-type: text/plain; charset=utf-8
#' Size: 151 B
#' \{"couchdb":"Welcome","uuid":"c1a367c91517195b57ddafe788a72b75","version":"1.4.0","vendor"
#' \{"name":"...
#' }
#'
#' @section Databases:
#'
#' @author Aleksander Dietrichson
#' @docType package
#' @name neptune
require(bitops)
require(RCurl)
require(httr)
require(rjson)
