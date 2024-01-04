-- SIMPLE QUERY
-- Show date, title, eventy_type and target in one table
-- event_type and target come from lookup tables

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
    target_id = (select id from targets where description = 'Enceladus') -- id: 28
order by
    date
limit
    20;

/*
    date    |                     title                     |             event_type              |  target
------------+-----------------------------------------------+-------------------------------------+-----------
 2004-06-21 | ICYLON:  Longitude / Phase Space Coverage     | Icy satellite longitudinal coverage | Enceladus
 2004-06-21 | Enceladus rider                               | Pre-SOI imaging                     | Enceladus
 2005-01-15 | FP3,4 ISS rider                               | Photometry                          | Enceladus
 2005-01-15 | Enceladus distant longitude coverage          | Enceladus                           | Enceladus
 2005-01-15 | ICYLON:  Longitude / Phase Space Coverage     | Icy satellite longitudinal coverage | Enceladus
 2005-01-15 | ICYLON:  Longitude / Phase Space Coverage     | Icy satellite longitudinal coverage | Enceladus
 2005-01-15 | Enceladus distant longitude coverage          | Enceladus                           | Enceladus
 2005-01-15 | FP3,4 ISS rider                               | Photometry                          | Enceladus
 2005-01-15 | ENCELADUS Color Photometry/Polarization       | Photometry                          | Enceladus
 2005-01-15 | FP3,4 stare                                   | CIRS FP3 stare                      | Enceladus
 2005-01-15 | ENCELADUS Color Photometry/Polarization       | Photometry                          | Enceladus
 2005-01-15 | ICYLON:  Longitude / Phase Space Coverage     | Icy satellite longitudinal coverage | Enceladus
 2005-01-15 | Enceladus distant longitude coverage          | Enceladus                           | Enceladus
 2005-01-16 | ICYLON:  Longitude / Phase Space Coverage     | Icy satellite longitudinal coverage | Enceladus
 2005-01-16 | ENCELADUS Color Photometry/Polarization       | Icy satellite longitudinal coverage | Enceladus
 2005-01-16 | ENCELADUS Color Photometry/Polarization       | Icy satellite longitudinal coverage | Enceladus
 2005-01-16 | Enceladus distant longitude coverage UVIS R/A | Enceladus                           | Enceladus
 2005-01-16 | ICYLON:  Longitude / Phase Space Coverage     | Icy satellite longitudinal coverage | Enceladus
 2005-01-16 | Enceladus distant longitude coverage UVIS R/A | Enceladus                           | Enceladus
 2005-01-17 | Enceladus spectrophotometry/ phase coverage   | Spectrophotometry / phase coverage  | Enceladus
(20 rows)

*/