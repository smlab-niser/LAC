library(keras)
library(tensorflow)
library(ruta)
library(data.table)
library(tidyverse)
library(sqldf)
library(reticulate)
library(R.utils)

setwd("/data/extracted/community/community3")

fold_files <- list.files(pattern = "*.csv", full.names = TRUE)
fold_files <- data.frame(fold_files)
fold_files <- separate(fold_files, fold_files, c("root", "file"), sep ="/")


for(i in 13:nrow(fold_files))
{
  k <- substr(fold_files[i,2],1,7)
  path <- file.path(paste0("/data/extracted/binarised/",k,"_binarise.csv"))
  p <- fread(path)
  n <- as.integer(0.5*nrow(p) + 1)
  K <- backend()
  train <- p[1:n,]
  train <- as.matrix(train)
  train <- k_expand_dims(train, axis = 1)
  #test <- p[n:(nrow(p)-2),]
  #test <- as.matrix(test)
  #test <- k_expand_dims(test, axis = 1)
  #test <- k_cast(test, "float32")
  timestep <- dim(train)[2]
  feature <- ncol(p)
  
  input <- layer_input(shape = list(timestep, feature))
encode1 <- layer_lstm(input,units = 128, batch_size = 128,  return_sequences = TRUE)
encode2 <- layer_dense(encode1,units = 64, activation = "softmax")
encode3 <- layer_dense(encode2,units = 22, activation = "relu")
decode1 <- layer_dense(encode3,units = 64, activation = "softmax")
decode2 <- layer_lstm(decode1,units = 128, batch_size = 128,  return_sequences = T)
decode3 <- layer_dense(decode2,units  = dim(p)[[-1]])

encoder <- keras_model(input,encode3)
lstmae <- keras_model(encode3,decode3)
  encoder %>% keras::compile(loss = "mse", optimizer_adam( lr = 0.01, decay = 0.01), metrics = c("accuracy") )
  l %>% keras::compile(loss = "mse", optimizer_adam( lr = 0.01, decay = 0.01), metrics = c("accuracy") )
  for(i in 1:15)
  {
    en <- encoder %>% fit(train,train, epochs = 15, batch_size = 128)
    write.table(en, file = paste0("/data/extracted/pred_results/",k,"_result.txt"), append = TRUE, sep = ",")
  }
  encoder%>%save_model_hdf5(paste0("/data/extracted/models_community3/", k,"_model.hdf5"))
  
}



'''
model <- keras_model_sequential() 
model%>%layer_lstm(input_shape = list(NULL,dim(p)[[-1]]), units = 128, batch_size = 128,  return_sequences = T)%>%
  layer_dense(units = 64, activation = "softmax")%>%
  layer_dense(units = 22, activation = "relu")%>%
  keras::compile(loss = "mse", optimizer_adam( lr = 0.01, decay = 0.01), metrics = c("accuracy") )
model%>%fit(train,train, epochs = 30, batch_size = 128) 
model%>%save_model_hdf5(paste0("/data/extracted/models/", k,"_model.hdf5"))
capture.output(summary(pred_result), file = paste0("/data/extracted/models/results/", k,"_result.txt"))
pred_result <- predict(model, test, batch_size = 128, verbose = 0)
capture.output(summary(pred_result), file = paste0("/data/extracted/models/pred_results/", k,"_pred_result.txt"))




encoder %>% keras::compile(loss = "mse", optimizer_adam( lr = 0.01, decay = 0.01), metrics = c("accuracy") )
en <- encoder %>% fit(train,train, epochs = 1, batch_size = 128) 
'''
