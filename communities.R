setwd("/data/extracted/to_user_list")

library(data.table)
library(tidyverse)
LDAP <- fread("/home/sudipta2/Desktop/r6.2/LDAP/2009-12.csv")
LDAP_name <- data.frame(LDAP[,2])
adj <- data.frame(rep(1:4000,1))
colnames(adj) <- c("friends")
LDAP_name <- cbind(adj,LDAP_name)
adj1 <- data.frame(rep(0,nrow(LDAP_name)))
adj2 <- adj1

#folder_read <- list.files(pattern = "*.csv") %>% map_df(~fread(.))

library(readr)
fold_files <- list.files(pattern = "*.csv", full.names = TRUE)
fold_files <- data.frame(fold_files)
fold_files <- separate(fold_files, fold_files, c("root", "file"), sep ="/")

library(sqldf)

#for(i in 1:nrow(fold_files))
#{
  #k <- fold_files[i,2]
  #q <- as.character(substr(k,1,7))
  #d <- read.csv(k, header = TRUE, sep = ",", stringsAsFactors = FALSE)
  #d <- data.frame(d[2:nrow(d),])
  #colnames(d) <- c("user")
  #m <- sqldf("select * from d group by user")
  #m <- data.frame(m,stringsAsFactors = FALSE)
  #m[is.na(m)] <- 0
  #for(j in 1: nrow(m))
  #{
    #x <- m[j,1]
    #l <- sqldf(paste0("select friends from LDAP_name where user_id ='",x,"'"))
    #l <- as.integer(l)
    #adj1[l[1,1],1] <- as.character(x)
  #}
  #colnames(adj1) <- q
  #adj2 <- cbind(adj2,adj1)
#}
#adj2 <- adj2[,2:ncol(adj2)]

#g1 <- cbind(adj2[,1], colnames(adj2)[1])
#colnames(g1) <- c("from", "to")

g0 <- data.frame(c("o"), c("o"))
colnames(g0) <- c("from", "to")
for(i in 1:nrow(fold_files))
{
  k <- fold_files[i,2]
  q <- as.character(substr(k,1,7))
  d <- read.csv(k, header = TRUE, sep = ",", stringsAsFactors = FALSE)
  d <- data.frame(d[2:nrow(d),])
  colnames(d) <- c("user")
  m <- sqldf("select * from d group by user")
  g1 <- cbind(m, q)
  colnames(g1) <- c("from", "to")
  g0 <- rbind(g0,g1)
}
g0 <- g0[2:nrow(g0),]
colnames(g0) <- c("from", "to")

library(igraph)
r <- graph.data.frame(g0, directed = FALSE)
p <- cluster_louvain(r)
plot(p,r,vertex.label = NA, vertex.size = 0.2)
b <- data.frame(p$membership, p$names)
colnames(b) <- c("membership", "names")
write.csv(b,"communities.csv", sep = ",")
write.csv(g0, "/home/sudipta2/Desktop/adj.csv", sep = ",")
f <- sqldf("select names from b where membership = 1") #query to see a community, e.g. community 1