-- 
-- DROPPING TABLES AT THE TOP
-- Dropping events first, cascading everything in case of other dependencies

drop table if exists events cascade;
drop table if exists teams cascade;
drop table if exists event_types cascade;
drop table if exists spass_types cascade;
drop table if exists targets cascade;
drop table if exists requests cascade;

-- CREATING LOOKUP TABLES
-- Must happen before creating the events table because of foreign keys
-- These tables are created and filled with data from import.master_plan

-- TEAMS
select distinct(team) as description
into teams from import.master_plan;
alter table teams add id serial primary key;

-- EVENT TYPES
select distinct(library_definition) as description
into event_types from import.master_plan;
alter table event_types add id serial primary key;

-- SPASS TYPES
select distinct(spass_type) as description
into spass_types from import.master_plan;
alter table spass_types add id serial primary key;

-- TARGETS
select distinct(target) as description
into targets from import.master_plan;
alter table targets add id serial primary key;

-- REQUESTS
select distinct(request_name) as description
into requests from import.master_plan;
alter table requests add id serial primary key;

-- 
-- CREATING EVENTS TABLE
-- Create events table with foreign keys referencing the lookup tables

-- drop table if exists events cascade; -- <= Dropped before creating lookups!
create table events(
    id serial primary key,
    time_stamp timestamptz not null,
    title varchar(500),
    description text,
    event_type_id int references event_types(id),
    target_id int references targets(id),
    team_id int references teams(id),
    request_id int references requests(id),
    spass_type_id int references spass_types(id)
);

-- 
-- INSERTING DATA INTO EVENTS TABLE
-- 1) Inserts time_stamp, title and description ento events from import.master_plan
-- 2) Inserts foreign keys into the other 5 fields
--      Each foreign key comes from a lookup table
--      where "description" in lookup == value of column from import.master_plan

insert into events(
        time_stamp,
        title,
        description,
        event_type_id,
        target_id,
        team_id,
        request_id,
        spass_type_id
    )
select
    import.master_plan.start_time_utc :: timestamp, -- at time zone 'UTC' -- It's already UTC
    import.master_plan.title,
    import.master_plan.description,
    event_types.id as event_type_id, --> event_types == library_definition on import.master_plan
    targets.id as target_id,
    teams.id as team_id,
    requests.id as request_id,
    spass_types.id as spass_type_id
from
    import.master_plan
    left join event_types on 
        event_types.description = import.master_plan.library_definition
    left join targets on 
        targets.description = import.master_plan.target
    left join teams on 
        teams.description = import.master_plan.team
    left join requests on 
        requests.description = import.master_plan.request_name
    left join spass_types on 
        spass_types.description = import.master_plan.spass_type;

-- --------