-- REGEX
-- Using regex to find titles that begin with T 
-- and have the word 'flyby' somewhere (case insensitively)
-- (Checking Titan instead of Enceladus)

select
    time_stamp :: date as date,
    title,
    event_types.description as event_type,
    targets.description as target
from
    events
    inner join event_types on event_type_id = event_types.id
    inner join targets on target_id = targets.id
where
    title ~* '^T[A-Z0-9_].*? flyby'
order by
    date
limit
    20;
