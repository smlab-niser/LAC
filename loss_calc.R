library(keras)
library(data.table)
library(sqldf)
community <- fread("/data/extracted/community/communities.csv")
community8 <- sqldf("select names from community where membership = 8")
r_loss <- matrix(0,nrow = nrow(community8), ncol = 1)

for(i in 1:nrow(community8))
{
  k <- community8[1,]
  q <- fread(paste0("/data/extracted/binarised/",k,"_binarise.csv"))
  q <- as.matrix(q)
  q <- k_expand_dims(q, axis =1)
  q <- k_cast(q, dtype = "float32")
  feature <- dim(q)[3]
  encode1 <- layer_lstm(q,input_shape = c(timestep, feature),units = 128, batch_size = 64,  return_sequences = TRUE)
  encode2 <- layer_dense(encode1,units = 64, activation = "softmax")
  encode3 <- layer_dense(encode2,units = feature, activation = "relu")
  decode1 <- layer_dense(encode3,units = 64, activation = "softmax")
  decode2 <- layer_lstm(decode1,units = 128, batch_size = 128,  return_sequences = T)
  decode3 <- layer_dense(decode2, units = feature, activation = "linear")
  
  
  a <- encode1 - decode2
  b <- encode2 - decode1
  c <- encode3 - decode3
  
  n <- dim(a)[1]*dim(a)[2]*dim(a)[3]
  m <- dim(b)[1]*dim(b)[2]*dim(b)[3]
  u <- dim(c)[1]*dim(c)[2]*dim(c)[3]
  
  sum_a <- k_sum(k_sum(a, axis = 2), axis = 2)
  sum_a <- k_eval(sum_a)
  sum_b <- k_sum(k_sum(b, axis = 2), axis = 2)
  sum_b <- k_eval(sum_b)
  sum_c <- k_sum(k_sum(c, axis = 2), axis = 2)
  sum_c <- k_eval(sum_c)
  
  r_loss[i,] <- (sum_a/n) + (sum_b/m) + (sum_c/u) 
}
colnames(r_loss) <- c("loss")
r_loss <- as.data.frame(r_loss)
#d_loss <- cbind(community8$names, r_loss$loss)
#library(ggplot2)
#ggplot(r_loss, aes(x =1:555,y =loss))+ geom_point(col = "red")+geom_line()
#ggplot(r_loss, aes(x =1:555,y = loss))+ geom_point(col = "red")+geom_text(label = community8$names)
write.csv(r_loss, "/data/extracted/community8_anomaly.csv", sep = ",")
