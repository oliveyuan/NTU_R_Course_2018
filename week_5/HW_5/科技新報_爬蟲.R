rm(list = ls())
library(bitops)
library(RCurl)
library(tm)
library(NLP)
library(tmcn)
library(jiebaRD)
library(jiebaR)
# 網路爬蟲抓出所有文章內文所對應的網址
library(httr)
library(XML)
from <- 0 #2018/10/14  
to   <- 3 #2018/9/20
prefix  <-  "https://technews.tw/category/cutting-edge/ai/page/"

data <- list()
for( id in c(from:to) )
{
  url  <- paste0( prefix, as.character(id))
  html <- htmlParse( GET(url) )
  url.list <- xpathSApply(html, "//h1[@class='entry-title']/a[@href]", xmlGetAttr, "href" )
  # xpathSApply=找XML nodes , xmlAttrs, xmlGetAttr= 回傳此XML nodes的值(內容)
  data <- rbind(data, as.matrix(url.list))
  
}
data <- unlist(data)
#head(data)

# 利用所有文章的網址去抓所有文章內文, 並解析出文章的內容並依照 hour 合併儲存
library(dplyr)
#url <- "https://technews.tw/2018/09/21/amazon-new-smart-home-products/"
getdoc <- function(url)
{
  #url <- "https://technews.tw/2018/09/21/amazon-new-smart-home-products/"
  html <- htmlParse(GET(url) )
  doc  <- xpathSApply( html, "//article/div[1]/div[2]/div[2]", xmlValue )
  time <- xpathSApply( html, "//header[@class = 'entry-header']/table/tr[2]/td/span[4]", xmlValue )
  temp <- gsub( "  ", " 0", unlist(time) )
  part <- strsplit( temp, split=" ",fixed=T )
  part1 <- strsplit( part[[1]][7], split=":",fixed=T )
  date <- paste(part[[1]][3], part[[1]][5],part1[[1]][1],part1[[1]][2],sep="_")
  
  name <- paste0("ABC",date,".txt")
  write(doc, name, append = TRUE)
 
}
sapply(data, getdoc)


