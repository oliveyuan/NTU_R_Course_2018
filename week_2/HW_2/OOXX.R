checkAB <- function(symbol){
  
  if(symbol==A){
    print("A win")
    print(graph)
    
    
  }else{
    print("B win")
    print(graph)
  
  }
 
}
#圖形
str1 <- c("1","_","4","_","7")
str2 <- c("|","_","|","_","|")
str3 <- c("2","_","5","_","8")
str4 <- c("|","_","|","_","|")
str5 <- c("3","_","6","_","9")
graph <- data.frame(str1,str2,str3,str4,str5)
names(graph) <- c("1","2","3","4","5")
A <- "O"
B <- "X"
r <- 1

test <- c()

while(T){
  
  print(graph)
#回數判斷
  if(r == 10){
    
    cat("End in a draw!!!\n")
    break
    
  }else if(r%%2==0){
    
    
    symbol <- B
    cat("Round",r,"\n","Now is player B's term!\n")
    input <- (readline("Player B input(1~9) :"))
    
    
  }else if(r%%2!=0){
    
    symbol <- A
    cat("Round",r,"\n","Now is player A's term!\n")
    input <- (readline("Player A input(1~9) :"))
    
  }
#輸入為文字或數字
  if(input == "exit"){
    
  }else{
    
    input <- as.integer(input)
  }
#將輸入存入一向量方便觀察是否重複
  test[r] <- input
#輸入判斷後輸出回應
    if(input == "exit"){
    
      cat("Bye-Bye!!")
      break
      
    }else if(input %in% c(1:9) == F){
      
      cat("Invalid input! Please re-enter!\n")
      
      r <- r-1
     
      
    }else if(input %in% test[1:r-1]){
      
      
      cat("This position is already occupied!\n")
      
      r <- r-1
      
    }else if(input%%3==1){
      
      str1[(input - (as.integer(input/3)))] <- symbol
      
      
    }else if(input%%3==2){
      
      str3[input - as.integer(input/3) - 1] <- symbol
      
      
    }else if(input%%3==0){
      
      str5[input - (as.integer(input/3)+1)] <- symbol
      
    }
  
  
  graph <- data.frame(str1,str2,str3,str4,str5)
  names(graph) <- c("1","2","3","4","5")
  
  
 
#勝利條件判斷
 if(graph[1,1]==symbol && graph[1,3]==symbol && graph[1,5]==symbol){
   checkAB(symbol)
   break
 }else if(graph[3,1]==symbol && graph[3,3]==symbol && graph[3,5]==symbol){
   checkAB(symbol)
   break
 }else if(graph[5,1]==symbol && graph[5,3]==symbol && graph[5,5]==symbol){
   checkAB(symbol)
   break
 }else if(graph[1,1]==symbol && graph[3,1]==symbol && graph[5,1]==symbol){
   checkAB(symbol)
   break
 }else if(graph[1,3]==symbol && graph[3,3]==symbol && graph[5,3]==symbol){
   checkAB(symbol)
   break
 }else if(graph[1,5]==symbol && graph[3,5]==symbol && graph[5,5]==symbol){
   checkAB(symbol)
   break
 }else if(graph[1,1]==symbol && graph[3,3]==symbol && graph[5,5]==symbol){
   checkAB(symbol)
   break
 }else if(graph[1,5]==symbol && graph[3,3]==symbol && graph[5,1]==symbol){
   checkAB(symbol)
   break
 }
  
  
  r <- r+1
  
  
}
