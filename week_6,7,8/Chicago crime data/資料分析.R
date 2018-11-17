rm(list = ls())
library(httr)
library(jsonlite)
from <- read.csv("https://data.cityofchicago.org/resource/6zsd-86xi.csv")
#只得到1000筆資料
data <- data.frame(from)
data[is.na(data)] <- 0
data <- data[,-(1:8)]
c <- c(2,4,5,6,10,11,12,15,16,18,19,22,23,24,25,26)
data <- data[,-c]
#去除: 2,4,5,10,11,12,15,16,18,19,23,24,25,26(都是2018)
write.table(data, file = "C:/datascience_course/NTU_R_Course_2018/week_6,7,8/芝加哥犯罪資料分析/資料檔.csv", row.names = F, sep=",")
#data[,23]
