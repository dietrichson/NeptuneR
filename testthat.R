library(testthat)
library(neptune)

ep<-connect_to_neptune_endpoint("http://ec2-52-201-125-3.compute-1.amazonaws.com")

##### File: connect_to_neptune_endpoint

#Connect to neptune endpoint
#Expects the result as a neptune endpoint object
expect_is(connect_to_neptune_endpoint("http://ec2-52-201-125-3.compute-1.amazonaws.com"),"neptune_endpoint")

#Neptune base url
#Expects the result as a string
expect_is(neptune_base_url(ep),"character")


##### File: graph_structure_data

#Neptune count elements
expect_is(neptune_count_elements(ep),"data.frame")
expect_is(neptune_count_elements(ep,element = "edges"),"integer")
expect_is(neptune_count_elements(ep,element = "vertices"),"integer")

#Neptune get labels
expect_is(neptune_get_labels(ep),"list")
expect_is(neptune_get_labels(ep,element = "edges"),"list")

#Neptune count label elements
expect_that(neptune_count_label_elements(ep,element="vertices","sdsdsdssd"),throws_error())
expect_is(neptune_count_label_elements(ep,element="vertices","person"),"integer")
expect_that(neptune_count_label_elements(ep,element="edges","sdsdsdssd"),throws_error())
expect_is(neptune_count_label_elements(ep,element="edges","knows"),"integer")

#Neptune list properties
expect_is(neptune_list_properties(ep),"Node")
expect_is(neptune_list_properties(ep,element="edges"),"Node")

#Neptune count property
expect_is(neptune_count_property(ep,element = "vertices", property = "'name'", value = "'marko'"),"integer")
expect_is(neptune_count_property(ep,element = "edges", property = "'weight'", value = "1"),"integer")

##### File: neptune_download

#Neptune download
expect_is(neptune_download(ep),"data.frame")
expect_is(neptune_download(ep,element="edges"),"data.frame")
expect_that(neptune_download(ep,element="aaaa"),throws_error())

#Neptune range download
expect_is(neptune_range_download(ep,from=0,to=4),"data.frame")
expect_is(neptune_range_download(ep,from=0,to=233,element="edges"),"data.frame")
expect_that(neptune_range_download(ep,from=0,to=233,element="eeeeee"),throws_error())

##### File: neptune_load_data
#Testing data loading functions won't be implemented, since it would imply loading unnecesary data to the actual database.

##### File: neptune_parse_results_to_table

#Neptune parse results to table
data<-neptune_send_json_query(ep,"g.V()")
expect_is(neptune_parse_results_to_tables(data),"list")


##### File: ping

#neptune ping
ep2<-connect_to_neptune_endpoint("http://aaaaaaaaaaaaaaa.com")
test_that(neptune_ping(ep),shows_message("Server is responding"))
test_that(neptune_ping(ep2),throws_error())

##### File: send_json_query

#Neptune send json query
expect_that(neptune_send_json_query(ep,"g.V().limit(1)"),prints_text("Succesful query"))
expect_that(neptune_send_json_query(ep,"g.aaaaaaa"),prints_text("Query produced an error!"))
