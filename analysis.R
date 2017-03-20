###DATA UNDERSTANDING AND PREPARATION

#Load salary data and drop unnecessary columns 
salaries <- read.table("salaries.txt", header = TRUE,sep = ",",quote="", stringsAsFactors=FALSE)
keep <- c("Player", "Tm", "X2016.17")
salaries <- salaries[keep]

#convert from chars to ints
salaries$X2016.17 <- as.numeric(sub('\\$','',as.character(salaries$X2016.17)))
summary(salaries)

library(ggplot2)
ggplot(data.frame(salaries$X2016.17), aes(salaries$X2016.17)) + geom_freqpoly(bins=25)

sal.log <- log10(salaries$X2016.17)
sallog <- ggplot(data.frame(sal.log), aes(sal.log)) + geom_freqpoly(bins=30)
sallog

#Load per game stats
perGame <- read.table("pergamestats.txt", header = TRUE,sep = ",",quote="", stringsAsFactors=FALSE)
perGame[is.na(perGame)] <- 0          #Get rid of na values 
perGame <- perGame[, !(names(perGame) == "Rk")]  #Don't need alphabetic ranking

#Problem: players who have been traded during the season have 3+ entries in this table
#1. total stats (what we want to keep) and 2. 3. stats for each team (want to get rid of)
dup <- duplicated(perGame$Player)
perGame <- perGame[!dup,]
summary(perGame)
ggplot(data.frame(perGame$PS.G), aes(perGame$PS.G)) + geom_freqpoly(bins=25)

#Load advanced stats
advStats <- read.table("advancedstats.txt", header = TRUE,sep = ",",quote="", stringsAsFactors=FALSE)
advStats[is.na(advStats)] <- 0          #Get rid of na values 
dropCols <- c("Rk","X","X.1")
advStats <- advStats[, !(names(advStats) %in% dropCols)]  #Don't need certain columns

#Problem: players who have been traded during the season have 3+ entries in this table
#1. total stats (what we want to keep) and 2. 3. stats for each team (want to get rid of)
dup <- duplicated(advStats$Player)
advStats <- advStats[!dup,]
summary(advStats)
ggplot(data.frame(advStats$BPM), aes(advStats$BPM)) + geom_freqpoly(bins=25)

#Join stats
stats <- merge(perGame, advStats, by = c("Player","Pos","Age","Tm","G"))
stats <- stats[, !(names(stats) == "MP.y")]

#Join with salaries
playerData <- merge(stats, salaries, by = c("Player", "Tm"))

#PCA
players.pca <- prcomp(playerData[,4:49], center=TRUE, scale.=TRUE)
summary(players.pca)

###Code obtained from website cited in report
### https://www.r-bloggers.com/computing-and-visualizing-pca-in-r/
library(devtools)
install_github("vqv/ggbiplot")

library(ggbiplot)
win.graph(800,800,10)
g <- ggbiplot(players.pca, obs.scale = 1, var.scale = 1, 
              groups = playerData$Pos, ellipse = TRUE, 
              circle = TRUE)
g <- g + scale_color_discrete(name = '')
g <- g + theme(legend.direction = 'horizontal', 
               legend.position = 'top')
print(g)
###end cited code

# normalize data to zero mean and 1 standard deviation
for (i in 4:49){
  playerData[,i] = scale(playerData[,i])
}

####MODELING

#multiple regression

y <- as.vector(playerData$X2016.17)
x <- as.matrix(playerData[,4:49])

regSal <- lm (y~x)
regSal

####EVALUATION
summary(regSal)

#plot points per game with its coefficient
plot(playerData$PS.G, playerData$X2016.17)
abline(regSal$coefficients[1],regSal$coefficients[27])

#bind residual and players
resids <- cbind(playerData$Player, residuals(regSal))

#order by undervalued first
resids <- resids[order(resids[,2]),]
resids[1:5,1]   #5 most underpaid
n <- nrow(resids)
resids[(n-4):n,1]  #5 most overpaid
