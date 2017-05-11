# NBA_Salary_Analysis

This project is a walk-through of some simple data analysis on National Basketball Association statistics. 
The data is player salaries, per-game stats, and advanced metrics.
We create a linear regression model with feature as statistics and targets as salaries and use this model to find the most overpaid and underpaid NBA players.


# Problem Understanding
In professional sports, contracts for players are often in the millions of dollars, an extremely large amount for most people to even think about. The National Basketball League (NBA) is no exception. Some players are earning more than $10,000,000 this year for their services to their team. 
In this project, I would like to explore the things that make a player earn more money than other players. The project has two aims:
1.	Build a model for predicting how much a player will earn (say next year)
2.	Explore which players are over-valued and which players are under-valued
Data analysis about the NBA has seen a rapid growth in the last 10 to 15 years. A result of this is new and interesting statistics about players that aim to show their effectiveness at certain aspects of the game of basketball. A more detailed look at some of these statistics is in the Data Understanding section, but I will use these advanced statistics, as well as more traditional statistics about players, as player features and their salaries for this years as target variables. Thus, we can perform a regression and use this model to learn interesting things about players and team, as well as predict how much money a player will make next year. 

# Data Understanding
Our aim is to investigate the relationship between player statistics and player salaries. To do this we use player data from basketball-reference.com, a site dedicated to basketball statistics. We will use three datasets from the site, and merge them all to create one dataset that fits our needs. 
The first dataset is simply the player salaries. It contains the name of the player, the team they play for, and their salaries for the rest of their contract (sometimes many years). For this project, we are only interested about the salaries of this year. After loading the dataset, we can first do some exploratory data analysis to get a feel for the data:
Summary: 
    Player               Tm               X2016.17       
 Length:590         Length:590         Min.   :   11534  
 Class :character   Class :character   1st Qu.:  732504  
 Mode  :character   Mode  :character   Median : 2245440  
                                       Mean   : 4996426  
                                       3rd Qu.: 6916667  
                                       Max.   :30963450

We can see there are 590 players with contracts ranging from $11,534 this year to $30,963,450.
A frequency plot of the salaries:
 
Since it slightly resembles a log-normal distribution, we do a frequency plot the log of the salaries:
 
The small normal curve to the left of the above plot could possibly be the contracts for the development league of the NBA, a secondary league where NBA teams send their young players to develop before playing in NBA games. 
The next dataset we import is the traditional statistics for each player for this year (up to March 11th). This includes information such as how many games they have played in, the average number of minutes they play in a game, the number of shots they take and make per game, the percentage of shot they make, the average number of rebounds, steals, blocks, assists, and points scored per game, as well as a couple other averages describing how a player plays. A subset of the summary is shown below:
      BLK              TOV              PF             PS.G      
 Min.   :0.0000   Min.   :0.000   Min.   :0.000   Min.   : 0.00  
 1st Qu.:0.1000   1st Qu.:0.500   1st Qu.:1.200   1st Qu.: 3.90  
 Median :0.3000   Median :0.900   Median :1.700   Median : 6.85  
 Mean   :0.3901   Mean   :1.105   Mean   :1.682   Mean   : 8.42  
 3rd Qu.:0.5000   3rd Qu.:1.500   3rd Qu.:2.275   3rd Qu.:11.20  
 Max.   :2.5000   Max.   :5.800   Max.   :3.800   Max.   :31.00 
These are the summary statistics for (in order) blocks, turnovers, fouls, and points scored per game. Seeing how points determine the outcome of the game, here is a frequency plot of points scored:
 
It has a similar shape to the salary frequency plot. 
The last dataset we will import is a dataset of what are called “advanced metrics”. These statistics are calculated using the traditional statistics described above to try and more accurately describe how a player plays. Some examples of advanced metrics are the following (descriptions are from basketball-reference.com):
PER: Player Efficiency Rating. A normalized measure of per-minute production.
TS%: True Shooting Percentage. A weighted measure of how well a player shoots Free Throws, 2 point Field Goals, and 3 point Field Goals.
RB%: Rebounding Percentage. The number of rebounds a player gets divided by all possible rebound attempts while they are in the game.
USG%: Usage. The percentage of time a team calls plays for a player (uses a player)
WS: Win Shares. An estimate of the number of wins a player has contributed.
BPM: Box Plus/Minus. A normalized estimate of how much a player contributes to a team’s score.
These are in addition to other advanced metrics in the dataset. Overall, these advanced metrics attempt to separate a player’s production from the playing style of the team, hoping to give a more objective look at a player’s production. 
As an example of a normalized metric, here is a frequency plot of for the BPM metric:
 
As anticipated (since it is normalized), it resembles a normal curve. 

