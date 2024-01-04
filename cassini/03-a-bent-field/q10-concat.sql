-- BUILD INDEX WITH TWO (OR MORE) COLUMNS
-- Used the concat function to concatenate title and description

drop view if exists enceladus_events;
create view enceladus_events as
select
    events.id,
    events.time_stamp,
    events.title,
    events.description,
    event_types.description as event,
    to_tsvector(
        concat(events.description, '',events.title) -- Concats two columns for FTI
    ) as search -- Full Text Indexing
from
    events
    inner join event_types on event_types.id = events.event_type_id
where
    target_id = (select id from targets where description = 'Enceladus')
order by
    time_stamp;

-- Query

/*
enceladus=# select id, title from enceladus_events where search @@ to_tsquery('closest');
  id   |                      title
-------+-------------------------------------------------
 14409 | Enceladus closest approach observations
 14410 | Enceladus closest approach observations
 14411 | Enceladus closest approach observations
 14424 | Enceladus closest approach observations
  9777 | Drag CIRS FOVs across disk at closest approach.
 14405 | Enceladus closest approach observations
 14401 | Enceladus closest approach observations
 14406 | Enceladus closest approach observations
 14407 | Enceladus closest approach observations
 14404 | Enceladus closest approach observations
 14403 | Enceladus closest approach observations
 14408 | Enceladus closest approach observations
 14402 | Enceladus closest approach observations
 14416 | Enceladus closest approach observations
 14417 | Enceladus closest approach observations
 14418 | Enceladus closest approach observations
 14412 | Enceladus closest approach observations
 14419 | Enceladus closest approach observations
 14414 | Enceladus closest approach observations
 14413 | Enceladus closest approach observations
 14415 | Enceladus closest approach observations
 14420 | Enceladus closest approach observations
 14422 | Enceladus closest approach observations
 14421 | Enceladus closest approach observations
 14423 | Enceladus closest approach observations
(25 rows)
*/