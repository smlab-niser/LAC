library(data.table)
library(tidyverse)
library(sqldf)
library(R.utils)
library(readr)

setwd("/data/extracted/merge_final")

fold_files <- list.files(pattern = "*.csv", full.names = TRUE)
fold_files <- data.frame(fold_files)
fold_files <- separate(fold_files, fold_files, c("root", "file"), sep ="/")
for(i in 1:nrow(fold_files))
{
  filename <- fold_files[i,2]
data <- fread(filename)
data <- separate(data, date, c("date", "time"), sep =" ")
data <- separate(data, time, c("hour", "minute", "second"), sep = ":")

mon_dates <- sqldf("select date from data where day = 'Thursday' group by date ")

g <- c("o","o","o","o","o")
for(i in 1:nrow(mon_dates))
{
  k <- mon_dates[i,]
  d <- sqldf(paste0("select hour,minute, second, activity from data where date ='",k,"'"))
  g <- rbind(g,d)
}

g <- g[2:nrow(g),]
f <- cbind(as.integer(g$hour), as.integer(g$minute), as.integer(g$second), as.integer(g$activity))

for(i in 1:nrow(f))
{
  for(j in 1:ncol(f))
  {
    f[i,j] <- intToBin(f[i,j])
  }
}
for(i in 1:nrow(f))
{
  for(j in 1:ncol(f))
  {
    if(str_length(f[i,j]) < max(str_length(f[,j])))
    {
      m <- max(str_length(f[,j])) - str_length(f[i,j])
      for(x in 1:m)
      {
        f[i,j] <- paste("0",f[i,j], sep="")
      }
      
    }
  }
}

h <- f
#h[,2] <- f[,2]
colnames(h) <- c("hour", "minute" , "second", "activity")
h <- data.frame(h)
h <- unite(h, sequence, c("hour","minute","second","activity"), sep ="")

u <- data.frame(as.integer(unlist(strsplit(h[1,],""))))
for( i in 2:nrow(h))
{
  v <- data.frame(as.integer(unlist(strsplit(h[i,],""))))
  u <- cbind(u,v)
}
p <- t(u)
name <- file.path(paste0("/data/extracted/binarised_thursday/",substr(filename,1,7),"_binarise.csv"))
write.csv(p, name,sep = ",",row.names = FALSE)
}