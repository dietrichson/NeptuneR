# KLADD
library(neptune)
library(jsonlite)
library(httr)

ep <- connect_to_neptune_endpoint('http://ec2-52-201-125-3.compute-1.amazonaws.com')
neptune_raw_json_query(ep,'{"gremlin":"g.V().limit(1)"}')
test1 <- neptune_raw_json_query(ep,'{"gremlin":"g.V().limit(10)"}')
test2 <- neptune_raw_json_query(ep,'{"gremlin":"g.E().limit(10)"}')
test3 <-neptune_send_json_query(ep, "g.E().limit(10)")


res1 <- neptune_parse_results_to_tables(test1)
res2 <- neptune_parse_results_to_tables(test2)
library(visNetwork)

visNetwork(res1$vertices %>% mutate(title=paste0(res1$vertices$name,",",res1$vertices$age,"</b> </p>"),label=label,group=label),
           res2$edges %>% mutate(from=outV,to=inV)
           ) %>%
  visNodes(shape='circle') %>%
  visEdges(arrows='to')


test4 <- with_verbose(
  neptune_raw_json_query(ep,'{"gremlin":"g.addV(\'label1\').property(id, \'customid\') "}')
)

test4 <- with_verbose(
  neptune_raw_json_query(ep,'{"gremlin":"g.V()" }')
)
