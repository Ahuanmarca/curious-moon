# Flybys

- [Flybys](#flybys)
  - [A simple query](#a-simple-query)
  - [Fuzzy Search](#fuzzy-search)
  - [Regex](#regex)
  - [Cross Reference: Query on the import.master_plan table](#cross-reference-query-on-the-importmaster_plan-table)

## A simple query

``` sql
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
```

- [Top](#flybys)

## Fuzzy Search

``` sql
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
```

- [Top](#flybys)

## Regex

``` sql
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

```

- [Top](#flybys)

## Cross Reference: Query on the import.master_plan table

``` sql
-- QUERY ON THE IMPORT TABLE
-- Query on master_plan so check dates where first Enceladus flyby happened
-- We discover that the first event of that date is the first Enceladus flyby
-- But there's nothing in the title that suggests it is a flyby!!

select
    target,
    title,
    date
from
    import.master_plan
where
    start_time_utc :: date = '2005-02-17'
order by
    start_time_utc :: date;


/*
      target       |                             title                              |   date
-------------------+----------------------------------------------------------------+-----------
 Enceladus         | Enceladus                                                      | 17-Feb-05
 Enceladus         | Enceladus FP1 and FP3 maps, high spectral resoluti             | 17-Feb-05
 Enceladus         | ICYLON:  Icy Satellite Longitude / Phase Coverage              | 17-Feb-05
 Saturn            | MAPS Survey                                                    | 17-Feb-05
 Saturn            | Obtain wideband examples of lightning whistlers                | 17-Feb-05
 Saturn            | Highest Resolution SED Observations                            | 17-Feb-05
 Enceladus         | Enceladus                                                      | 17-Feb-05
 Enceladus         | Enceladus rider (FP1,FP3 high spectral resolution integration) | 17-Feb-05
 Enceladus         | ICYLON:  Icy Satellite Longitude / Phase Coverage              | 17-Feb-05
 Enceladus         | ENCELADUS Limb Topography                                      | 17-Feb-05
 Enceladus         | Enceladus rider (FP1,FP3 coverage)                             | 17-Feb-05
 Enceladus         | ICYMAP:  High resolution icy satellite map                     | 17-Feb-05
 Enceladus         | Enceladus                                                      | 17-Feb-05
 Enceladus         | MAPS 003EN Campaign                                            | 17-Feb-05
 Enceladus         | RSS Enceladus Gravity Thermal Stabilization                    | 17-Feb-05
 Enceladus         | Enceladus closest approach observations                        | 17-Feb-05
 Enceladus         | Dust envelope around Enceladus                                 | 17-Feb-05
 Enceladus         | ENCELADUS near-limb topography                                 | 17-Feb-05
 Enceladus         | ICYEXO:  Icy Satellite Exospheres                              | 17-Feb-05
 Other             | MAG_MAPS_Survey_Measurements                                   | 17-Feb-05
 RingE             | E ring dust measurement                                        | 17-Feb-05
 Enceladus         | FP1 map of dark hemisphere                                     | 17-Feb-05
 Enceladus         | ICYLON:  Icy Satellite Longitude / Phase Coverage              | 17-Feb-05
 Enceladus         | Enceladus                                                      | 17-Feb-05
 Saturn            | MAPS Survey                                                    | 17-Feb-05
 RingE             | E ring dust measurement                                        | 17-Feb-05
 Enceladus         | RSS Enceladus Gravity Field Determination                      | 17-Feb-05
 DustRAM direction | Dust survey                                                    | 17-Feb-05
 Other             | Warmup for ENScatterometry                                     | 17-Feb-05
 Enceladus         | Scatterometry and Radiometry of Enceladus                      | 17-Feb-05
 Enceladus         | ENCELADUS Geyser Search                                        | 17-Feb-05
 Enceladus         | Enceladus rider (FP3 0.5 cm-1 res. integration)                | 17-Feb-05
 Enceladus         | ICYLON:  Icy Satellite Longitude / Phase Coverage              | 17-Feb-05
 Saturn            | MAPS Survey                                                    | 17-Feb-05
 Saturn            | RPWS Monitor SKR and Solar Wind during HST campaig             | 17-Feb-05
 co-rotation       | MAPS SURVEY Campaign                                           | 17-Feb-05
 Rhea              | Combined ORS observations                                      | 17-Feb-05
 Rhea              | ICYLON:  Icy Satellite Longitude / Phase Coverage              | 17-Feb-05
 Rhea              | Rhea                                                           | 17-Feb-05
 Saturn            | Saturn Thermal Cylindrical Map                                 | 17-Feb-05
 Saturn            | Ride on VIMS cylindrical Saturn map.                           | 17-Feb-05
 Saturn            | EUVFUV Imaging of Saturn                                       | 17-Feb-05
 Saturn            | Burst of 8kbps data                                            | 17-Feb-05
 SolarWind         | UVIS Interplanetary Hydrogen Survey                            | 17-Feb-05
(44 rows)
*/
```

- [Top](#flybys)