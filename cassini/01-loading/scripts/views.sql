-- 
-- MATERIALIZED VIEW
-- The only way we can index a view is if it exists on disk
-- The only difference in the creation query is the 'materialized' keyword

drop view if exists enceladus_events;
create materialized view enceladus_events as -- creates materialized view
select
    events.id,
    events.time_stamp,
    events.title,
    events.description,
    event_types.description as event,
    to_tsvector(
        concat(events.description, '',events.title) -- Concats two columns foos tsvector
    ) as search -- Full Text Indexing
from
    events
    inner join event_types on event_types.id = events.event_type_id
where
    target_id = (select id from targets where description = 'Enceladus')
order by
    time_stamp;
-- We can create the index thanks to to_tsvector
create index idx_event_search
on enceladus_events using GIN(search);
--
--