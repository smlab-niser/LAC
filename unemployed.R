setwd("/home/sudipta2/Desktop/r6.2/LDAP")
library(readr)
fold_files <- list.files(pattern = "*.csv", full.names = TRUE)
fold_files <- data.frame(fold_files)
fold_files <- separate(fold_files, fold_files, c("root", "file"), sep ="/")
library(sqldf)
g0 <- data.frame(c("o"), c(1))
colnames(g0) <- c("user_id", "month")
j <- 2
for(i in 2:(nrow(fold_files)-1))
{
  k <- fold_files[i,2]
  q <- as.character(substr(k,1,7))
  d <- read.csv(k, header = TRUE, sep = ",", stringsAsFactors = FALSE)
  m <- sqldf("select user_id from d")
  k1 <- fold_files[i+1,2]
  q1 <- as.character(substr(k1,1,7))
  d1 <- read.csv(k1, header = TRUE, sep = ",", stringsAsFactors = FALSE)
  m1 <- sqldf("select user_id from d1")
  sd <- setdiff(m$user_id,m1$user_id)
  sd <- data.frame(sd)
  sd <- cbind(sd,j)
  colnames(sd) <- c("user_id", "month")
  g0 <- rbind(g0,sd)
  j <- j+1
}
g0 <- data.frame(g0[2:nrow(g0),])
colnames(g0) <- c("user_id", "month")

write.csv(g0, file = "/data/extracted/unemployed1.csv", sep = ",")