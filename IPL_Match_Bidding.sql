USE IPL;

-- 1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.

SELECT ipl_bidding_details.bidder_id,
       Count(ipl_bidding_details.bid_status),
       no_of_bids,
       ( Count(ipl_bidding_details.bid_status) / no_of_bids ) * 100 AS
       PERCENTAGE_WIN
FROM   ipl_bidding_details
       INNER JOIN ipl_bidder_points
               ON ipl_bidding_details.bidder_id = ipl_bidder_points.bidder_id
                  AND ipl_bidding_details.bid_status = 'Won'
GROUP  BY ipl_bidding_details.bidder_id,
          no_of_bids
ORDER  BY percentage_win DESC; 


-- 2.	Display the number of matches conducted at each stadium with stadium name, city from the database.

SELECT 
    ipl_stadium.stadium_id,
    stadium_name,
    city,
    COUNT(ipl_stadium.stadium_id) AS TOTAL_MATCHES
FROM
    ipl_stadium
        INNER JOIN
    ipl_match_schedule ON ipl_stadium.stadium_id = ipl_match_schedule.stadium_id
GROUP BY ipl_stadium.stadium_id , stadium_name
ORDER BY total_matches; 

-- 3.	In a given stadium, what is the percentage of wins by a team which has won the toss?

SELECT 
    stadium_id 'Stadium ID',
    stadium_name 'Stadium Name',
    (SELECT 
            COUNT(*)
        FROM
            ipl_match m
                JOIN
            ipl_match_schedule ms ON m.match_id = ms.match_id
        WHERE
            ms.stadium_id = s.stadium_id
                AND (toss_winner = match_winner)) / (SELECT 
            COUNT(*)
        FROM
            ipl_match_schedule ms
        WHERE
            ms.stadium_id = s.stadium_id) * 100 AS 'Percentage of Wins by teams who won the toss (%)'
FROM
    ipl_stadium s; 


-- 4.	Show the total bids along with bid team and team name.

SELECT Count(bid_team),
       bid_team,
       ipl_team.team_name
FROM   ipl_bidding_details
       INNER JOIN ipl_team
               ON ipl_bidding_details.bid_team = ipl_team.team_id
GROUP  BY bid_team; 


-- 5.	Show the team id who won the match as per the win details.

SELECT win_details,
       match_winner
FROM   ipl_match
GROUP  BY win_details; 


-- 6.	Display total matches played, total matches won and total matches lost by team along with 
-- its team name.

SELECT its.team_id,
       it.team_name,
       Sum(matches_played) AS total_matches_played,
       Sum(matches_won)    AS total_matches_won,
       Sum(matches_lost)   AS total_matches_lost
FROM   ipl_team_standings AS its
       JOIN ipl_team AS it
         ON its.team_id = it.team_id
GROUP  BY team_id; 

-- 7.	Display the bowlers for Mumbai Indians team.

SELECT player_name
FROM   ipl_team_players i1
       JOIN ipl_team i2
         ON i1.team_id = i2.team_id
       JOIN ipl_player i3
         ON i1.player_id = i3.player_id
WHERE  i1.player_role = 'Bowler'
       AND i2.team_name = 'Mumbai Indians'; 


-- 8.	How many all-rounders are there in each team, Display the teams with more than 4 
--       all-rounder in descending order.


SELECT team_name,
       player_role,
       Count(player_role) AS TOTAL
FROM   ipl_team
       INNER JOIN ipl_team_players
               ON Substr(ipl_team.remarks, -2) =
                  Substr(ipl_team_players.remarks, -2)
GROUP  BY player_role,
          team_name
HAVING player_role LIKE 'All-Rounder'
       AND Count(player_role) > 4
ORDER  BY Count(player_role) DESC; 