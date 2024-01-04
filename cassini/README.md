# A Curious Moon

- [A Curious Moon](#a-curious-moon)
  - [Flybys](#flybys)
  - [A Bent Field](#a-bent-field)
- [Important Dates](#important-dates)
- [TODOs](#todos)
- [INMS](#inms)
- [Functions](#functions)
    - [**`date_part('year', date)`**](#date_partyear-date)
    - [**`to_char(expression, format)`**](#to_charexpression-format)

## Flybys

- Simple queries joining tables
- Fuzzy searches with `ilike` and %%
- Regex searches
- Query on the import table, filtering by dates

## A Bent Field

- Sargeable vs. non-sargeable queries
- Views
- Output to HTML
- Full-text indexing, Full-text queries
- Aggregate queries, Concat
- Materialized views

# Important Dates

- 2005-02-17: First Enceladus pass. That's when they spotted the weird magnetometer reading. The next flybys where in March and July 2005.
- 2005-03-09: Second flyby, six weeks later

The closest Cassini ever came to Enceladus was at 2:06AM UTC on October 10, 2008.

- SPASS = Science Planning Attitude Spread Sheet
- library_definition = type of event

- list schemas: **`\dn`**


# TODOs
- Research the best / correct way to store the dates. When shout I specify TO UTC, when not to do it. We can do it when storing, aldo when querying.

# INMS
Ion and Neutral Mass Spectrometer (INMS): Intended to measure positive ion and neutral species composition and structure in the upper atmosphere of Titan and magnetosphere of Saturn and to measure the positive ion and neutral environments of Saturn's icy satellites and rings.

# Functions

### **`date_part('year', date)`**
First argument: code of the part of the date we want.  
Second argument: date object (like timestamp or date).
Code are like: century, decade, year, month, day, hour, minute, second, microseconds, milliseconds, etc

###  **`to_char(expression, format)`**
Transforms a date to a formatted string.
``` sql
select to_char('1981-17-12'::date, 'DDD');
```
