-- FUZZY SEARCH
-- Using fuzzy search of "flyby" and "fly by" in the title

select
    time_stamp,
    time_stamp :: date as date,
    title,
    event_types.description as event_type,
    targets.description as target
from
    events
    inner join event_types on event_type_id = event_types.id
    inner join targets on target_id = targets.id
where
    target_id = (select id from targets where description = 'Enceladus') -- = 28
    and (title ilike '%flyby%'
    or title ilike '%fly by%')
order by
    time_stamp
-- limit
    -- 20;

/*
    date    |                       title                       |       event_type        |  target
------------+---------------------------------------------------+-------------------------+-----------
 2005-03-09 | Enceladus targeted flyby                          | Enceladus               | Enceladus
 2005-03-09 | Enceladus targeted flyby                          | Enceladus               | Enceladus
 2005-07-14 | Enceladus targeted flyby                          | Enceladus               | Enceladus
 2005-07-14 | Enceladus targeted flyby                          | Enceladus               | Enceladus
 2008-03-12 | Enceladus FLYBY high-resolution regional mapping. | Regional mapping        | Enceladus
 2008-03-12 | Enceladus FLYBY photometry and polarization.      | Photometry/polarization | Enceladus
 2008-08-11 | Enceladus targeted flyby                          | Enceladus               | Enceladus
 2008-10-09 | Enceladus targeted flyby                          | Enceladus               | Enceladus
 2008-10-31 | Enceladus targeted flyby                          | Enceladus               | Enceladus
 2009-11-02 | Enceladus targeted flyby                          | Enceladus               | Enceladus
 2009-11-21 | Enceladus targeted flyby                          | Enceladus               | Enceladus
 2010-04-28 | Enceladus targeted flyby                          | Enceladus               | Enceladus
 2010-05-18 | Enceladus targeted flyby                          | Enceladus               | Enceladus
 2010-08-13 | Enceladus targeted flyby                          | Enceladus               | Enceladus
 2010-11-30 | Enceladus targeted flyby                          | Enceladus               | Enceladus
 2010-12-20 | Enceladus targeted flyby                          | Enceladus               | Enceladus
 2011-10-01 | Enceladus targeted flyby                          | Enceladus               | Enceladus
 2011-10-19 | Enceladus targeted flyby                          | Enceladus               | Enceladus
 2011-11-06 | Enceladus targeted flyby                          | Enceladus               | Enceladus
 2012-03-27 | Enceladus targeted flyby                          | Enceladus               | Enceladus
(20 rows)
*/