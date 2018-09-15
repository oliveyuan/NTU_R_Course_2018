my.height.cm <- 168
my.weight.kg <- 68
my.height.m <- my.height.cm/100
bmi <- (my.weight.kg)/(my.height.m)^2

if(bmi>=35){
  print(paste("Your bmi: ", bmi))
  print("重度肥胖!")
}else if(bmi>=30&bmi<35){
  print(paste("Your bmi: ", bmi))
  print("中度肥胖!")
}else if(bmi>=27&bmi<30){
  print(paste("Your bmi: ", bmi))
  print("輕度肥胖!")
}else if(bmi>=24&bmi<27){
  print(paste("Your bmi: ", bmi))
  print("過重!")
}else if(bmi>=18.5&bmi<24){
  print(paste("Your bmi: ", bmi))
  print("正常範圍!")
}else if(bmi<18.5){
  print(paste("Your bmi: ", bmi))
  print("體重過輕!")
}

