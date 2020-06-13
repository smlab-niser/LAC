library(data.table)
df_file <- fread("/data/extracted/r6.2/file.csv")
df_decoy <- fread("/data/extracted/r6.2/decoy.csv")

filename <- data.frame(df_file[,5])
colnames(filename) <- c("files")
#filename <- as.list(filename)
decoy <- data.frame(df_decoy[,1])
colnames(decoy) <- c("files")
#t <- setdiff(filename, decoy)

t3<- duplicated(rbind(filename,decoy))[-sequence((nrow(decoy)))]
t3 <- data.frame(t3)
colnames(t3) <- c("t3")




ac <- data.frame(df_file[,6], stringsAsFactors = FALSE)
trm1 <- data.frame(df_file[,7], stringsAsFactors = FALSE)
trm2 <- data.frame(df_file[,8], stringsAsFactors = FALSE)
colnames(ac) <- c('ac')
colnames(trm1) <- c('trm1')
colnames(trm2) <- c('trm2')

library(dplyr)
library(tidyverse)
t3   <- t3 %>% mutate(t3 = as.numeric(t3))
trm1 <- trm1 %>% mutate(trm1 = as.numeric(trm1))
trm2 <- trm2 %>% mutate(trm2 = as.numeric(trm2))

trm <- cbind(ac,trm1,trm2,t3)
trm <- trm %>% unite(activity, c("ac" ,"trm1", "trm2","t3"))