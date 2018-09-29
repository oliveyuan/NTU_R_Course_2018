library(httr)
url = "https://stats.nba.com/stats/leagueLeaders?LeagueID=00&PerMode=PerGame&Scope=S&Season=2017-18&SeasonType=Regular+Season&StatCategory=PTS"
response = GET(url)

res_json = content(response)


do.call(rbind,res_json$resultSet$rowSet[1:100])

df <- data.frame(do.call(rbind,res_json$resultSet$rowSet[1:100]))

df <- apply(df,2,as.character)

file_path <- "C:/datascience_course/NTU_R_Course_2018/week_3/nba.csv"
write.table(df, file = file_path, row.names = F, sep=",")
