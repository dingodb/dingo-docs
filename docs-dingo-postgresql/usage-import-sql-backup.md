---
title: Import existing SQL database backup
---

## <a id="download-backup-sql"></a>Download SQL backup

## <a id="clean-up-sql"></a>Clean up SQL

Sometimes SQL backups include the commands to recreate the owner information. This information will not be correct when migrating from old database to new Dingo PostgreSQL ™ database. So, strip out all `ALTER... OWNER TO` commands:

```
grep -v "^ALTER.*OWNER TO.*$" database.sql > database.noowner.sql
```

## <a id="superuser-required"></a>Superuser required?

If your SQL includes `CREATE EXTENSION` then you will need to run the SQL file as a root/superuser, rather than the normal user credentials.

Firstly, you might need to loosen the security of your PostgreSQL Web UI, such as [these phpPgAdmin instructions](usage-gui.html#phppgadmin-loosening-security).

Next, look up the `superuser_username` and `superuser_password` from one of your bindings.

```
cf env <appname>
```

The output will include `$VCAP_SERVICES` credentials such as:

```
System-Provided:
{
 "VCAP_SERVICES": {
  "dingo-postgresql95": [
   {
    "credentials": {
     "host": "10.58.111.151",
     "port": 33003,
     "username": "replicator"
     "password": "replicator",
     "superuser_username": "ROOTUSER",
     "superuser_password": "ROOTPASSWORD",
     ...
    },
...
```

## <a id="import-sql"></a>Import SQL via Web UI

Each Web UI will include its own method for allowing SQL to be run against a database.

Our phpPgAdmin tutorial includes a section [Import SQL](usage-gui.html#phppgadmin-import-sql)
