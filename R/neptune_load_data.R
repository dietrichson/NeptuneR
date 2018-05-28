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


#' Load data into your Neptune Instance from a data frame
#'
#' @param data The source data frame
#' @param ep Neptune Endpoint
#' @param definedid Define if the ID is specified in the data (otherwise, it should be set automatically)
#'
#'
#' @return exported data
#' @export
neptune_load_vertex <- function(data, ep,definedid=TRUE){
  
  #Define a funcion to determine if a specific cell is numeric
  numbers_only <- function(x) !grepl("\\D", x)
  
  #Finds all columns with properties
  property <- grep("property",names(data))
  
  #Transforms all elements to characters
  data[]<-lapply(data, as.character)
  
  #Creates a matrix skeleton for the basic query
  addV<-matrix("", nrow=nrow(data),ncol=6)
  addV[,1]<-"g.addV('"
  addV[,3]<-"')"
  
  #Only adds ID if it was specified
  if(definedid==TRUE){
  addV[,4]<-".property(id,'"
  addV[,6] <- "')"
  }else{
    addV[,4]<-""
    addV[,6] <- ""
    
  }
  
  #Adds the label to every row
  for(i in seq_len(nrow(data))){
  addV[i,2] <-data$label[i]
  if(definedid==TRUE) addV[i,5]<-data$id[i]
  }
  
  #Collapses every row to create a basic query (without the rest of the properties)
  addV <- apply(addV, 1, paste, collapse="")
  addV<-as.data.frame(addV, stringsAsFactors=FALSE)


#Main loop that checks every property in the data and adds it to the query  
i<-1

while(i<=nrow(data)){
  j<-property[1]
  while(j<=max(property)){
    if(numbers_only(data[i,j+1])==TRUE){
      addV[i,1]<-paste(addV[i,1],".property('",data[i,j],"',",data[i,j+1],")",sep="")
    }else{
    addV[i,1]<-paste(addV[i,1],".property('",data[i,j],"','",data[i,j+1],"')",sep="")
    }
    j<-j+2
    }
  i<-i+1
  }

#Finally, run each query to load the data
for(i in seq_len(nrow(addV))){
  neptune_send_json_query(ep,addV[i,1])
  print(i)
}

}



#' Load data into your Neptune Instance from a data frame
#'
#' @param data The source data frame
#' @param ep Neptune Endpoint
#' @param definedid Define if the ID is specified in the data (otherwise, it should be set automatically)

#' @return exported data
#' @export
neptune_load_edges<- function(data, ep,definedid=TRUE){
  
  
  #Define a funcion to determine if a specific cell is numeric
  numbers_only <- function(x) !grepl("\\D", x)
  
  #Finds all columns with properties
  property <- grep("property",names(data))
  
  
  #Transforms all elements to characters
  data[]<-lapply(data, as.character)
  
  #Creates a matrix skeleton for the basic query
  
  addE<-matrix("", nrow=nrow(data),ncol=20)
  addE[,1]<-"g.V('"
  addE[,3]<-"').as('"
  addE[,5]<-"').V('"
  addE[,7]<-"').as('"
  addE[,9]<-"').addE('"
  addE[,11]<-"').from('"
  addE[,13]<-"').to('"
  addE[,15]<-"')"
  
  #Only adds ID if it was specified
  if(definedid==TRUE){
    addE[,16]<-".property(id,'"
    addE[,18] <- "')"
  }else{
    addE[,16]<-""
    addE[,18] <- ""
    
  }
  
  #Adds the label to every row
  for(i in seq_len(nrow(data))){
    addE[i,10] <-data$label[i]
    addE[i,12] <-data$from[i]
    addE[i,14] <-data$to[i]
    addE[i,2] <-data$from[i]
    addE[i,4] <-data$from[i]
    addE[i,6] <-data$to[i]
    addE[i,8] <-data$to[i]
    if(definedid==TRUE) addE[i,17]<-data$id[i]
    
  }
  
  
  #Collapses every row to create a basic query (without the rest of the properties)
  addE <- apply(addE, 1, paste, collapse="")
  addE<-as.data.frame(addE, stringsAsFactors=FALSE)
  
  
  #Main loop that checks every property in the data and adds it to the query  
  i<-1
  
  while(i<=nrow(data)){
    j<-property[1]
    while(j<=max(property)){
      if(numbers_only(data[i,j+1])==TRUE){
        addE[i,1]<-paste(addE[i,1],".property('",data[i,j],"',",data[i,j+1],")",sep="")
      }else{
        addE[i,1]<-paste(addE[i,1],".property('",data[i,j],"','",data[i,j+1],"')",sep="")
      }
      j<-j+2
    }
    i<-i+1
  }

  for(i in seq_len(nrow(addE))){
    neptune_send_json_query(ep,addE[i,1])
    print(i)
  }
  
}



  