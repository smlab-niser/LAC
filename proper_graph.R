
library(data.table)
a <- data.frame(fread("/data/extracted/random_reconstruction_loss_a.csv"), stringsAsFactors = FALSE)
r_loss1 <- data.frame(fread("/data/extracted/community1_anomaly.csv"))
r_loss2 <- data.frame(fread("/data/extracted/community2_anomaly.csv"))
r_loss3 <- data.frame(fread("/data/extracted/community3_anomaly.csv"))
r_loss4 <- data.frame(fread("/data/extracted/community4_anomaly.csv"))
r_loss5 <- data.frame(fread("/data/extracted/community5_anomaly.csv"))
r_loss6 <- data.frame(fread("/data/extracted/community6_anomaly.csv"))
r_loss7 <- data.frame(fread("/data/extracted/community7_anomaly.csv"))
r_loss8 <- data.frame(fread("/data/extracted/community8_anomaly.csv"))

library(sqldf)
community1 <- sqldf("select names from community where membership = 1")
community2 <- sqldf("select names from community where membership = 2")
community3 <- sqldf("select names from community where membership = 3")
community4 <- sqldf("select names from community where membership = 4")
community5 <- sqldf("select names from community where membership = 5")
community6 <- sqldf("select names from community where membership = 6")
community7 <- sqldf("select names from community where membership = 7")
community8 <- sqldf("select names from community where membership = 8")

loss1 <- cbind(r_loss1,community1)
loss2 <- cbind(r_loss2,community2)
loss3 <- cbind(r_loss3,community3)
loss4 <- cbind(r_loss4,community4)
loss5 <- cbind(r_loss5,community5)
loss6 <- cbind(r_loss6,community6)
loss7 <- cbind(r_loss7,community7)
loss8 <- cbind(r_loss8,community8)

colnames(loss1) <- c("index","loss","names")
colnames(loss2) <- c("index","loss","names")
colnames(loss3) <- c("index","loss","names")
colnames(loss4) <- c("index","loss","names")
colnames(loss5) <- c("index","loss","names")
colnames(loss6) <- c("index","loss","names")
colnames(loss7) <- c("index","loss","names")
colnames(loss8) <- c("index","loss","names")

library(ggplot2)
#ggplot(a, aes(a$index,a$loss))+ geom_point(a[a$display == 1,], size = 10, color = "red") + ylim(-0.050,0.050)

#for community 3,1,6,7
ggplot(data=loss3,aes(x=index,y=loss)) +
  geom_point() +
  geom_point(data=loss3[loss3$display == "yes",],color="red",size=6) + 
  ylim(-0.050,0.060)+ 
  theme(axis.text.x = element_text(face="bold", color="black", size=14, angle=30),
        axis.text.y = element_text(face="bold", color="black", size=14, angle=30))

#for community 2,4,5,8
ggplot(data=loss8,aes(x=index,y=loss)) +
  geom_point() +
  ylim(-0.050,0.060)+ 
  theme(axis.text.x = element_text(face="bold", color="black", size=14, angle=30),
        axis.text.y = element_text(face="bold", color="black", size=14, angle=30))
  

for(i in 1:nrow(a))
{
  if(a[i,6] == 0)
    a[i,6] = "yes"
}

display <- data.frame(display = rep("no",nrow(loss3)))
