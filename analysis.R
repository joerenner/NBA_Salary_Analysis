#Load salary data and drop unnecessary columns 
salaries <- read.table("salaries.txt", header = TRUE,sep = ",",quote="", stringsAsFactors=FALSE)
keep <- c("Rk", "Player", "Tm", "X2016.17")
salaries <- salaries[keep]

#convert from chars to ints
salaries$X2016.17 <- as.numeric(sub('\\$','',as.character(salaries$X2016.17)))
salaries$Rk <- as.numeric(sub('\\$','',as.character(salaries$Rk)))

library(ggplot2)
ggplot(data.frame(salaries$X2016.17), aes(salaries$X2016.17)) + stat(bins=25)

#looks like log-normal distribution
sal.log <- log10(salaries$X2016.17)
sallog <- ggplot(data.frame(sal.log), aes(sal.log)) + geom_freqpoly(bins=30)
sallog

#slightly resembles two normal curves
#the smaller one to the left could be D-league contracts
