# NBA Salary Analysis
NOTE: The statistics used for this analysis are for the 2016-2017 NBA season THROUGH THE BEGINNING OF MARCH (you can get the full season stats at basketball-reference.com)

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

 ![alt text](https://cloud.githubusercontent.com/assets/11395913/25955896/b3545bf4-366a-11e7-9520-da0123ff00b8.png)
 
Since it slightly resembles a log-normal distribution, we do a frequency plot the log of the salaries:

 ![alt text](https://cloud.githubusercontent.com/assets/11395913/25955914/ba467686-366a-11e7-8d8c-2fa52219ab3c.png)
 
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

 ![alt text](https://cloud.githubusercontent.com/assets/11395913/25955984/e9aff618-366a-11e7-8671-ea30ff3a603d.png)
 
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

 ![alt text](https://cloud.githubusercontent.com/assets/11395913/25955991/f0e3a5b0-366a-11e7-922c-367a17bc13d9.png)
 
As anticipated (since it is normalized), it resembles a normal curve. 
# Data Preparation
Before we can merge the datasets, we need to fix a couple problems with them. Starting with the Salaries data, we need to get rid of all the columns that we aren’t interested in. Then, the values for salaries are read in as strings because there is a ‘$’ symbol with each value. So we have to convert these values into integers by first getting rid of the ‘$’ symbol then casting each value as an integer. 
Next, we prepare the traditional and advanced statistics before we can merge them all. One problem with these datasets is players who have been traded during the year. In the datasets, traded players have 3 entries: one for their total stats, one for their stats on their old team, and one entry for their stats since they got to their new team. The problem is that the stats for their old and new team sometimes have low sample size (only a few games); so, I decided to keep the entry that shows their combined statistics from their old and new teams. 
Now, the datasets are ready to merge. We do this by first performing a SQL-style join on the statistics datasets by the player name and team name. Then, we join this dataset with the salaries by player name and team name again. We are left with a dataset that contains player name, team name, position, age, traditional and advanced statistics, and finally, salary. This datasets has 434 players and 50 variables. 
Next, we do a principle component analysis on all variables except player name, team, position, and salary. A summary shows that over 97% of the variance is contained in the first 20 components, while the other 26 components make up just 3% of the variance. We can visualize the PCA using code from a PCA tutorial (https://www.r-bloggers.com/computing-and-visualizing-pca-in-r/):

 ![alt text](https://cloud.githubusercontent.com/assets/11395913/25956060/11880ad6-366b-11e7-8489-e824696e8546.png)
 
From the plot we can see the Centers (C) and Power Forward (PF) positions (the biggest guys) have the best scores for the component more related to rebounding and blocking shots (ORB,TRB,BLK,DRB), while the Point Guard (PG), Shooting Guard (SG), and Small Forward (SF) positions (smaller guys) have better scores for the shooting (especially 3-point shooting: X3PA, X3P) and assists. 
As the last step before modeling, we normalize the features to have zero mean and a standard deviation of 1.
# Modeling
Now that the data is ready for modeling, we can fit a multiple linear regression model. When looking at the coefficients, the variables with the largest coefficients are not surprising Field Goals per game (number of shots made per game), Attempted Field Goals per game, Total Rebounds per game and Points scored per game (the largest coefficient).
# Evaluation
Here is a summary of the residuals:
Residuals:
      Min        1Q    Median        3Q       Max 
-10998480  -2687593   -462967   2180983  15540902 

So about half of the residuals were less than $2.5 million dollars, which is reasonable considering the range of the salaries of the players.
Here is the regression plot for just the points per game statistic (salary on y axis):

 ![alt text](https://cloud.githubusercontent.com/assets/11395913/25956078/1a605d52-366b-11e7-8b82-6fd4942bfd2d.png)
 
It’s not the best fit, but it’s just one variable.
Now, based on this model, we can figure things out such as what players are the most overpaid and underpaid. We do this by taking the residual of the model on players. The players with the smallest residual are underpaid, and the players with the largest residual are overpaid. Here are the 5 most underpaid players:
                        358                         417 
   "Rudy Gobert\\goberru01" "Tyson Chandler\\chandty01" 
                         13                         156 
        "Alex Len\\lenal01"  "Isaiah Canaan\\canaais01" 
                        297 
    "Mike Tobey\\tobeymi01" 
Rudy Gobert tops the list, and rightfully so. He is a leading candidate for NBA Defensive Player of the Year (best defensive player in the NBA) despite making just $2.2 million a year, making him the 11th highest paid player on his team.
The 5 most overpaid players in the NBA, according to the model, are: 
                          246                           104 
    "Kosta Koufos\\koufoko01" "Denzel Valentine\\valende01" 
                          367                            34 
"Sergio Rodriguez\\rodrise01"     "Ben McLemore\\mclembe01" 
                          241 
       "Kevin Love\\loveke01" 

Kevin Love tops the list of most overpaid player this year in the NBA. This is most likely because he was injured for much of the season, affecting his statistics. He is making $21 million this year.

