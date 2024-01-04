## Imported all the data from the inms.csv file with a Makefile script
The script took 1-2 minutes to run.

```
PS C:\...\04-01-loading> .\Makefile.ps1
Password for user postgres:
psql:C:/Users/ASUS/Desktop/cassini/04-sniff-the-sky/04-01-loading/build.sql:7: NOTICE:  table "inms" does not exist, skipping
DROP TABLE
CREATE TABLE
COPY 13858822
DELETE 1646
```

## Common Table Expression (CTE)

