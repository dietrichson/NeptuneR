neptune_check_status <- function(conn, expected_codes, response) {

  status_code <- response$status_code
  if (any(expected_codes == status_code)) {
    response
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
  return("Not Implemented Yet!!!")
  try({
    path <- neptune_base_url(ep)
    expected_codes = c(200)
    result <- GET(path)
    neptune_check_status(conn, expected_codes, result)
  })
}
