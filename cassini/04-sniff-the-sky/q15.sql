/*
We need to be sure that all the data we need can be appropriately cast.
The only thing we want to see is the timestamp and the altitude,
and only for the 'ENCELADUS' target.
*/

select
(sclk::timestamp) as time_stamp,
alt_t::numeric(10,3) as altitude
from import.inms
where target='ENCELADUS'
and alt_t IS NOT NULL;

