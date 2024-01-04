-- AGGREGATE QUERY
-- We can create a table with the number of occurences for each value in a column
-- We want to know which teams were more active during the 2005-03-09 Enceladus flyby
-- We can COUNT the times each team appears, and create a table with that

select count(1) as activity, teams.description -- will count occurences of each team
from events
inner join teams on teams.id=team_id
where time_stamp::date='2005-03-09'
and target_id=28
group by teams.description
order by activity desc;

/*
 activity | description
----------+-------------
       14 | CIRS
       12 | UVIS
       12 | VIMS
        7 | ISS
        3 | CDA
        3 | INMS
        2 | MAG
        1 | RADAR
        1 | RPWS
        1 | MIMI
        1 | CAPS
(11 rows)
*/

/*
CIRS    Composite Infrared Scanner
UVIS    UltraViolet Imaging Spectrograph
VIMS    Visible and Infrared Mass Spectrometer
ISS     Cassini's Imaging System
*/

