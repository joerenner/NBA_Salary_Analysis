#Load salary data and drop unnecessary columns 
salaries <- read.table("salaries.txt", header = TRUE,sep = ",",quote="", stringsAsFactors=FALSE)
keep <- c("Player", "Tm", "X2016.17")
salaries <- salaries[keep]

#convert from chars to ints
salaries$X2016.17 <- as.numeric(sub('\\$','',as.character(salaries$X2016.17)))
salaries$Rk <- as.numeric(sub('\\$','',as.character(salaries$Rk)))
summary(salaries)

library(ggplot2)
ggplot(data.frame(salaries$X2016.17), aes(salaries$X2016.17)) + geom_freqpoly(bins=25)

#looks like log-normal distribution
sal.log <- log10(salaries$X2016.17)
sallog <- ggplot(data.frame(sal.log), aes(sal.log)) + geom_freqpoly(bins=30)
sallog
#slightly resembles two normal curves
#the smaller one to the left could be D-league contracts

#Load per game stats
perGame <- read.table("pergamestats.txt", header = TRUE,sep = ",",quote="", stringsAsFactors=FALSE)
perGame[is.na(perGame)] <- 0          #Get rid of na values 
perGame <- perGame[, !(names(perGame) == "Rk")]  #Don't need alphabetic ranking

#Problem: players who have been traded during the season have 3+ entries in this table
#1. total stats (what we want to keep) and 2. 3. stats for each team (want to get rid of)
dup <- duplicated(perGame$Player)
perGame <- perGame[!dup,]
summary(perGame)

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


#Join stats
stats <- merge(perGame, advStats, by = c("Player","Pos","Age","Tm","G"))
stats <- stats[, !(names(stats) == "MP.y")]

#Join with salaries
playerData <- merge(stats, salaries, by = c("Player", "Tm"))
