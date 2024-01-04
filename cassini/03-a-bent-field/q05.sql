-- Query to check targets and event_types in the same view
-- Restricting to 2005-02-17, date of the first Enceladus flyby
-- Also restricting to have only Enceladus as a target

select
    time_stamp,
    targets.description as target,
    event_types.description as event_type
from
    events
    inner join targets on targets.id = events.target_id
    inner join event_types on event_types.id = events.event_type_id
where
    time_stamp :: date = '2005-02-17'
    and target_id = (select id from targets where description = 'Enceladus')
order by
    time_stamp;

/*
       time_stamp       |  target   |               event_type
------------------------+-----------+----------------------------------------
 2005-02-17 00:00:29-05 | Enceladus | Enceladus
 2005-02-17 00:15:29-05 | Enceladus | Icy satellite longitudinal coverage
 2005-02-17 00:15:29-05 | Enceladus | CIRS FP1 integration / FP3 map
 2005-02-17 01:30:29-05 | Enceladus | Enceladus
 2005-02-17 01:30:29-05 | Enceladus | Enceladus
 2005-02-17 01:30:29-05 | Enceladus | Icy satellite longitudinal coverage
 2005-02-17 02:15:29-05 | Enceladus | Icy satellite surface map
 2005-02-17 02:15:29-05 | Enceladus | Enceladus
 2005-02-17 02:15:29-05 | Enceladus | Limb topography
 2005-02-17 02:15:29-05 | Enceladus | Limb topography
 2005-02-17 03:00:29-05 | Enceladus | Enceladus closest approach observation
 2005-02-17 03:00:29-05 | Enceladus | MAPS Campaign
 2005-02-17 03:00:29-05 | Enceladus | Thermal stabilization period
 2005-02-17 03:05:29-05 | Enceladus | Icy satellite exosphere
 2005-02-17 03:05:29-05 | Enceladus | Enceladus dust observation
 2005-02-17 03:05:29-05 | Enceladus | Enceladus dust observation
 2005-02-17 04:00:29-05 | Enceladus | Icy satellite longitudinal coverage
 2005-02-17 04:00:29-05 | Enceladus | Enceladus
 2005-02-17 04:00:29-05 | Enceladus | CIRS FP1 dark side map
 2005-02-17 05:25:29-05 | Enceladus | RSS gravity field determination
 2005-02-17 08:30:29-05 | Enceladus | RADAR Scatterometry / Radiometry
 2005-02-17 11:30:29-05 | Enceladus | Observe Enceladus' plumes
 2005-02-17 11:30:29-05 | Enceladus | Observe Enceladus' plumes
 2005-02-17 11:30:29-05 | Enceladus | Icy satellite longitudinal coverage
(24 rows)
*/

-- Query to read the events.description value for the row with event type
-- "Enceladus closest approach observation", using that value to filter the results

select
    events.description
from
    events
    inner join event_types on event_types.id = events.event_type_id
where
    target_id = (select id from targets where description = 'Enceladus')
    and time_stamp :: date = '2005-02-17'
    and event_types.description = 'Enceladus closest approach observation';

/*
 RPWS observations in the immediate vicinity of Enceladus, including the characterization 
 of the plasma wave spectrum and search for evidence of pickup ions.  Pointing:  prefer RPWS 
 Langmuir Probe within 90 degrees of plasma ram.
(1 row)
*/
