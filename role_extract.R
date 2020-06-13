library(sqldf)
library(data.table)

LDAP <- fread("/home/sudipta2/Desktop/r6.2/LDAP/2009-12.csv")
x <- sqldf("select role from LDAP group by role")
y <- sqldf("select role, count(*) from LDAP group by role")
colnames(y) <- c("role","number")
#z <- sqldf("select sum(number) from y ")
write.csv(y,"/data/extracted/role/role.csv", col.names = TRUE, sep = ",")
for(i in 1:nrow(x))
{
  a <- sqldf(paste0("select user_id from LDAP where role ='",x[i,1],"'"))
  name <- file.path("/data/extracted/role", paste0(x[i,1],"_role.csv"))
  write.csv(a,name, sep = ",",col.names = TRUE)
}