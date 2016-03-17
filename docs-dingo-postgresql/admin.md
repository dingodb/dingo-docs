---
title: Administering Dingo PostgreSQL
---

## Logs

## <a id="lookup-service-guid"></a>Lookup Service Instance GUID

```
cf service <service-name> --guid
```

## <a id="logs-service-id"></a>Search logs for service instance

Search your system logs for the service instance GUID and you will see Dingo PostgreSQL setting up routing and provision Docker containers.

Example snippet from logs for a newly provisioned service instance registering a new port on the Dingo router:

```
service_changes.log:  checking if cluster already has port assigned for: 6e101b27-ee1b-4f4d-a032-4401a3709ec3
service_changes.log:  new cluster discovered by router: 6e101b27-ee1b-4f4d-a032-4401a3709ec3
```

To see the logs from each Docker container for a cluster you need to find the matching Docker container IDs.

Search the service instance logs for references to Docker containers:

```
Mar 16 19:11:48 14ddd22e-719e-4aca-b318-7f291c97fbba docker/cf-c8ce128e-7b4c-4fe7-a533-e9379356f906:  patroni>         DETAIL: Uploading "pg_xlog/000000010000000000000001" to "s3://our-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/wal_005/000000010000000000000001.lzo".
Mar 16 19:11:48 14ddd22e-719e-4aca-b318-7f291c97fbba docker/cf-c8ce128e-7b4c-4fe7-a533-e9379356f906:  patroni>         STRUCTURED: time=2016-03-17T02:11:48.811154-00 pid=231 action=push-wal key=s3://our-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/wal_005/000000010000000000000001.lzo prefix=backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/ seg=000000010000000000000001 state=begin
```

In the example above `docker/cf-c8ce128e-7b4c-4fe7-a533-e9379356f906` is the new search string to see all logs for that Docker container.
