-- CHERRY PICKING THE NADIR
-- Aggregate query, but instead of grouping by time_stamp, 
-- we need to group by something that will separate the data
-- into smaller groups. We can group by years

select
date_part('year', time_stamp) as year,
min(altitude) as nadir
from flyby_altitudes
group by date_part('year', time_stamp);

-- This will show the closest approaches to Enceladus
-- each year a flyby was performed

/*
 year |  nadir
------+---------
 2009 |  98.901
 2015 |  49.010
 2011 |  98.898
 2012 |  73.134
 2005 | 168.012
 2008 |  28.576
 2010 |  45.699
(7 rows)
*/

-- Adding months to the query for a finer interval

select date_part('year', time_stamp) as year,
date_part('month', time_stamp) as month,
min(altitude) as nadir
from flyby_altitudes
group by
date_part('year', time_stamp),
date_part('month', time_stamp);

/*
 year | month |  nadir
------+-------+----------
 2005 |     2 | 1272.075
 2005 |     3 |  500.370
 2005 |     7 |  168.012
 2008 |     3 |   50.292
 2008 |     8 |   53.353
 2008 |    10 |   28.576
 2009 |    11 |   98.901
 2010 |     4 | 3771.195
 2010 |     5 |  437.292
 2010 |     8 | 2555.180
 2010 |    11 |   45.699
 2010 |    12 |   48.324
 2011 |    10 |   98.898
 2011 |    11 |  496.603
 2012 |     3 |   74.165
 2012 |     4 |   74.100
 2012 |     5 |   73.134
 2015 |    10 |   49.010
 2015 |    12 | 5000.200
(19 rows)
*/

select
time_stamp::date as date,
min(altitude) as nadir
from flyby_altitudes
group by
time_stamp::date
order by date;

/*
    date    |   nadir
------------+-----------
 2005-02-17 |  1272.075
 2005-03-09 |   500.370
 2005-07-14 |   168.012
 2008-03-12 |    50.292
 2008-08-11 |    53.353
 2008-10-09 |    28.576
 2008-10-31 |   173.044
 2009-11-02 |    98.901
 2009-11-21 |  1596.561
 2010-04-27 |  3778.264
 2010-04-28 |  3771.195
 2010-05-18 |   437.292
 2010-08-13 |  2555.180
 2010-08-14 | 36876.719
 2010-11-30 |    45.699
 2010-12-21 |    48.324
 2011-10-01 |    98.898
 2011-10-19 |  1230.674
 2011-11-06 |   496.603
 2012-03-27 |    74.165
 2012-04-14 |    74.100
 2012-05-02 |    73.134
 2015-10-14 |  1844.230
 2015-10-28 |    49.010
 2015-12-19 |  5000.200
(25 rows)
*/


