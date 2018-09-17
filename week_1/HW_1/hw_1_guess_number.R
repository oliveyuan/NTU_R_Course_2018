# 猜數字遊戲
# 基本功能
# 1. 請寫一個由"電腦隨機產生"不同數字的四位數(1A2B遊戲)
# 2. 玩家可"重覆"猜電腦所產生的數字，並提示猜測的結果(EX:1A2B)
# 3. 一旦猜對，系統可自動計算玩家猜測的次數

# 額外功能：每次玩家輸入完四個數字後，檢查玩家的輸入是否正確(錯誤檢查)


x <- sample(0:9, size = 4, replace = FALSE)
count <- 0
A <- 0
B <- 0
while(T){
  input <- scan(n=4) 
  count <- count+1
  number <- sum(x %in% input)#總共有多少一樣的數字
  for(i in 1:4){
    if(x[i]==input[i]){
      A <- A+1
    }
  }
  B <- number-A #B的數量是全部-A的數量
  if(A==4){
    print("您答對了")
    print(paste("您總共猜了", count, "次"))
    break
  }else{
    print(paste(A, "A", B, "B"))
  }
  #歸零
  A <- 0
  B <- 0
 
}
