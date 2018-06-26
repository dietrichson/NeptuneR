#' Counts total of edges and vertices
#'
#' @param ep Endpoint
#' @param element Select vertices, edges or both
#' @return Displays ammount of vertices, edges or both
#'
#'
#' @export
#' 
#' 
neptune_count_elements<-function(ep,element='both'){
  
  if(element=='vertices'){
    res<-neptune_send_json_query(ep,"g.V().count()")
    count<-res$result$data$`@value`[[1]]$`@value`
  }
  else if(element=='edges'){
    res<-neptune_send_json_query(ep,"g.E().count()")
    count<-res$result$data$`@value`[[1]]$`@value`
  }else{
    res<-neptune_send_json_query(ep,"g.V().count()")
    vcount<-res$result$data$`@value`[[1]]$`@value`
    res<-neptune_send_json_query(ep,"g.E().count()")
    ecount<-res$result$data$`@value`[[1]]$`@value`
    res3<-c(vcount,ecount)
    names(res3)<-c("Vertices","Edges")
    count<-as.data.frame(t(res3))
  }
  
  return(count)
  
}


#' Returns all unique labels for edges and vertices
#'
#' @param ep Endpoint
#' @param element Select vertices or edges
#' @return Returns the unique labels of selected element
#'
#'
#' @export
#' 
#' 
neptune_get_labels<-function(ep, element="vertices"){
  if (element=="vertices"){
    res<-neptune_send_json_query(ep,"g.V().label().dedup()")
    return (res$result$data$`@value`)
  }
  else if (element=="edges"){
    res<-neptune_send_json_query(ep,"g.E().label().dedup()")
    return (res$result$data$`@value`)
  }
  else{
    print("Invalid element type")
  }
  
  
}

#' Counts elements with specified label
#'
#' @param ep Endpoint
#' @param element Select vertices or edges
#' @param label Label to count
#' @return Returns the number of elements with specified label
#'
#'
#' @export
#' 
#' 
#' 
neptune_count_label_elements<-function(ep, element="vertices",label){
  if(missing(label)) stop("No label specified.")
  if(element=="vertices"){
    query<-paste("g.V().has(label,'",label,"').label().groupCount()",sep="")
    res<-neptune_send_json_query(ep,query)
    if(length(res$result$data$`@value`[[1]]$`@value`)==0) stop("No elements found for specified label")
    count<-res$result$data$`@value`[[1]]$`@value`[[2]]$`@value`
  }
  else if(element=="edges"){
    query<-paste("g.E().has(label,'",label,"').label().groupCount()",sep="")
    res<-neptune_send_json_query(ep,query)
    if(length(res$result$data$`@value`[[1]]$`@value`)==0) stop("No elements found for specified label")
    count<-res$result$data$`@value`[[1]]$`@value`[[2]]$`@value`
  }
  else stop("Invalid element type")
  return(count)
}



#' Creates a tree of all the labels and their respective properties
#' @details Note: if a label has no properties, it won't be added to the tree. To see all labels (even those without
#' properties), use \code{\link{neptune_get_labels}} instead
#' 
#' @param ep Endpoint
#' @param element Select vertices or edges
#' @return Returns a data.tree class element with labels and their properties nested. See details for more.
#'
#'
#' @import data.tree
#' @export
#' 
#' 
#' 
neptune_list_properties<-function(ep,element="vertices"){
  if(element=="vertices"){
    res<-neptune_send_json_query(ep,"g.V().group().by(label).by(properties().label().dedup().fold())")
    x<-res$result$data$`@value`[[1]]$`@value`
    
    i<-1
    j<-1
    nodes<-Node$new("Labels")
    while(i<=length(x)){
      if(is.character(x[[i]])){
        y<-nodes$AddChild(x[[i]])
      }
      else{
        j<-1
        while(j<=length(x[[i]]$`@value`)){
          y$AddChild(x[[i]]$`@value`[[j]])
          j<-j+1
        }
      }
      
      i<-i+1
    }
    return(nodes)
  }
  
  if(element=="edges"){
    res<-neptune_send_json_query(ep,"g.E().group().by(label).by(properties().dedup().fold())")
    x<-res$result$data$`@value`[[1]]$`@value`
  } else stop("Invalid element type")
  
  i<-1
  j<-1
  nodes<-Node$new("Labels")
  while(i<=length(x)){
    if(is.character(x[[i]])){
      y<-nodes$AddChild(x[[i]])
    }
    else{
      j<-1
      while(j<=length(x[[i]]$`@value`)){
        y$AddChild(x[[i]]$`@value`[[j]]$`@value`$`key`)
        j<-j+1
      }
    }
    
    i<-i+1
  }
  return(nodes)
}



#' Count number of elements with chosen value in property
#' 
#' @details Note: You need to use '' when passing property and value (for example: property="'name'",value="'marko'");
#' If the property is a reserved name (ID, for example), or the value is not a string, don't use '' (for example: 
#' property="id",value="'aaab111'" or property="'age'",value="40") 
#' 
#' @param ep Endpoint
#' @param element Select vertices or edges
#' @param property Name of the property to search
#' @param value Specific value of selected property to search
#' @return Returns number of results for selected property value.
#'
#'
#' @export
#' 
#' 
#' 
neptune_count_property<-function(ep,element="Vertices",property,value){
  if(element=="vertices"){
    query<-paste("g.V().has(",property,",",value,").count()",sep="")
    res<-neptune_send_json_query(ep,query)
    count<-res$result$data$`@value`[[1]]$`@value`
  }
  else if(element=="edges"){
    query<-paste("g.E().has(",property,",",value,").count()",sep="")
    res<-neptune_send_json_query(ep,query)
    count<-res$result$data$`@value`[[1]]$`@value`
  }
  else stop("Invalid element type")
  return(count)
}