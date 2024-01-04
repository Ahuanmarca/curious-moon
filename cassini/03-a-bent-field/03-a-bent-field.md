# A Bent Field

- [A Bent Field](#a-bent-field)
  - [Sargeable and Non-Sargeable Queries](#sargeable-and-non-sargeable-queries)
  - [Using a View to make querying easier](#using-a-view-to-make-querying-easier)
  - [Output to HTML file](#output-to-html-file)
  - [Full Text Queries](#full-text-queries)
  - [Aggregate Queries](#aggregate-queries)
  - [Concat](#concat)
  - [Materialized Views](#materialized-views)

## Sargeable and Non-Sargeable Queries

The word "sargeable" is goofy DBA-speak for Search ARGument ABLE. Put another way: can the string query be optimized? A sargeable query can be optimized, a non-sargeable query can't.

**TODO:** Read about sargeable and non-sargeable queries

- [Top](#a-bent-field)

## Using a View to make querying easier

Views are stored snippets of SQL.

``` sql
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
```

- [Top](#a-bent-field)

## Output to HTML file

``` sql
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
```

- [Top](#a-bent-field)

## Full Text Queries

``` sql
-- ENABLE FULL TEXT INDEXING
-- Tweak our view to enable Full Text Indexing and querying

drop view if exists enceladus_events;
create view enceladus_events as
select
    events.id,
    events.time_stamp,
    events.title,
    events.description,
    event_types.description as event,
    to_tsvector(events.description) as search -- Full Text Indexing
from
    events
    inner join event_types on event_types.id = events.event_type_id
where
    target_id = (select id from targets where description = 'Enceladus')
order by
    time_stamp;


-- Samble query searching some text

select id, time_stamp, title
from enceladus_events
where time_stamp::date
between '2005-02-01'::date
and '2005-02-28'::date
and search @@ to_tsquery('thermal');

/*
  id   |       time_stamp       |                             title
-------+------------------------+----------------------------------------------------------------
 19345 | 2005-02-16 13:55:00-05 | Enceladus rider (FP3 integration)
 58853 | 2005-02-16 15:20:29-05 | RSS Enceladus Gravity Thermal Stabilization
 19344 | 2005-02-16 15:49:00-05 | Enceladus rider (FP3 integration)
 18689 | 2005-02-17 00:15:29-05 | Enceladus FP1 and FP3 maps, high spectral resoluti
 14650 | 2005-02-17 01:30:29-05 | Enceladus rider (FP1,FP3 high spectral resolution integration)
 30305 | 2005-02-17 02:15:29-05 | Enceladus rider (FP1,FP3 coverage)
 58854 | 2005-02-17 03:00:29-05 | RSS Enceladus Gravity Thermal Stabilization
 41501 | 2005-02-17 11:30:29-05 | Enceladus rider (FP3 0.5 cm-1 res. integration)
(8 rows)
*/


-- Display all titles and descriptions from the second Enceladus flyby (2005-03-09)

select time_stamp, title, teams.description
from events
inner join teams on teams.id=events.team_id
where time_stamp::date='2005-03-09'
and target_id=28;

/*
       time_stamp       |                       title                        | description
------------------------+----------------------------------------------------+-------------
 2005-03-09 09:10:05-05 | Enceladus Orbit Xing 0.00<lat< 0.50 deg 3.85... 4. | CDA
 2005-03-09 13:55:12-05 | Enceladus Orbit Xing 0.00<lat< 0.50 deg 3.85... 4. | CDA
 2005-03-09 07:38:01-05 | Dust envelope around Enceladus                     | CDA
 2005-03-09 08:38:01-05 | Enceladus closest approach observations            | RPWS
 2005-03-09 05:52:01-05 | Enceladus targeted                                 | VIMS
 2005-03-09 00:00:00-05 | Enceladus CIRS Rider                               | CIRS
 2005-03-09 06:47:01-05 | Enceladus targeted                                 | VIMS
 2005-03-09 05:27:01-05 | Enceladus targeted                                 | VIMS
 2005-03-09 04:37:01-05 | Enceladus targeted                                 | VIMS
 2005-03-09 04:07:01-05 | Enceladus targeted                                 | VIMS
 2005-03-09 03:07:01-05 | Enceladus targeted                                 | VIMS
 2005-03-09 02:52:01-05 | Enceladus targeted                                 | VIMS
 2005-03-09 01:48:01-05 | Enceladus targeted                                 | VIMS
 2005-03-09 18:10:00-05 | Enceladus targeted                                 | VIMS
 2005-03-09 10:38:01-05 | Enceladus targeted                                 | VIMS
 2005-03-09 08:58:01-05 | RSS_Ridealong                                      | CIRS
 2005-03-09 07:47:01-05 | Enceladus targeted                                 | VIMS
 2005-03-09 07:27:01-05 | Enceladus targeted                                 | VIMS
 2005-03-09 08:39:00-05 | MAPS 004EN Campaign                                | CAPS
 2005-03-09 08:38:01-05 | MAPS RS Campaign                                   | MIMI
 2005-03-09 07:08:01-05 | Enceladus targeted flyby                           | MAG
 2005-03-09 08:05:00-05 | Enceladus targeted flyby                           | MAG
 2005-03-09 04:37:01-05 | FP1 disk integration at high spectral resolution.  | CIRS
 2005-03-09 07:27:01-05 | Enceladus 004 FP1 dayside map.                     | CIRS
 2005-03-09 10:42:01-05 | FP1 phase coverage at 0.5 cm-1 resolution          | CIRS
 2005-03-09 10:38:01-05 | ENCELADUS near C/A                                 | ISS
 2005-03-09 05:52:01-05 | Enceladus 004 FP3 map No. 3                        | CIRS
 2005-03-09 03:07:01-05 | Enceladus FP3 map No. 2                            | CIRS
 2005-03-09 01:48:01-05 | Enceladus 004 FP3 map No. 1                        | CIRS
 2005-03-09 18:25:00-05 | ICYLON:  Longitude / Phase Space Coverage          | UVIS
 2005-03-09 10:42:01-05 | ICYMAP:  UV Surface Map of Enceladus               | UVIS
 2005-03-09 06:47:01-05 | ICYMAP:  UV Surface Map of Enceladus               | UVIS
 2005-03-09 02:52:01-05 | ICYMAP:  UV Surface Map of Enceladus, ORS Rider    | UVIS
 2005-03-09 04:07:01-05 | ICYMAP:  UV Surface Map of Enceladus, ORS Rider    | UVIS
 2005-03-09 03:07:01-05 | ICYMAP:  UV Surface Map of Enceladus, ORS Rider    | UVIS
 2005-03-09 01:48:01-05 | ICYMAP:  UV Surface Map of Enceladus, ORS Rider    | UVIS
 2005-03-09 07:27:01-05 | ICYMAP:  UV Surface Map of Enceladus, ORS Rider    | UVIS
 2005-03-09 05:52:01-05 | ICYMAP:  UV Surface Map of Enceladus, ORS Rider    | UVIS
 2005-03-09 05:27:01-05 | ICYMAP:  UV Surface Map of Enceladus, ORS Rider    | UVIS
 2005-03-09 07:47:01-05 | ICYMAP:  UV Surface Map of Enceladus               | UVIS
 2005-03-09 04:37:01-05 | ICYMAP:  UV Surface Map of Enceladus, ORS Rider    | UVIS
 2005-03-09 08:53:01-05 | SOST                                               | INMS
 2005-03-09 08:38:01-05 | SOST                                               | INMS
 2005-03-09 09:23:01-05 | SOST                                               | INMS
 2005-03-09 02:52:01-05 | NAC 3 COLOR POLARIZATION                           | ISS
 2005-03-09 04:07:01-05 | NAC 4-COLR                                         | ISS
 2005-03-09 05:27:01-05 | NAC 4 COLOR                                        | ISS
 2005-03-09 06:47:01-05 | NAC GRN POLARIZATION                               | ISS
 2005-03-09 18:25:00-05 | ENCELADUS prime                                    | ISS
 2005-03-09 18:25:01-05 | Enceladus RideAlong - ISS                          | CIRS
 2005-03-09 07:47:01-05 | NAC 3x3x1 GRN MOSAIC + WAC 4 Color                 | ISS
 2005-03-09 02:52:01-05 | TBD                                                | CIRS
 2005-03-09 12:08:01-05 | Scatterometry/Radiometry of Enceladus              | RADAR
 2005-03-09 04:07:01-05 | TBD                                                | CIRS
 2005-03-09 05:27:01-05 | TBD                                                | CIRS
 2005-03-09 06:47:01-05 | TBD                                                | CIRS
 2005-03-09 07:47:01-05 | TBD                                                | CIRS
(57 rows)
*/
```

- [Top](#a-bent-field)

## Aggregate Queries

``` sql
-- AGGREGATE QUERY
-- We can create a table with the number of occurences for each value in a column
-- We want to know which teams were more active during the 2005-03-09 Enceladus flyby
-- We can COUNT the times each team appears, and create a table with that

select count(1) as activity, teams.description -- will count occurences of each team
from events
inner join teams on teams.id=team_id
where time_stamp::date='2005-03-09'
and target_id=28
group by teams.description
order by activity desc;

/*
 activity | description
----------+-------------
       14 | CIRS
       12 | UVIS
       12 | VIMS
        7 | ISS
        3 | CDA
        3 | INMS
        2 | MAG
        1 | RADAR
        1 | RPWS
        1 | MIMI
        1 | CAPS
(11 rows)
*/

/*
CIRS    Composite Infrared Scanner
UVIS    UltraViolet Imaging Spectrograph
VIMS    Visible and Infrared Mass Spectrometer
ISS     Cassini's Imaging System
*/
```

- [Top](#a-bent-field)

## Concat

``` sql
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
```

- [Top](#a-bent-field)

## Materialized Views

``` sql
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
```

- [Top](#a-bent-field)