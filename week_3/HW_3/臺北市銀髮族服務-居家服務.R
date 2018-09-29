library(ggplot2)
library(maptools)
library(rgeos)
library(Cairo)
library(ggmap)
library(scales)
library(RColorBrewer)
library(mapproj)
library(jsonlite)

#臺北市銀髮族服務-居家服務
data <- fromJSON("https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f432adf0-0e92-473f-a81e-5d5e8ef75965")

lon <-  sapply(data$result$results$LON, as.numeric)
lat <-  sapply(data$result$results$LAT, as.numeric)


map <- get_map(location = c(lon = 121.533937, lat = 25.03933), zoom = 13, language = "zh-TW", maptype = "satellite")
ggmap(map) + geom_point(aes(lon,lat,color="red"), data = data$result$results)