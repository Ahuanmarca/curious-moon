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

-- SAMPLE QUERY
select id, time_stamp, title
from enceladus_events
where search @@ to_tsquery('closest');

/*
  id   |       time_stamp       |                      title
-------+------------------------+-------------------------------------------------
 14409 | 2005-02-17 03:00:29-05 | Enceladus closest approach observations
 14410 | 2005-03-09 08:38:01-05 | Enceladus closest approach observations
 14411 | 2005-07-14 19:25:22-05 | Enceladus closest approach observations
 14424 | 2008-03-12 18:36:12-05 | Enceladus closest approach observations
  9777 | 2008-03-12 18:44:42-05 | Drag CIRS FOVs across disk at closest approach.
 14405 | 2008-08-11 20:36:25-05 | Enceladus closest approach observations
 14401 | 2008-10-09 18:28:40-05 | Enceladus closest approach observations
 14406 | 2008-10-31 16:44:54-05 | Enceladus closest approach observations
 14407 | 2009-11-02 07:11:58-05 | Enceladus closest approach observations
 14404 | 2009-11-02 07:56:58-05 | Enceladus closest approach observations
 14403 | 2009-11-21 01:24:50-05 | Enceladus closest approach observations
 14408 | 2010-04-27 23:10:17-05 | Enceladus closest approach observations
 14402 | 2010-05-18 05:09:39-05 | Enceladus closest approach observations
 14416 | 2010-08-13 21:30:59-05 | Enceladus closest approach observations
 14417 | 2010-11-30 11:06:29-05 | Enceladus closest approach observations
 14418 | 2010-12-21 00:33:26-05 | Enceladus closest approach observations
 14412 | 2011-10-01 12:52:26-05 | Enceladus closest approach observations
 14419 | 2011-10-19 08:22:12-05 | Enceladus closest approach observations
 14414 | 2011-11-06 03:58:53-05 | Enceladus closest approach observations
 14413 | 2012-03-27 18:00:09-05 | Enceladus closest approach observations
 14415 | 2012-04-14 13:16:38-05 | Enceladus closest approach observations
 14420 | 2012-05-02 08:31:29-05 | Enceladus closest approach observations
 14422 | 2015-10-14 09:11:30-05 | Enceladus closest approach observations
 14421 | 2015-10-28 14:22:43-05 | Enceladus closest approach observations
 14423 | 2015-12-19 16:49:17-05 | Enceladus closest approach observations
(25 rows)
*/

-- There are two "closest approach" events on November 2
-- What happened on November 2, 2009?

select time_stamp, title
from events
where time_stamp::date='2009-11-02'
order by time_stamp;

/*
       time_stamp       |                       title
------------------------+---------------------------------------------------
 2009-11-02 00:44:00-05 | MAG_Internal_Field_Measurements
 2009-11-02 00:44:00-05 | MAG MAPS RS Campaign
 2009-11-02 00:50:00-05 | Data rate
 2009-11-02 01:13:58-05 | Scatterometry/Radiometry of Enceladus
 2009-11-02 04:38:58-05 |
 2009-11-02 05:42:00-05 | Enceladus encounter
 2009-11-02 06:41:58-05 | MAPS 120EN Campaign
 2009-11-02 06:42:58-05 | Enceladus encounter
 2009-11-02 06:42:58-05 | Enceladus Flyby C/A imaging
 2009-11-02 06:44:00-05 | Data rate
 2009-11-02 07:00:00-05 | ENC INMS-CDA 2009-306T0:42 MMH
 2009-11-02 07:11:58-05 | Enceladus closest approach observations
 2009-11-02 07:11:58-05 | MAPS RS Campaign
 2009-11-02 07:36:58-05 | CIRS_120EN_ENCEL7001_INMS;
 2009-11-02 07:39:58-05 | ICYMAP:  UV Surface Map
 2009-11-02 07:56:58-05 | Enceladus closest approach observations
 2009-11-02 08:03:58-05 | ICYMAP:  UV Surface Map
 2009-11-02 08:03:58-05 | Enceladus encounter
 2009-11-02 08:03:58-05 | Enceladus
 2009-11-02 08:03:58-05 | CIRS_120EN_FP3SPMAP001_PRIME;
 2009-11-02 08:03:58-05 | Enceladus
 2009-11-02 08:11:58-05 | MIMI Satellite & Ring Interactions
 2009-11-02 08:11:58-05 | RPWS Ring Plane Crossing
 2009-11-02 08:13:58-05 | ICYMAP:  UV of plume occulting Saturn
 2009-11-02 08:13:58-05 | CIRS_120EN_ENUVIS001_UVIS
 2009-11-02 08:13:58-05 | Enceladus
 2009-11-02 08:34:00-05 | Enceladus targeted flyby
 2009-11-02 08:41:58-05 | MAPS Survey
 2009-11-02 09:35:00-05 | RPWS CHORUS Campaign
 2009-11-02 09:41:58-05 | CIRS_120EN_FP1STARE001_ENGR
 2009-11-02 09:41:58-05 | ICYMAP:  UV of Plume Occulting Saturn
 2009-11-02 09:41:58-05 | Enceladus
 2009-11-02 09:42:00-05 | Segment Boundary Survey
 2009-11-02 09:42:00-05 | MAG MAPS RS Campaign
 2009-11-02 10:03:58-05 | Enceladus
 2009-11-02 10:03:58-05 | CIRS_120EN_ENFP1MAP001_PRIME;
 2009-11-02 10:03:58-05 | ICYLON:  Icy Satellite Longitude / Phase Coverage
 2009-11-02 11:44:00-05 | ICYLON:  Icy Satellite Longitude / Phase Coverage
 2009-11-02 11:44:00-05 | CIRS_120EN_ENVIMS001_VIMS
 2009-11-02 11:44:00-05 | Enceladus
 2009-11-02 14:04:00-05 | ICYLON:  Icy Satellite Longitude / Phase Coverage
 2009-11-02 14:04:00-05 | CIRS_120TE_ICYLON001_UVIS
 2009-11-02 14:04:00-05 | Tethys
 2009-11-02 14:04:00-05 | Tethys
 2009-11-02 16:00:00-05 | RPWS Inner Survey
 2009-11-02 17:00:00-05 | Data rate End:SApo
 2009-11-02 17:00:00-05 | GSE pass for Enceladus' mass
 2009-11-02 17:00:00-05 | UVIS Interplanetary Hydrogen Survey
 2009-11-02 18:00:00-05 | CIRS_120IC_DSCAL09307_SP
(49 rows)
*/

/*
CHANGE TIME TO UTC
Why do we need to change time to UTC now,
when we haven't done it before???

IT WILL GIVE DIFFERENT RESULTS THIS WAY !!!
*/

select (time_stamp at time zone 'UTC'), title
from events
where (time_stamp at time zone 'UTC')::date='2009-11-02'
order by time_stamp;

/*
      timezone       |                       title
---------------------+---------------------------------------------------
 2009-11-02 02:25:00 | ICYPLU:  Enceladus Plume Observation
 2009-11-02 02:25:00 | High res plume obs at high phase
 2009-11-02 02:25:00 | Enceladus
 2009-11-02 02:25:00 | CIRS_120EN_PLMHRHP001_ISS
 2009-11-02 03:14:00 | CIRS_120EN_PLMHRHP002_ISS
 2009-11-02 03:14:00 | Enceladus
 2009-11-02 03:14:00 | High res plume obs at high phase
 2009-11-02 03:14:00 | Data rate
 2009-11-02 03:14:00 | Warmup with data before Enceladus
 2009-11-02 03:14:00 | ICYPLU:  Enceladus Plume Observation
 2009-11-02 03:29:00 | Data rate
 2009-11-02 05:44:00 | MAG MAPS RS Campaign
 2009-11-02 05:44:00 | MAG_Internal_Field_Measurements
 2009-11-02 05:50:00 | Data rate
 2009-11-02 06:13:58 | Scatterometry/Radiometry of Enceladus
 2009-11-02 09:38:58 |
 2009-11-02 10:42:00 | Enceladus encounter
 2009-11-02 11:41:58 | MAPS 120EN Campaign
 2009-11-02 11:42:58 | Enceladus encounter
 2009-11-02 11:42:58 | Enceladus Flyby C/A imaging
 2009-11-02 11:44:00 | Data rate
 2009-11-02 12:00:00 | ENC INMS-CDA 2009-306T0:42 MMH
 2009-11-02 12:11:58 | Enceladus closest approach observations
 2009-11-02 12:11:58 | MAPS RS Campaign
 2009-11-02 12:36:58 | CIRS_120EN_ENCEL7001_INMS;
 2009-11-02 12:39:58 | ICYMAP:  UV Surface Map
 2009-11-02 12:56:58 | Enceladus closest approach observations
 2009-11-02 13:03:58 | CIRS_120EN_FP3SPMAP001_PRIME;
 2009-11-02 13:03:58 | Enceladus
 2009-11-02 13:03:58 | Enceladus
 2009-11-02 13:03:58 | ICYMAP:  UV Surface Map
 2009-11-02 13:03:58 | Enceladus encounter
 2009-11-02 13:11:58 | RPWS Ring Plane Crossing
 2009-11-02 13:11:58 | MIMI Satellite & Ring Interactions
 2009-11-02 13:13:58 | ICYMAP:  UV of plume occulting Saturn
 2009-11-02 13:13:58 | Enceladus
 2009-11-02 13:13:58 | CIRS_120EN_ENUVIS001_UVIS
 2009-11-02 13:34:00 | Enceladus targeted flyby
 2009-11-02 13:41:58 | MAPS Survey
 2009-11-02 14:35:00 | RPWS CHORUS Campaign
 2009-11-02 14:41:58 | CIRS_120EN_FP1STARE001_ENGR
 2009-11-02 14:41:58 | ICYMAP:  UV of Plume Occulting Saturn
 2009-11-02 14:41:58 | Enceladus
 2009-11-02 14:42:00 | MAG MAPS RS Campaign
 2009-11-02 14:42:00 | Segment Boundary Survey
 2009-11-02 15:03:58 | CIRS_120EN_ENFP1MAP001_PRIME;
 2009-11-02 15:03:58 | ICYLON:  Icy Satellite Longitude / Phase Coverage
 2009-11-02 15:03:58 | Enceladus
 2009-11-02 16:44:00 | Enceladus
 2009-11-02 16:44:00 | ICYLON:  Icy Satellite Longitude / Phase Coverage
 2009-11-02 16:44:00 | CIRS_120EN_ENVIMS001_VIMS
 2009-11-02 19:04:00 | CIRS_120TE_ICYLON001_UVIS
 2009-11-02 19:04:00 | Tethys
 2009-11-02 19:04:00 | Tethys
 2009-11-02 19:04:00 | ICYLON:  Icy Satellite Longitude / Phase Coverage
 2009-11-02 21:00:00 | RPWS Inner Survey
 2009-11-02 22:00:00 | GSE pass for Enceladus' mass
 2009-11-02 22:00:00 | UVIS Interplanetary Hydrogen Survey
 2009-11-02 22:00:00 | Data rate End:SApo
 2009-11-02 23:00:00 | CIRS_120IC_DSCAL09307_SP
(60 rows)
*/

-- TODO: Research the best / correct way to store the dates.
-- When shout I specify TO UTC, when not to do it.
-- We can do it when storing, aldo when querying.