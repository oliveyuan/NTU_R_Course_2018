library(ggplot2)
mydata <-  read.csv("nba.csv")
mydata <- mydata[1:8,1:23]

ggplot(mydata, aes(reorder(PLAYER, GP), GP)) + geom_bar(stat = "identity",fill = "red") + coord_flip()

mydata1 <- mydata[1:30,1:23]
ggplot(mydata1, aes(PLAYER, REB)) + geom_histogram(stat = "identity",fill = "green") + coord_flip()

mydata2 <- mydata[1:100,1:23]
ggplot(mydata2, aes(MIN, PTS )) + geom_point(stat = "identity", color = "blue")

mydata3 <- mydata[1:100,1:23]
ggplot(mydata3, aes(TEAM, AST)) + geom_boxplot()+coord_flip()