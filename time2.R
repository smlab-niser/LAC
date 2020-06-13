a <- do.call("rbind", list(FAJ3101_device,FAJ3101_email,FAJ3101_file, FAJ3101_logon, FAJ3101_http))
p <- data.frame(a)
h <- as.character(p[,2])

library(lubridate)
h <- mdy_hms(h)

p <- p[order(h),]
write.csv(p, file = "ordered_timestamp_FAJ3101.csv", sep = ",", row.names = FALSE, col.names = TRUE)