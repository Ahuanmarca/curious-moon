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