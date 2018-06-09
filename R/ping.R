neptune_check_status <- function(conn, expected_codes, response) {

  status_code <- response$status$code
  if (any(expected_codes == status_code)) {
    print("Server is responding")
  } else {
    # TODO - better error handling
    simpleError("Error in response from neptuneDB")
  }
}

#' @title Ping connection
#' @description Check connection.
#' @param ep A Neptune Endpoint
#' @export

neptune_ping <- function(ep) {
    expected_codes <- c(200)
    result<-neptune_send_json_query(ep,"g.V().limit(1)")
    neptune_check_status(conn, expected_codes, result)
  
}