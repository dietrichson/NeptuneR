# KLADD
library(neptune)
library(jsonlite)
library(httr)

ep <- connect_to_neptune_endpoint('http://ec2-52-201-125-3.compute-1.amazonaws.com')
neptune_raw_json_query(ep,'{"gremlin":"g.V().limit(1)"}')
test1 <- neptune_raw_json_query(ep,'{"gremlin":"g.V().limit(10)"}')
test2 <- neptune_raw_json_query(ep,'{"gremlin":"g.E().limit(10)"}')

res1 <- neptune_parse_results_to_tables(test1)
res2 <- neptune_parse_results_to_tables(test2)

library(visNetwork)

visNetwork(res1$verteces %>% mutate(title=label,label=name),
           res2$edges %>% mutate(from=outV,to=inV)
           ) %>%
  visNodes(shape='circle') %>%
  visEdges(arrows='to')
