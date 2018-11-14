library(shiny)
library(ggplot2)
library(markdown)
library(DT)
library(httr)
library(jsonlite)
library(tidyverse)
library(shinydashboard)
rm(list = ls())
data <- function(x){
  from <- fromJSON("https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=34a4a431-f04d-474a-8e72-8d3f586db3df")
  data <- as.data.frame(from)
  data
}
count_time <- function(data){
  one <- sum(data == "01~03")
  two <- sum(data == "04~06")
  three <- sum(data == "07~09")
  four <- sum(data == "10~12")
  five <- sum(data == "13~15")
  six <- sum(data == "16~18")
  seven <- sum(data == "19~21")
  eight <- sum(data == "22~24")
}
count_month <- function(data){
  data <- as.numeric(data)
  data_clear <- (data%%10000-data%%100)/100
  count <- list()
  for(i in c(1:12)){
    count[i] <- sum(data_clear == i)
  }
}
count_place <- function(data){
  data_clear <- substring(data,4,6)
  one <- sum(data_clear == "中正區")
  two <- sum(data_clear == "萬華區")
  three <- sum(data_clear == "大同區")
  four <- sum(data_clear == "中山區")
  five <- sum(data_clear == "松山區")
  six <- sum(data_clear == "大安區")
  seven <- sum(data_clear == "信義區")
  eight <- sum(data_clear == "內湖區")
  nine <- sum(data_clear == "南港區")
  ten <- sum(data_clear == "士林區")
  eleven <- sum(data_clear == "北投區")
  twelve <- sum(data_clear == "文山區")
}
get.plot <- function(type){
  get_data <- data()
  if(type == "時段"){
    data <- get_data$result.results.發生時段
    count_time(data)
    件數 <- list(one,two,three,four,five,six,seven,eight)
    time_title <- list("01~03","04~06","07~09","10~12","13~15","16~18","19~21","22~24")
    time_data <- as.data.frame(cbind(time_title, 件數))
    時段 <- unlist(time_title)
    ggplot(time_data, aes(時段 , 件數)) + geom_bar(stat = "identity",fill = "red")
  }else if(type == "月份"){
    data <- get_data$result.results.發生.現.日期
    count_month(data)
    month_title <- list("JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC")
    title <- factor(month_title, levels=unique(month_title))
    件數 <- count
    month_data <- as.data.frame(cbind(title, 件數))
    月份 <- unlist(title)
    ggplot(month_data, aes(月份 , 件數, fill=month_title)) + geom_bar(stat = "identity",fill = "blue")
  }else{
    data <- get_data$result.results.發生.現.地點
    count_place(data)
    area_title <- list("中正區","萬華區","大同區","中山區","松山區","大安區","信義區","內湖區","南港區","士林區","北投區","文山區")
    件數 <- list(one,two,three,four,five,six,seven,eight,nine,ten,eleven,twelve)
    area_data <- as.data.frame(cbind(area_title, 件數))
    地區 <- unlist(area_title)
    ggplot(area_data, aes(地區 , 件數)) + geom_bar(stat = "identity",fill = "black")
  }
 
}
all_data <- function(x_var,y_var){
  if(x_var == "時段_件數"){
    data <- get_data$result.results.發生時段
    count_time(data)
    件數x <- list(one,two,three,four,five,six,seven,eight)
  }else if(x_var == "月份_件數"){
    data <- get_data$result.results.發生.現.日期
    count_month(data)
    件數x <- count
  }else{
    data <- get_data$result.results.發生.現.地點
    count_place(data)
    件數x <- list(one,two,three,four,five,six,seven,eight,nine,ten,eleven,twelve)
  }
  if(y_var == "時段_件數"){
    data <- get_data$result.results.發生時段
    count_time(data)
    件數y <- list(one,two,three,four,five,six,seven,eight)
  }else if(y_var == "月份_件數"){
    data <- get_data$result.results.發生.現.日期
    count_month(data)
    件數y <- count
  }else{
    data <- get_data$result.results.發生.現.地點
    count_place(data)
    件數y <- list(one,two,three,four,five,six,seven,eight,nine,ten,eleven,twelve)
  }
  
  data1 <- as.data.frame(cbind(件數x,件數y))
  data1
}

ui <- dashboardPage(
  dashboardHeader(title = "住家竊盜分析"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("資料表格", tabName = "資料表格"),
      menuItem("統計資料", tabName = "統計資料"),
      menuItem("k-means分析", tabName = "k-means分析")
      )
  ),
  dashboardBody(
    tabItems(
      tabItem("資料表格",
              box(
                headerPanel("住家竊盜資料"),
                style = 'height:700px ; overflow-x: scroll ; overflow-x: scroll',DT::dataTableOutput('table'),
                width = 12,
                height ="720px"
              ) 
               ),
      tabItem("統計資料",
              box(
                headerPanel("統計圖"),
                selectInput("選擇", "選擇",choices = c("時段","月份","地區")),
                plotOutput("統計圖"),
                width = 12,
                height ="720px"
              )
      ),
      tabItem("k-means分析",
              box(
                headerPanel("k-means"),
                selectInput('xcol', 'X 軸' ,c("時段_件數","月份_件數","地區_件數")),
                selectInput('ycol', 'Y 軸' ,c("時段_件數","月份_件數","地區_件數")),
                numericInput('clusters', 'Cluster count', 3,
                             min = 1, max = 9),
                width = 4,
                height ="350px"
              ),
              box(
                plotOutput("kmeans"),
                width = 8,
                height ="550px"
              )
           )
    )
  )
)


server <- function(input, output, session) {
  
  output$table <- DT::renderDataTable(
    DT::datatable({data <- data()})
  )
  output$統計圖 <- renderPlot({
    type <- input$選擇
    stat <- get.plot(type)
    plot(stat)
  })
  selectedData <- reactive({
    x_var <- input$xcol
    y_var <- input$ycol
    all_data(x_var,y_var)
  })
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
  output$kmeans <- renderPlot({
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
              "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
    
    par(mar = c(5.1, 4.1, 0, 1))
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
  
  
  
}

shinyApp(ui = ui, server = server)

