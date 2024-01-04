-- the year/day of year for flybys
-- all days where there's some event with the 'closest' word
-- Used to know which CSVs to get from the INMS files (page 140)

select date_part('year', time_stamp),
to_char(time_stamp, 'DDD')
from enceladus_events
where event like '%closest%';

/*
 date_part | to_char
-----------+---------
      2005 | 048
      2005 | 068
      2005 | 195
      2008 | 072
      2008 | 224
      2008 | 283
      2008 | 305
      2009 | 306
      2009 | 306
      2009 | 325
      2010 | 117
      2010 | 138
      2010 | 225
      2010 | 334
      2010 | 355
      2011 | 274
      2011 | 292
      2011 | 310
      2012 | 087
      2012 | 105
      2012 | 123
      2015 | 287
      2015 | 301
      2015 | 353
(24 rows)
*/


/*
"Perfect. Now I just need to go into each year, find the month subdirectory (which also
has the day of year in the name) and then cherry pick the CSV directories I want."
*/