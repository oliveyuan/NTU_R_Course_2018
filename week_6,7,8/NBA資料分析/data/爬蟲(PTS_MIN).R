# 球員
rm(list = ls())
library(httr)
library(jsonlite)
from = 1979
to = 2017
prefix <- "https://stats.nba.com/stats/leagueLeaders?LeagueID=00&PerMode=Totals&Scope=S&Season="
last <- "&SeasonType=Regular+Season&StatCategory=PTS"
#PTS/MIN
for(id in c(from : to)){
  if(((id+1)%%1000)%%100<10){
    id1 <- paste0(0,((id+1)%%1000)%%100)
  }else{
    id1 <- ((id+1)%%1000)%%100
  }
  url <- paste0(prefix,id,"-",id1,last)
  file_path <- paste0("C:/Users/user/Desktop/week_6,7,8/data/PTS_MIN/",id,"-",id1,".csv")
  my.df <- fromJSON(url)
  data <- as.data.frame(my.df$resultSet$rowSet[1:50,2:27])
  names(data) <- my.df$resultSet$headers[2:27]
  #計算
  PPG <- as.numeric((my.df$resultSet$rowSet[1:50,24]))/as.numeric((my.df$resultSet$rowSet[1:50,6]))
  #合併
  data1 <- cbind(data,PPG)
  write.table(data1, file = file_path, row.names = F, sep=",")
}