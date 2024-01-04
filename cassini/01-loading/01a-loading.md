# Loading

- [Loading](#loading)
  - [Run SQL scripts](#run-sql-scripts)
- [Importing](#importing)
  - [**`import.sql`**](#importsql)
- [Normalizing](#normalizing)
  - [**`normalize.sql`**](#normalizesql)
- [Using Make](#using-make)
  - [Linux / macOS](#linux--macos)
    - [**`Makefile`**](#makefile)
  - [Windows (ps1 script)](#windows-ps1-script)
    - [**`Makefile.ps1`**](#makefileps1)

## Run SQL scripts

``` bash
# Windows
psql -U <username> -f <filename.sql> <dbname>
psql -h <hostname> -p <port number> -U <username> -f <filename.sql> <dbname>

# Linux / macOS
psql enceladus < build.sql
psql enceladus -f build.sql

# psql
# We must be in the same directory and logged to the target database
\i build.sql
```

- [Top](#loading)

# Importing

**Using a Schema**: We don't want to dumb unorganized data into the **public** schema. We want to create anothe schema, an **import** schema, and dump all the imported raw data there. The schema becomes part of the name of your relation. If you don't specify a schema when creating a relation, **public** is assumed.

We can dump everything into an import schema, creating it if it doesn't exist.

**Curious Moon** sugests using the **COPY** SQL command, but I was never able to use it because of permission problems, not even after granting every permission I could imagine. I think the problem is that there's a process that needs permission to execute in the user's directory. I finally used the  **`\copy`** command instead, which is a `psql` command, not an SQL command.

**Warning**: The `\copy` command must be all in one line without breaks. The syntax is almost identical to SQL, but it seems it's not possible to break lines.

## **`import.sql`**
This creates an import schema, and creates a table with all the columns that exist in the master_plan.csv file. All the values are stored as strings, like raw data.
``` sql
-- 
-- CREATING IMPORT SCHEMA
-- Schema created in it's own namespace, not in the public schema
-- Will contain all values from master_plan.csv as strings

drop table if exists import.master_plan;
create schema if not exists import;

create table import.master_plan(
    start_time_utc text,
    duration text,
    date text,
    team text,
    spass_type text,
    target text,
    request_name text,
    library_definition text,
    title text,
    description text
);

-- WARNING: Preetier would split the next line, which breaks the script
-- The following code will run from the Make file. It depends on the system.
-- \copy import.master_plan FROM 'C:\Users\ASUS\Desktop\cassini\windows\test_scripts\master_plan.csv' WITH DELIMITER ',' HEADER CSV;

-- --------
```

- [Top](#loading)

# Normalizing
- Dropping tables at the top, begining by the events table (because of foreign keys)
- Creating the lookup tables from the columns at import.master_plan
- Cresating the events table
- Inserting data and foreign keys into the events table (with crazy SQL statement from M. Sullivan)

## **`normalize.sql`**
``` sql
-- 
-- CREATING LOOKUP TABLES
-- Must happen before creating the events table because of foreign keys
-- These tables are created and filled with data from import.master_plan

-- We must drop the events table before dropping the lookup tables, because of foreign keys!
drop table if exists events;

drop table if exists teams;
select distinct(team) as description
into teams from import.master_plan;
alter table teams add id serial primary key;

drop table if exists event_types;
select distinct(library_definition) as description
into event_types from import.master_plan;
alter table event_types add id serial primary key;

drop table if exists spass_types;
select distinct(spass_type) as description
into spass_types from import.master_plan;
alter table spass_types add id serial primary key;

drop table if exists targets;
select distinct(target) as description
into targets from import.master_plan;
alter table targets add id serial primary key;

drop table if exists requests;
select distinct(request_name) as description
into requests from import.master_plan;
alter table requests add id serial primary key;

-- --------
-- 
-- CREATING THE EVENTS TABLE
-- Create events table with foreign keys referencing the lookup tables

-- drop table if exists events; -- <= Dropped before creating lookups!
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

-- --------
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
    import.master_plan.start_time_utc :: timestamp /*at time zone 'UTC'*/, -- It's already UTC
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
-- THE END
```

- [Top](#loading)

# Using Make

## Linux / macOS

### **`Makefile`**
``` Makefile
# Variables
DB=enceladus
BUILD=${CURDIR}/build.sql # CURDIR gives current directory
SCRIPTS=${CURDIR}/scripts
CSV='${CURDIR}/data/master_plan.csv'
MASTER=$(SCRIPTS)/import.sql
NORMALIZE=$(SCRIPTS)/normalize.sql

# TARGETS
# Left dependes from right
# By default the first one is the entry point
all: normalize
	# 4) Runs the build.sql script
	psql $(DB) -f $(BUILD)

master:
	# 1) Append import.sql to build.sql
	@cat $(MASTER) >> $(BUILD)

import: master
	# 2) Append "COPY... " to build.sql
	@echo "COPY import.master_plan FROM $(CSV) WITH DELIMITER ',' HEADER CSV;" >> $(BUILD)

normalize: import
	# 3) Append normalize.sql to build.sql
	@cat $(NORMALIZE) >> $(BUILD)

clean:
	@rm -rf $(BUILD)
```

## Windows (ps1 script)

Different from Makefile, it's just a series of commands that run one after another. I think it doens't have the dependency logic, but I can put them in the correct order so I should produce the correct result.

### **`Makefile.ps1`**
``` powershell
$DB = "enceladus"
$CSV = Join-Path -Path $pwd -ChildPath "/data/master_plan.csv"
$BUILD = Join-Path -Path $pwd -ChildPath "/build.sql"

$SCRIPTS = Join-Path -Path $pwd -ChildPath "/scripts"
$MASTER = Join-Path -Path $SCRIPTS -ChildPath "/import.sql"
$NORMALIZE = Join-Path -Path $SCRIPTS -ChildPath "/normalize.sql"

Get-Content $MASTER | Set-Content $BUILD
Write-Output "\copy import.master_plan FROM '$CSV' WITH DELIMITER ',' HEADER CSV;" | Add-Content $BUILD
Get-Content $NORMALIZE | Add-Content $BUILD
psql -U postgres -f $BUILD $DB
```
