---
title: Using PostGIS
---

[PostGIS](http://postgis.net/) is a spatial database extender for PostgreSQL object-relational database. It adds support for geographic objects allowing location queries to be run in SQL.

```sql
SELECT superhero.name
FROM city, superhero
WHERE ST_Contains(city.geom, superhero.geom)
AND city.name = 'Gotham';
```

In addition to basic location awareness, PostGIS offers many features rarely found in other competing spatial databases such as Oracle Locator/Spatial and SQL Server. Refer to [PostGIS Feature List](http://postgis.net/features/) for more details.

PostGIS dependencies are installed and PostGIS extension is available for Dingo PostgreSQL service instances.

## Available extensions

```
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;
```

Tiger geocoder is available:

```
CREATE EXTENSION fuzzystrmatch;
CREATE EXTENSION postgis_tiger_geocoder;
```

Address standardizer is available:

```
CREATE EXTENSION address_standardizer;
CREATE EXTENSION address_standardizer_data_us;
```

List of installed extensions:

```
postgres=# \dx *
                                                                       List of installed extensions
             Name             | Version |   Schema   |                                                     Description
------------------------------+---------+------------+---------------------------------------------------------------------------------------------------------------------
 address_standardizer         | 2.2.1   | public     | Used to parse an address into constituent elements. Generally used to support geocoding address normalization step.
 address_standardizer_data_us | 2.2.1   | public     | Address Standardizer US dataset example
 fuzzystrmatch                | 1.0     | public     | determine similarities and distance between strings
 plpgsql                      | 1.0     | pg_catalog | PL/pgSQL procedural language
 postgis                      | 2.2.1   | public     | PostGIS geometry, geography, and raster spatial types and functions
 postgis_tiger_geocoder       | 2.2.1   | tiger      | PostGIS tiger geocoder and reverse geocoder
 postgis_topology             | 2.2.1   | topology   | PostGIS topology spatial types and functions
 ```
