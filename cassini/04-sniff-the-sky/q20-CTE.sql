-- Common Table Expression (CTE)

with lows_by_week as (
    select date_part('year', time_stamp) as year,
    date_part('week', time_stamp) as week,
    min(altitude) as altitude
    from flyby_altitudes
    group by date_part('year', time_stamp), date_part('week', time_stamp);
), nadirs as (
    --  ?
)
select * from nadirs;

-- We can use the results of the first query ad if they were a table named
-- lows_by_week in the body of the second query

-- But what abut the timestamp? How many of those will I get back? Here's a sample
-- run using the dates from that low flyby in October of 2008:

select
    time_stamp as nadir,
    altitude
from flyby_altitudes
where flyby_altitudes.altitude=28.576
and date_part('year', time_stamp) = 2008
and date_part('week', time_stamp) = 41;

/*
          nadir          | altitude
-------------------------+----------
 2008-10-09 19:06:39.707 |   28.576
 2008-10-09 19:06:39.741 |   28.576
(2 rows)
*/

/*
Cassini flies incredibly fast, and the INMS is snapping readings every 30ms or so. It’s
possible to have some timestamps returned with the exact elevation we’re using as a
filter. Another order of precision for altitude would be beautiful, but I don’t have it so
we’ll have to figure something else out.
I could punt and use limit 1 on this lookup query, that would return the first
timestamp encountered. This wouldn’t be very accurate as it’s just the first one.
I could also use an aggregate function, grabbing the min or the max timestamp — but
again, that’s not very sciency, and I work in a sciency place. Accuracy is important,
precision is a must. I can’t just make a decision like this without having a reason, so I’ll
need to find a better solution.
We’re working with a time window. The nadir of the October 2010 flyby is
somewhere in the middle of those two timestamps, which is the best I can do to
approximate the exact flyby. Unfortunately, this involves some math, which means M.
Sullivan might be knocking on my door later.
I need to take the minimum timestamp and subtract it from the maximum. This will
give me an interval. If I divide that in half and add it back to the minimum, I’ll have a
midway point.
Let’s do it:
*/

select
    min(time_stamp) +
    (max(time_stamp) - min(time_stamp)) / 2
    as nadir,
    altitude
from flyby_altitudes
where flyby_altitudes.altitude=28.576
and date_part('year', time_stamp) = 2008
and date_part('week', time_stamp) = 41
group by altitude;

/*
          nadir          | altitude
-------------------------+----------
 2008-10-09 19:06:39.724 |   28.576
(1 row)
*/

