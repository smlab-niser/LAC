#for device logs
setwd("/data/extracted/device")
library(readr)
fold_files <- list.files(pattern = "*.csv", full.names = TRUE)
fold_files <- data.frame(fold_files)
fold_files <- separate(fold_files, fold_files, c("root", "file"), sep ="/")

g0 <- data.frame(c("o"))
colnames(g0) <- c("file")
for(i in 1:nrow(fold_files))
{
  p <- file.info(fold_files[i,2])
  q <- p$size
  if(q > 47)
  {
    t <- data.frame(substr(fold_files[i,2],1,7))
    colnames(t) <- c("file")
    g0 <- rbind(g0,t)
  }
}
g0 <- data.frame(g0[2:nrow(g0),])
colnames(g0) <- c("device_file")
write.csv(g0,"/data/extracted/logged_user.csv", sep = ",")


#for file logs
setwd("/data/extracted/file")
library(readr)
fold_files <- list.files(pattern = "*.csv", full.names = TRUE)
fold_files <- data.frame(fold_files)
fold_files <- separate(fold_files, fold_files, c("root", "file"), sep ="/")

g0 <- data.frame(c("o"))
colnames(g0) <- c("file")
for(i in 1:nrow(fold_files))
{
  p <- file.info(fold_files[i,2])
  q <- p$size
  if(q > 100)
  {
    t <- data.frame(substr(fold_files[i,2],1,7))
    colnames(t) <- c("file")
    g0 <- rbind(g0,t)
  }
}
g0 <- data.frame(g0[2:nrow(g0),])
colnames(g0) <- c("file_user")
write.csv(g0,"/data/extracted/logged_userfile.csv", sep = ",")
