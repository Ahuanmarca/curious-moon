-- BINGO
-- Flybys can't be a single day apart, they have to be separated by
-- around two weeks, so Cassini can slingshot aroung Titan or Saturn.
-- We try the query one more time, grouping by week.

select
date_part('year', time_stamp) as year,
date_part('week', time_stamp) as week,
min(altitude) as altitude
from flyby_altitudes
group by
date_part('year', time_stamp),
date_part('week', time_stamp);

/*
 year | week | altitude
------+------+----------
 2005 |    7 | 1272.075
 2005 |   10 |  500.370
 2005 |   28 |  168.012
 2008 |   11 |   50.292
 2008 |   33 |   53.353
 2008 |   41 |   28.576
 2008 |   44 |  173.044
 2009 |   45 |   98.901
 2009 |   47 | 1596.561
 2010 |   17 | 3771.195
 2010 |   20 |  437.292
 2010 |   32 | 2555.180
 2010 |   48 |   45.699
 2010 |   51 |   48.324
 2011 |   39 |   98.898
 2011 |   42 | 1230.674
 2011 |   44 |  496.603
 2012 |   13 |   74.165
 2012 |   15 |   74.100
 2012 |   18 |   73.134
 2015 |   42 | 1844.230
 2015 |   44 |   49.010
 2015 |   51 | 5000.200
(23 rows)
*/

-- Each one of these dates corresponds with the published flyby dates, except for the first one.
-- Next part of the puzzle: getting the exact timestamp.
