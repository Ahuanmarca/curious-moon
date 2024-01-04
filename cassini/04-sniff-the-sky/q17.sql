-- INSPECTING THE DATA
-- Load up the lowest altitude for a given day.
-- First flyby on February 17, 2005

select min(altitude)
from flyby_altitudes
where time_stamp::date='2005-02-17';

/*
   min
----------
 1272.075
(1 row)
*/

-- Lowest point of every flyby
-- We remove the WHERE clause

select time_stamp,
min(altitude)
from flyby_altitudes
group by time_stamp
order by min(altitude);

/*
       time_stamp        |    min
-------------------------+-----------
 2008-10-09 19:06:39.707 |    28.576
 2008-10-09 19:06:39.741 |    28.576
 2008-10-09 19:06:39.673 |    28.577
 2008-10-09 19:06:39.775 |    28.577
 2008-10-09 19:06:39.639 |    28.579
 2008-10-09 19:06:39.809 |    28.580
 2008-10-09 19:06:39.605 |    28.583
 2008-10-09 19:06:39.843 |    28.584
 2008-10-09 19:06:39.571 |    28.589
 2008-10-09 19:06:39.877 |    28.590
 2008-10-09 19:06:39.537 |    28.595
 2008-10-09 19:06:39.911 |    28.596
 2008-10-09 19:06:39.503 |    28.603
 2008-10-09 19:06:39.945 |    28.605
 2008-10-09 19:06:39.469 |    28.612
 2008-10-09 19:06:39.979 |    28.614
 2008-10-09 19:06:39.435 |    28.623
 2008-10-09 19:06:40.013 |    28.625
 2008-10-09 19:06:39.4   |    28.635
 2008-10-09 19:06:40.047 |    28.637
 2008-10-09 19:06:39.366 |    28.648
 2008-10-09 19:06:40.081 |    28.650
 2008-10-09 19:06:39.332 |    28.663
 2008-10-09 19:06:40.115 |    28.665
 
 CONTINUES...
*/
