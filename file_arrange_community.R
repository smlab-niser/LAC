library(data.table)
community <- fread("/data/extracted/communities.csv")

library(sqldf)
community1 <- sqldf("select names from community where membership = 1")
community2 <- sqldf("select names from community where membership = 2")
community3 <- sqldf("select names from community where membership = 3")
community4 <- sqldf("select names from community where membership = 4")
community5 <- sqldf("select names from community where membership = 5")
community6 <- sqldf("select names from community where membership = 6")
community7 <- sqldf("select names from community where membership = 7")
community8 <- sqldf("select names from community where membership = 8")
cm <- list(community1, community2, community3, community4, community5, community6, community7, community8)

cpy <- function(cm,x)
  {
    k <- cm[[x]]
    newdir <- file.path("/data/extracted/community", paste0("community",x))
    
    for(j in 1:nrow(k))
    {
      oldir <- file.path("/data/extracted/merge_final", paste0(k[j,1],"_merged.csv"))
      file.copy(oldir,newdir, copy.mode = TRUE)
    }
   
  }
for(i in 1:length(cm))
{
  cpy(cm,i)
}


