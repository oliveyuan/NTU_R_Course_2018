library(httr)

url <- "https://search.api.cnn.io/content?q=trump&size=10"

res = GET(url)

res_json = content(res)

do.call(rbind,res_json$result)

View(data.frame(do.call(rbind,res_json$result)))