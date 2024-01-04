# Tables

- [Tables](#tables)
- [import schema](#import-schema)
  - [master_plan table (import schema)](#master_plan-table-import-schema)
- [public schema](#public-schema)
  - [List of tables](#list-of-tables)
  - [events](#events)
- [Lookup Tables](#lookup-tables)
  - [event_types](#event_types)
  - [requests](#requests)
  - [spass_types](#spass_types)
  - [targets](#targets)
  - [teams](#teams)
- [Views](#views)
  - [enceladus_events](#enceladus_events)
  - [test 1](#test-1)

# import schema
## master_plan table (import schema)
Table with raw data from the master_plan.csv file.  
**`\d import.master_plan`**
```
                 Table "import.master_plan"
       Column       | Type | Collation | Nullable | Default
--------------------+------+-----------+----------+---------
 start_time_utc     | text |           |          |
 duration           | text |           |          |
 date               | text |           |          |
 team               | text |           |          |
 spass_type         | text |           |          |
 target             | text |           |          |
 request_name       | text |           |          |
 library_definition | text |           |          |
 title              | text |           |          |
 description        | text |           |          |
```

- [Top](#tables)

# public schema
## List of tables
All the tables and views that currently exist in the public schema (2022-10-20).  
**`\d`**
```
                 List of relations
 Schema |        Name        |   Type   |  Owner
--------+--------------------+----------+----------
 public | enceladus_events   | view     | postgres
 public | event_types        | table    | postgres
 public | event_types_id_seq | sequence | postgres
 public | events             | table    | postgres
 public | events_id_seq      | sequence | postgres
 public | requests           | table    | postgres
 public | requests_id_seq    | sequence | postgres
 public | spass_types        | table    | postgres
 public | spass_types_id_seq | sequence | postgres
 public | targets            | table    | postgres
 public | targets_id_seq     | sequence | postgres
 public | teams              | table    | postgres
 public | teams_id_seq       | sequence | postgres
(13 rows)
```

- [Top](#tables)

## events
This is the **source** or facts table. All other tables are connected to this.  
**`\d events`**
```
                                        Table "public.events"
    Column     |           Type           | Collation | Nullable |              Default
---------------+--------------------------+-----------+----------+------------------------------------
 id            | integer                  |           | not null | nextval('events_id_seq'::regclass)
 time_stamp    | timestamp with time zone |           | not null |
 title         | character varying(500)   |           |          |
 description   | text                     |           |          |
 event_type_id | integer                  |           |          |
 target_id     | integer                  |           |          |
 team_id       | integer                  |           |          |
 request_id    | integer                  |           |          |
 spass_type_id | integer                  |           |          |
Indexes:
    "events_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "events_event_type_id_fkey" FOREIGN KEY (event_type_id) REFERENCES event_types(id)
    "events_request_id_fkey" FOREIGN KEY (request_id) REFERENCES requests(id)
    "events_spass_type_id_fkey" FOREIGN KEY (spass_type_id) REFERENCES spass_types(id)
    "events_target_id_fkey" FOREIGN KEY (target_id) REFERENCES targets(id)
    "events_team_id_fkey" FOREIGN KEY (team_id) REFERENCES teams(id)
```

- [Top](#tables)

# Lookup Tables

## event_types
**`select * from event_types limit 5;`**
```
                       description                       | id
---------------------------------------------------------+----
 Saturn Global dynamics                                  |  1
 Saturn Electrical Discharge direction finding           |  2
                                                         |  3
 MAPS survey/Prime pointing                              |  4
 Retargetable observation                                |  5
(5 rows)
```

## requests
**`select * from requests limit 5;`**
```
 description | id
-------------+----
 UREPSLUP    |  1
 RDHRESCN    |  2
 T94INBND    |  3
 PSTOTM6BU   |  4
 COMPLODRK   |  5
(5 rows)
```

## spass_types
**`select * from spass_types limit 5;`**
```
 description | id
-------------+----
             |  1
 Prime       |  2
 Non-SPASS   |  3
 SPASS Note  |  4
 SPASS Rider |  5
(5 rows)
```

## targets
**`select * from targets limit 5;`**
```
   description   | id
-----------------+----
 Rhea            |  1
 Other           |  2
 RingB           |  3
 Skeletonrequest |  4
 RingC           |  5
(5 rows)
```

## teams
**`select * from teams limit 5;`**
```
 description | id
-------------+----
 RADAR       |  1
 RPWS        |  2
 CDA         |  3
 UVIS        |  4
 RSS         |  5
(5 rows)
```

- [Top](#tables)

# Views

## enceladus_events
**`\d enceladus_events`**
```
                     View "public.enceladus_events"
   Column    |           Type           | Collation | Nullable | Default
-------------+--------------------------+-----------+----------+---------
 id          | integer                  |           |          |
 title       | character varying(500)   |           |          |
 description | text                     |           |          |
 time_stamp  | timestamp with time zone |           |          |
 date        | date                     |           |          |
 event       | text                     |           |          |
 search      | tsvector                 |           |          |
```

## test 1

<!-- not table of contents -->
- [Top](#tables)
