library(data.table)
email_graph <- fread("/home/sudipta2/Desktop/r6.2/email.csv")
http_sample <- fread("/home/sudipta2/Desktop/r6.2/http.csv")
logon_sample <- fread("/home/sudipta2/Desktop/r6.2/logon.csv")
device_sample <- fread("/home/sudipta2/Desktop/r6.2/device.csv")
file_sample <- fread("/home/sudipta2/Desktop/r6.2/file.csv")


email_graph <- data.frame(email_graph)
colnames(email_graph) <- c("id", "date", "user", "pc", "to", "cc", "bcc", "frm", "activity","size", "attachment", "content")
library(sqldf)
#NFP2441 <- sqldf("select * from email_graph where user ='NFP2441'")
#HDB1666send <- sqldf("select frm from HDB1666 where activity = 'Send'")
#HDB1666http <- sqldf("select * from http_sample where user ='HDB1666'")
#HDB1666logon <- sqldf("select * from logon_sample where user ='HDB1666'")
#HDB1666device <- sqldf("select * from device_sample where user ='HDB1666'")
#HDB1666file <- sqldf("select * from file_sample where user ='HDB1666'")


LDAP <- fread("/home/sudipta2/Desktop/r6.2/LDAP/2009-12.csv")
LDAP_name <- data.frame(LDAP[,2])
for(i in 1:nrow(LDAP_name))
{
  k <- LDAP_name[i,1]
  name <- file.path("/data/extracted/http", paste0(k,"_http.csv"))
  extract <- sqldf(paste0("select * from http_sample where user = '",LDAP_name[i,1],"'"))
  write.csv(extract, file = name, sep =",", row.names = FALSE, col.names = TRUE )
}





