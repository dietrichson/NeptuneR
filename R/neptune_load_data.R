#' Load data into your Neptune Instance
#'
#' @param data
#' @param endpoint
#' @param S3_endpoint
#' @param AWS_accessKey
#' @param AWS_secret
#'
#' @return parsed message from AWS
#' @export
neptune_load_data <- function(data, endpoint,S3_endpoint,AWS_accessKey,AWS_secret){
  cat('Not implemented Yet!')
}


#' Load data into your Neptune Instance from a data table
#'
#' @param data
#' @param endpoint
#' @param 
#' @param 
#' @param 
#'
#' @return parsed message from AWS
#' @export
neptune_load_data_frame <- function(data, endpoint ){
 property <- grep("property",names(data))

  addV<-matrix(0, nrow=nrow(data),ncol=6)
  addV[,1]<-"g.addV('"
  addV[,3]<-"')"
  addV[,4]<-".property(id,'"
  addV[,6] <- "')"
  for(i in seq_len(nrow(data))){
  addV[i,2] <-data$label[i]
  addV[i,5]<-data$id[i]
  }
  
addV <- apply(addV, 1, paste, collapse="")
addV<-as.data.frame(addV)

properties<-matrix(".property(", nrow=nrow(data), ncol=length(property))
properties2 <- matrix( , nrow=nrow(data),ncol=lenght(property)

}
