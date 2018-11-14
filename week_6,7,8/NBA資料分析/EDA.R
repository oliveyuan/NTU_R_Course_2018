rm(list = ls())
library(readr)
library(dplyr)
library(ggplot2)
library(openintro)

# 讀取檔案
filenames <- list.files("C:/Users/user/Desktop/week_6,7,8/data/3PA", pattern="*.csv",full.names = T)
filenames1 <- list.files("C:/Users/user/Desktop/week_6,7,8/data/3P_PCT", pattern="*.csv",full.names = T)
filenames2 <- list.files("C:/Users/user/Desktop/week_6,7,8/data/OREB", pattern="*.csv",full.names = T)
filenames3 <- list.files("C:/Users/user/Desktop/week_6,7,8/data/PTS_MIN", pattern="*.csv",full.names = T)
filenames4 <- list.files("C:/Users/user/Desktop/week_6,7,8/data/DREB", pattern="*.csv",full.names = T)
name <- gsub("C:/Users/user/Desktop/week_6,7,8/data/3PA/","",filenames)
name1 <- gsub("C:/Users/user/Desktop/week_6,7,8/data/3P_PCT/","",filenames1)
年 <- gsub(".csv","",name)
年_三分命中率 <- gsub(".csv","",name1)
read <-  function(csv){
  read.csv( csv, stringsAsFactors = FALSE)
}
Three_PA <- lapply(filenames, read)#class(Three_PA)=list
Three_PCT <- lapply(filenames1, read)#檔案數不同
OREB <- lapply(filenames2, read)
PTS_MIN<- lapply(filenames3, read)
DREB <- lapply(filenames4, read)
file_len <- length(Three_PA)#共39個檔案
file_len1 <- length(Three_PCT)#共24個檔案
# 平均三分球出手數分析
平均三分出手數 <- list()
for(i in c(1:file_len)){
  # 轉換資料型態
  ThreePA <- Three_PA[[i]]
  len <- length(ThreePA$FG3A)
  sum <- sum(ThreePA$FG3A)
  平均三分出手數[i] <- sum/len
}
平均三分出手數 <- unlist(平均三分出手數)
Data <- data.frame(年=年,平均三分出手數=平均三分出手數,stringsAsFactors = F)
# 繪製折線圖
ggplot(Data, aes(年,平均三分出手數)) + geom_point(stat = "identity", color = "blue") +theme(axis.text.x = element_text(angle = 90))

#三分球平均命中率
平均三分命中率 <- list()
for(i in c(1:file_len1)){
  # 轉換資料型態
  ThreePCT <- Three_PCT[[i]]
  len <- length(ThreePCT$FG3_PCT)
  sum <- sum(ThreePCT$FG3_PCT)
  平均三分命中率[i] <- sum/len
}
平均三分命中率 <- unlist(平均三分命中率)
Data1 <- data.frame(年_三分命中率=年_三分命中率,平均三分命中率=平均三分命中率,stringsAsFactors = F)
ggplot(Data1, aes(年_三分命中率,平均三分命中率)) + geom_point(stat = "identity", color = "blue") +theme(axis.text.x = element_text(angle = 90))

# 進攻籃板
進攻籃板 <- list()
for(i in c(1:file_len)){
  # 轉換資料型態
  OREB_V <- OREB[[i]]
  len <- length(OREB_V$OREB)
  sum <- sum(OREB_V$OREB)
  進攻籃板[i] <- sum/len
}
進攻籃板 <- unlist(進攻籃板)
Data1 <- data.frame(年=年,進攻籃板=進攻籃板,stringsAsFactors = F)
ggplot(Data1, aes(年,進攻籃板)) + geom_point(stat = "identity", color = "blue") +theme(axis.text.x = element_text(angle = 90))

#防守籃板
防守籃板 <- list()
for(i in c(1:file_len)){
  # 轉換資料型態
  DREB_V <- DREB[[i]]
  len <- length(DREB_V$DREB)
  sum <- sum(DREB_V$DREB)
  防守籃板[i] <- sum/len
}
防守籃板 <- unlist(防守籃板)
Data1 <- data.frame(年=年,防守籃板=防守籃板,stringsAsFactors = F)
ggplot(Data1, aes(年,防守籃板)) + geom_point(stat = "identity", color = "blue") +theme(axis.text.x = element_text(angle = 90))

# 平均得分效率
平均得分效率 <- list()
for(i in c(1:file_len)){
  # 轉換資料型態
  PTSMIN <- PTS_MIN[[i]]
  len <- length(PTSMIN$PPG)
  sum <- sum(PTSMIN$PPG)
  平均得分效率[i] <- sum/len
}
平均得分效率 <- unlist(平均得分效率)
Data1 <- data.frame(年=年,平均得分效率=平均得分效率,stringsAsFactors = F)
ggplot(Data1, aes(年,平均得分效率)) + geom_point(stat = "identity", color = "blue") +theme(axis.text.x = element_text(angle = 90))