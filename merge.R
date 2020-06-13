library(data.table)
library(tidyverse)
library(readr)
library(lubridate)

only_device <- fread("/data/extracted/logged_user_device.csv", header = TRUE)
only_device <- data.frame(only_device[,2], stringsAsFactors = FALSE)

for(i in 1:nrow(only_device))
{
  k <- only_device[i,1]
  name <- file.path("/data/extracted/device", paste0(k,"_device.csv"))
  name1 <- file.path("/data/extracted/email", paste0(k,"_email.csv"))
  name2 <- file.path("/data/extracted/file1", paste0(k,"_file1.csv"))
  name3 <- file.path("/data/extracted/logon", paste0(k,"_logon.csv"))
  
  device <- fread(name, header = TRUE)
  email <- fread(name1, header = TRUE)
  file1 <- fread(name2, header = TRUE)
  logon <- fread(name3, header = TRUE)
  
  d <- do.call("cbind",list(device[,2],device[,6],"device"))
  e <- do.call("cbind",list(email[,2],email[,9],"email"))
  f <- do.call("cbind",list(file1[,2],file1[,6],"file"))
  l <- do.call("cbind",list(logon[,2],logon[,5],"logon"))
  
  a <- do.call("rbind", list(d,e,f,l))
  p <- data.frame(a)
  h <- as.character(p[,1])
  
  h <- mdy_hms(h)
  
  p <- p[order(h),]
  name4 <- file.path("/data/extracted/merged", paste0(k,"_merged.csv"))
  write.csv(p, file = name4, sep = ",", row.names = FALSE, col.names = TRUE)
  
}

only_device <- fread("logged_user_device.csv", header = TRUE)
only_file <- fread("logged_userfile.csv", header = TRUE)
n <- setdiff(only_file$file_user,only_device$device_file)
n <- data.frame(n)

for(i in 1:nrow(n))
{
  m <- n[i,1]
  #name <- file.path("/data/extracted/device", paste0(m,"_device.csv"))
  name1 <- file.path("/data/extracted/email", paste0(m,"_email.csv"))
  name2 <- file.path("/data/extracted/file1", paste0(m,"_file1.csv"))
  name3 <- file.path("/data/extracted/logon", paste0(m,"_logon.csv"))
  
  #device <- fread(name, header = TRUE)
  email <- fread(name1, header = TRUE)
  file1 <- fread(name2, header = TRUE)
  logon <- fread(name3, header = TRUE)
  
  #d <- do.call("cbind",list(device[,2],device[,6],"device"))
  e <- do.call("cbind",list(email[,2],email[,9],"email"))
  f <- do.call("cbind",list(file1[,2],file1[,6],"file"))
  l <- do.call("cbind",list(logon[,2],logon[,5],"logon"))
  
  a <- do.call("rbind", list(e,f,l))
  p <- data.frame(a)
  h <- as.character(p[,1])
  
  h <- mdy_hms(h)
  
  p <- p[order(h),]
  name4 <- file.path("/data/extracted/merged", paste0(m,"_merged.csv"))
  write.csv(p, file = name4, sep = ",", row.names = FALSE, col.names = TRUE)
  
}

o <- setdiff(LDAP_name$user_id,only_file$file_user)
o <- data.frame(o)
for(i in 1:nrow(o))
{
  m <- o[i,1]
  #name <- file.path("/data/extracted/device", paste0(m,"_device.csv"))
  name1 <- file.path("/data/extracted/email", paste0(m,"_email.csv"))
  #name2 <- file.path("/data/extracted/file1", paste0(m,"_file1.csv"))
  name3 <- file.path("/data/extracted/logon", paste0(m,"_logon.csv"))
  
  #device <- fread(name, header = TRUE)
  email <- fread(name1, header = TRUE)
  #file1 <- fread(name2, header = TRUE)
  logon <- fread(name3, header = TRUE)
  
  #d <- do.call("cbind",list(device[,2],device[,6],"device"))
  e <- do.call("cbind",list(email[,2],email[,9],"email"))
  #f <- do.call("cbind",list(file1[,2],file1[,6],"file"))
  l <- do.call("cbind",list(logon[,2],logon[,5],"logon"))
  
  a <- do.call("rbind", list(e,l))
  p <- data.frame(a)
  h <- as.character(p[,1])
  
  h <- mdy_hms(h)
  
  p <- p[order(h),]
  name4 <- file.path("/data/extracted/merged", paste0(m,"_merged.csv"))
  write.csv(p, file = name4, sep = ",", row.names = FALSE, col.names = TRUE)
  
}