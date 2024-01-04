with lows_by_week as (
    select
        date_part('year', time_stamp) as year, date_part('week', time_stamp) as week,
        min(altitude) as altitude
    from flyby_altitudes
    group by date_part('year', time_stamp), date_part('week', time_stamp)
), nadirs as (
    select (
            min(time_stamp) + (max(time_stamp) - min(time_stamp))/2
        ) as nadir,
        lows_by_week.altitude
    from flyby_altitudes, lows_by_week
    where flyby_altitudes.altitude = lows_by_week.altitude
    and date_part('year', time_stamp) = lows_by_week.year
    and date_part('week', time_stamp) = lows_by_week.week
    group by lows_by_week.altitude
    order by nadir
)
select nadir at time zone 'UTC', altitude
from nadirs;


/*
        timezone           | altitude
-----------------------------+----------
2005-02-16 22:30:12.119-05  | 1272.075
2005-03-09 04:08:03.4725-05 |  500.370
2005-07-14 14:55:22.33-05   |  168.012
2008-03-12 14:06:11.509-05  |   50.292
2008-08-11 16:06:18.574-05  |   53.353
2008-10-09 14:06:39.724-05  |   28.576
2008-10-31 12:14:51.429-05  |  173.044
2009-11-02 02:41:57.707-05  |   98.901
2009-11-20 21:09:56.371-05  | 1596.561
2010-04-27 19:00:01.088-05  | 3771.195
2010-05-18 01:04:40.301-05  |  437.292
2010-08-13 17:30:51.975-05  | 2555.180
2010-11-30 06:53:59.049-05  |   45.699
2010-12-20 20:08:27.146-05  |   48.324
2011-10-01 08:52:25.698-05  |   98.898
2011-10-19 04:22:11.2245-05 | 1230.674
2011-11-05 23:58:53.4805-05 |  496.603
2012-03-27 13:30:08.975-05  |   74.165
2012-04-14 09:01:37.811-05  |   74.100
2012-05-02 04:31:28.949-05  |   73.134
2015-10-14 05:41:28.9765-05 | 1844.230
2015-10-28 10:22:41.55-05   |   49.010
2015-12-19 12:49:16.1135-05 | 5000.200
(23 rows)
*/

