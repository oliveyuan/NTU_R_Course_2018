library(shiny)
library(httr)
library(jsonlite)
library(ggplot2)
library(shinydashboard)
library(rsconnect)
library(leaflet)
data <- function(x){
  from <- read.csv("https://data.cityofchicago.org/resource/6zsd-86xi.csv")
  data <- data.frame(from)
  data[is.na(data)] <- 0
  data <- data[,-(1:8)]
  c <- c(2,4,5,6,10,11,12,15,16,18,19,22,23,24,25,26)
  data <- data[,-c]
  return(data)
}
choose_type <- function(type){
  get_data <- data()
  if(type == "Arrest_rate(all)"){
    arrest_data <- table(get_data[,1])
    label <- names(arrest_data)
    arrest <- data.frame(arrest_data)
    piepercent<-round(100*arrest[,2]/sum(arrest[,2]), 1)
    piepercent <-paste(piepercent, "%", sep = "")
    pie(arrest_data,labels = piepercent,col = topo.colors(length(label)))
    legend("topright",label, cex=0.8,fill=topo.colors(length(label)))
  }else if(type == "Domestic crime_rate"){
    domestic_data <- table(get_data[,5])
    label <- names(domestic_data)
    domestic <- data.frame(domestic_data)
    piepercent<-round(100*domestic[,2]/sum(domestic[,2]), 1)
    piepercent <-paste(piepercent, "%", sep = "")
    pie(domestic_data,labels = piepercent,col = heat.colors(length(label)))
    legend("topright",label, cex=0.8,fill=heat.colors(length(label)))
  }else if(type == "Type of crimes_count"){
    type_data <- as.data.frame(table(get_data[,10])) 
    colnames(type_data) <- c("Type","Freq")
    ggplot(type_data,aes(Type,Freq)) + geom_bar(stat = "identity", color = "black") + coord_flip()
  }else{
    district_data <- as.data.frame(table(get_data[,4]))
    False <- list()
    True <- list()
    for(i in c(1:25)){
      False[i] <- sum(data$district == i & data$arrest == "false")
      True[i] <- sum(data$district == i & data$arrest == "true")
    }
    False <- unlist(False)
    True <- unlist(True)
    arrest <- as.data.frame(cbind(False,True))
    arrest <- arrest[-which(arrest$False == "0"& arrest$True == "0"),]
    arrest_rate <- arrest$True/(arrest$True + arrest$False)
    colnames(district_data) <- c("District","Freq")
    ggplot(district_data, aes(x = District, y = Freq , fill = arrest_rate))+ 
      geom_bar(stat ="identity",position = "identity")
  }
  
  
}
# map <- function(){
#   leaflet() %>%
#     addTiles() %>%  
#     addMarkers(lng=120.239, lat=22.992, popup="000")
# }
ui <- dashboardPage(
  dashboardHeader(title = "Chicago_crime"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("DATA", tabName = "DATA"),
      menuItem("CHART", tabName = "CHART"),
      menuItem("MAP", tabName = "MAP")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem("DATA",
              box(
                headerPanel("DATA"),
                style = 'height:520px ; overflow-x: scroll ; overflow-x: scroll',DT::dataTableOutput('table'),
                width = 12,
                height ="520px"
              ) 
      ),
      tabItem("CHART",
              box(
                headerPanel("CHART"),
                selectInput("Type", "Type",choices = c("Arrest_rate(all)","Domestic crime_rate","Type of crimes_count","Arrest_rate(district)")),
                plotOutput("CHART"),
                width = 12,
                height ="420px"
              )
      ),
      tabItem("MAP",
              box(
                headerPanel("MAP"),
                leafletOutput("MAP"),
                width = 12,
                height ="620px"
              )
              )
    )
    
    
  )
)

server <- function(input, output) {
  output$table <- DT::renderDataTable(
    DT::datatable({data <- data()})
  )
  output$CHART <- renderPlot({
    type <- input$Type
    get_data <- data()
    if(type == "Arrest_rate(all)"){
      arrest_data <- table(get_data[,1])
      label <- names(arrest_data)
      arrest <- data.frame(arrest_data)
      piepercent<-round(100*arrest[,2]/sum(arrest[,2]), 1)
      piepercent <-paste(piepercent, "%", sep = "")
      pie(arrest_data,labels = piepercent,col = topo.colors(length(label)))
      legend("topright",label, cex=0.8,fill=topo.colors(length(label)))
    }else if(type == "Domestic crime_rate"){
      domestic_data <- table(get_data[,5])
      label <- names(domestic_data)
      domestic <- data.frame(domestic_data)
      piepercent<-round(100*domestic[,2]/sum(domestic[,2]), 1)
      piepercent <-paste(piepercent, "%", sep = "")
      pie(domestic_data,labels = piepercent,col = heat.colors(length(label)))
      legend("topright",label, cex=0.8,fill=heat.colors(length(label)))
    }else if(type == "Type of crimes_count"){
      type_data <- as.data.frame(table(get_data[,10])) 
      colnames(type_data) <- c("Type","Freq")
      ggplot(type_data,aes(Type,Freq)) + geom_bar(stat = "identity", color = "black") + coord_flip()
    }else{
      district_data <- as.data.frame(table(get_data[,4]))
      False <- list()
      True <- list()
      for(i in c(1:25)){
        False[i] <- sum(get_data$district == i & get_data$arrest == "false")
        True[i] <- sum(get_data$district == i & get_data$arrest == "true")
      }
      False <- unlist(False)
      True <- unlist(True)
      arrest <- as.data.frame(cbind(False,True))
      arrest <- arrest[-which(arrest$False == "0"& arrest$True == "0"),]
      arrest_rate <- arrest$True/(arrest$True + arrest$False)
      colnames(district_data) <- c("District","Freq")
      ggplot(district_data, aes(x = District, y = Freq , fill = arrest_rate))+ 
        geom_bar(stat ="identity",position = "identity")
    }
  })
   get_data <- data()
   lat <- get_data[,6] 
   lon <- get_data[,9]
   map_data <- as.data.frame(cbind(lat,lon))
   map_data <- map_data[-which(map_data$lat == "0"& map_data$lon == "0"),]
   
   point.df <- data.frame(
     Lat = map_data$lat,
     Long = map_data$lon
   )
   m <- leaflet(point.df) %>%
     addTiles() %>%
     setView(-87.70, 41.80, zoom = 10) %>% 
     addCircleMarkers(lng = ~Long, lat = ~Lat, color = "black",radius = 0.5)
  
  output$MAP <- renderLeaflet(m)
  
}

shinyApp(ui = ui, server = server)

