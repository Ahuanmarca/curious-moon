-- VIEW containing only Enceladus results
-- Displays various columns from events, and the event_types table

drop view if exists enceladus_events;

create view enceladus_events as
select
    events.id,
    events.time_stamp,
    events.title,
    events.description,
    event_types.description as event
from
    events
    inner join event_types on event_types.id = events.event_type_id
where
    target_id = (select id from targets where description = 'Enceladus')
order by
    time_stamp;


/*
Example query
select * from enceladus_events where time_stamp::date='2005-02-17';

This will produce a messy output because some descriptions are very long.
We can redirect the results to an HTML file for much better readabillity.
*/
