## Test for the functions created

library(neptune)

ep <- connect_to_neptune_endpoint('http://ec2-52-201-125-3.compute-1.amazonaws.com')

#####      QUERY      #######

#1.eptune_json_query : send a simple query directly to neptune

neptune_send_json_query(ep,"g.V()")

####     DATA            ####

#2.data in the package (Edges and Vertex data frames from Tinkerpop example)
data(Data)


#### BASIC STRUCTURE INFORMATION  OF THE NETWORK   #####

#3. neptune_count_elements : count total edges, total vertices or both

totalV <- neptune_count_elements(ep,"vertices")
totalV
totalE <- neptune_count_elements(ep,"edges")
totalE

Total<-neptune_count_elements(ep)
Total

#4. neptune_get_labels: Returns the unique labels of selected element

labelsV <- neptune_get_labels(ep, element="vertices")
labelsE <- neptune_get_labels(ep, element="edges")

#5 Counts elements with specified label

labelV <- neptune_count_label_elements(ep,element ="vertices", label = labelsV[1] )
labelV
labelE<- neptune_count_label_elements(ep,element ="edges", label = labelsE[1] )
labelE


#6 neptune_list_properties :  Creates a tree of all the labels and their respective properties

propV <- neptune_list_properties(ep,element="vertices")
propE <- neptune_list_properties(ep,element="edges")


#7-neptume_count_property:Count number of elements with chosen value in property

count <- neptune_count_property(ep,element="vertices",property = "'name'",value="'marko'")
count

countE <- neptune_count_property(ep,element="edges",property = "'weight'",value="'0.4'")
countE



###### Load data ######

# Load data frame into neptune with edges and vertex
#we first drop the vertex and edges 
neptune_send_json_query(ep,"g.V().drop()")
data(Data)


#8- load vertex and edges from a data frame. the data frame must have the same structure as Vertex and Edges
neptune_load_vertex (Vertex, ep,definedid=TRUE)
neptune_load_edges(Edges,ep, definedid = TRUE)

##### PING ######

#Check connection

neptune_ping(ep)


