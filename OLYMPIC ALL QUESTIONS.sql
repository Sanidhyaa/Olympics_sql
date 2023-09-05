20---Break down all olympic games where India won medal for Hockey and how many medals in each olympic games

with cte as(select t2.region,t1.games,t1.sport,t1.medal from olympic as t1 join region as t2 on t1.NOC=t2.NOC),
cte2 as(select * from cte where region = 'India' and sport = 'Hockey'),
cte3 as(select * , count(medal) from cte2 where medal<>'NA' group by 1,2,3,4)
select region,games,sport,sum(count) as total_medals from cte3 group by 1,2,3 order by 4 desc

19---In which Sport/event, India has won highest medals 
 select t2.region,t1.sport,count(*) as total_medals from olympic as t1 join region as t2 on t1.NOC=t2.NOC 
 where medal<>'NA' and region='India'
 group by 1,2 order by 3 desc
 limit 1
 
18---Which countries have never won gold medal but have won silver/bronze medals?

with cte as(select t1.NOC,t2.region,t1.medal from olympic as t1 join region as t2 on t1.NOC=t2.NOC),
cte2 as(select region as country,
sum(case when medal='Gold' then 1 else 0 end) as gold,
sum(case when medal='Silver' then 1 else 0 end) as silver,
sum(case when medal='Bronze' then 1 else 0 end) as bronze
from cte group by 1)
select * from cte2 where gold=0 order by 3 asc, 4 desc

17---Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.

with cte as(select t1.NOC,t1.games,t2.region,t1.medal from olympic as t1 join region as t2 on t1.NOC=t2.NOC),
cte2 as(select region,games,sum(case when medal in ('Gold','Silver','Bronze') then 1 else 0 end) as medal,
sum(case when medal='Gold' then 1 else 0 end) as gold,
sum(case when medal='Silver' then 1 else 0 end) as silver,
sum(case when medal='Bronze' then 1 else 0 end) as bronze
from cte group by 1,2)
select distinct games,concat(first_value(region) over(partition by games order by gold desc)
    			, ' - '
    			, first_value(gold) over(partition by games order by gold desc)) as Max_Gold,
				concat(first_value(region) over(partition by games order by silver desc)
    			, ' - '
    			, first_value(silver) over(partition by games order by silver desc)) as Max_Silver,
				concat(first_value(region) over(partition by games order by bronze desc)
    			, ' - '
    			, first_value(bronze) over(partition by games order by bronze desc)) as Max_Bronze,
				concat(first_value(region) over(partition by games order by medal desc)
    			, ' - '
    			, first_value(medal) over(partition by games order by medal desc)) as Max_Medal from cte2 order by 1

16---Identify which country won the most gold, most silver and most bronze medals in each olympic games.

with cte as(select t1.NOC,t1.games,t2.region,t1.medal from olympic as t1 join region as t2 on t1.NOC=t2.NOC),
cte2 as(select region,games,sum(case when medal in ('Gold','Silver','Bronze') then 1 else 0 end) as medal,
sum(case when medal='Gold' then 1 else 0 end) as gold,
sum(case when medal='Silver' then 1 else 0 end) as silver,
sum(case when medal='Bronze' then 1 else 0 end) as bronze
from cte group by 1,2)
select distinct games,concat(first_value(region) over(partition by games order by gold desc)
    			, ' - '
    			, first_value(gold) over(partition by games order by gold desc)) as Max_Gold,
				concat(first_value(region) over(partition by games order by silver desc)
    			, ' - '
    			, first_value(silver) over(partition by games order by silver desc)) as Max_Silver,
				concat(first_value(region) over(partition by games order by bronze desc)
    			, ' - '
    			, first_value(bronze) over(partition by games order by bronze desc)) as Max_Bronze
				from cte2 order by 1
				
15---List down total gold, silver and bronze medals won by each country corresponding to each olympic games.

with cte as(select t1.NOC,t1.games,t2.region,t1.medal from olympic as t1 join region as t2 on t1.NOC=t2.NOC)
select games,region as Country,
sum(case when medal='Gold' then 1 else 0 end) as gold,
sum(case when medal='Silver' then 1 else 0 end) as silver,
sum(case when medal='Bronze' then 1 else 0 end) as bronze
from cte group by 1,2 order by 1

14---List down total gold, silver and bronze medals won by each country.
with cte as(select t1.NOC,t1.games,t2.region,t1.medal from olympic as t1 join region as t2 on t1.NOC=t2.NOC)
select region as Country,
sum(case when medal='Gold' then 1 else 0 end) as gold,
sum(case when medal='Silver' then 1 else 0 end) as silver,
sum(case when medal='Bronze' then 1 else 0 end) as bronze
from cte group by 1 order by 2 desc,3 desc,4 desc

13---Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.

with cte as(select t1.NOC,t1.games,t2.region,t1.medal from olympic as t1 join region as t2 on t1.NOC=t2.NOC)
select region as Country,
sum(case when medal in ('Gold','Silver','Bronze') then 1 else 0 end) as Medals_Won from cte group by 1 order by 2 desc limit 5

12---Fetch the top 5 athletes who have won the most medals (gold/silver/bronze)

with cte as(select name,team,sum(case when medal in ('Gold','Silver','Bronze') then 1 else 0 end) as Medals_Won from olympic
group by 1,2 order by 3 desc),
cte2 as(select dense_rank() over(order by medals_won desc) as Ranking_of_Players,* from cte)
select * from cte2 where Ranking_of_Players<=5

11---Fetch the top 5 athletes who have won the most gold medals.

with cte as(select name,team,sum(case when medal in ('Gold') then 1 else 0 end) as Gold_Medals_Won from olympic
group by 1,2 order by 3 desc),
cte2 as(select dense_rank() over(order by Gold_medals_won desc) as Ranking_of_Players,* from cte)
select * from cte2 where Ranking_of_Players<=5

10---Find the Ratio of male and female athletes participated in all olympic games.

with cte as(select round((cast(count(case when sex='M' then 1 end) as numeric)/cast(count(*) as numeric))*100,0) as male_count,
round((cast(count(case when sex='F' then 1 end) as numeric)/cast(count(*) as numeric))*100,0) as female_count
from olympic)
select concat('1',':',round(male_count/female_count,0)) as Ratio from cte

09---Fetch oldest athletes to win a gold medal

select name,age from olympic where medal='Gold' order by age desc limit 2

08---Fetch the total no of sports played in each olympic games.

select games,count(distinct(sport)) as Number_Of_Sports from olympic group by 1 order by 2 desc

07---Which Sports were just played only once in the olympics.

select sport,count(distinct(games)) from olympic group by 1 having count(distinct(games))=1

06---Identify the sport which was played in all summer olympics.

with cte as(select * from olympic where games like '%Summer%'),
cte2 as(select sport,count(distinct(games)) as counta from cte group by 1)
select * from cte2 where counta in (select count(distinct games) from cte)

05---Which nation has participated in all of the olympic games

with cte as(select t2.region as country,t1.games from olympic as t1 join region as t2 on t1.NOC=t2.NOC),
cte2 as(select country,count(distinct(games)) as count_of_games from cte group by 1)
select * from cte2 where count_of_games in (select count(distinct games) from cte)

04---Which year saw the highest and lowest no of countries participating in olympics

with cte as(select t2.region as country,t1.games from olympic as t1 join region as t2 on t1.NOC=t2.NOC),
cte2 as(select games,count(distinct country) as country_participation from cte group by 1 order by 2 desc)
select distinct concat(first_value(games) over(order by country_participation desc) ,'-',first_value(country_participation) over(order by country_participation desc)),
concat(first_value(games) over(order by country_participation ) ,'-',first_value(country_participation) over(order by country_participation ))
from cte2

03---Mention the total no of nations who participated in each olympics game?

with cte as(select t2.region as Nations,t1.games from olympic as t1 join region as t2 on t1.NOC=t2.NOC)
select games,count(distinct Nations) from cte group by 1 order by 1

02---List down all Olympics games held so far.

select distinct year,season,city from olympic order by 1 

01---How many olympics games have been held?

select count(distinct games) from olympic