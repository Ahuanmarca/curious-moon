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

