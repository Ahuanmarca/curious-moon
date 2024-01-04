-- REDIRECT TO HTML FILE
-- We can redirect a query to an html file for better readability
-- Specially usefull when the results are very long strings

\H
\o feb_2015_flyby.html
select id, time_stamp, title, description
from enceladus_events where time_stamp::date='2005-02-17' order by time_stamp;

\H
\o mar_2015_flyby.html
select id, time_stamp, title, description
from enceladus_events where time_stamp::date='2005-02-17';