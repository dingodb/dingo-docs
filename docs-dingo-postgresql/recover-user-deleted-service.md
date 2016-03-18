---
title: Recover user's deleted service
---

If a user accidentally deletes their service instance, it is a disaster to them. When a user accidentally writes or deletes data from their database, it is a disaster to them.

This section documents how to recreate the database and recover it from the archive backups.

NOTE: Future versions of Dingo PostgreSQL will continuously improve the recovery user story - ultimately it will be placed in the hands of the user themselves, and not require operator/administrator privileges as it does now.

## <a id="disaster-problem"></a>The disaster

The disaster is that a user accidentally deleted a service instance and they want it restored.

Perhaps they just deleted the service instance:

```
cf delete-service important-db
```

Or perhaps they deleted the entire space:

```
cf delete-space important-space-and-all-databases
```

## <a id="questions-for-user"></a>Questions for the user

When the user requests to have their service recovered, please ask them for:

* the organization & space into which they wish to have it recreated
* the service name
* the desired service plan for recreated service
* the application(s) is was bound it

## <a id="discover-lost-metadata"></a>Discover lost metadata

When a user submits an urgent distressed "I've deleted my Dingo PostgreSQL database, please help!" there are some metadata challenges to overcome before you can help them.

As at writing, Pivotal Cloud Foundry thoroughly deletes its internal metadata for deleted service instances.

Prior to the user deleting their service instance, you might have been able to look up information about the service instance:

```
CF_TRACE=true cf service important-db
```

`CF_TRACE=true` would have shown you all the API results - the internal metadata - for the service instance. You could learn its service GUID, the space GUID and the organization GUID.

But, the user deleted the service instance. So that data is gone.

You will need to search the system logs for removing the last node in a cluster, and noticing that the haproxy router has been updated (to remove the service's allocated port):

```
Mar 16 23:10:17 0.router-partition-cac94a070a81fd8f3931.dingo-postgresql-98b09c4b36af74181ee1 broker.stdout.log:  {"timestamp":"1458195017.896692991","source":"patroni-broker","message":"patroni-broker.cluster.remove-node.perform","log_level":1,"data":{"backend":"10.58.111.150","instance-id":"6e101b27-ee1b-4f4d-a032-4401a3709ec3","node-uuid":"c8ce128e-7b4c-4fe7-a533-e9379356f906","session":"76"}}

Mar 16 23:10:18 0.router-partition-cac94a070a81fd8f3931.dingo-postgresql-98b09c4b36af74181ee1 confd.stderr.log:  2016-03-17T06:10:18Z 3a977637-afdc-4a51-bb8a-d82aa4f0dcd4 confd[4095]: INFO /var/vcap/sys/run/router/haproxy.cfg has md5sum fa93b9d6b9e2f81a774f47d39c28d46b should be b0ced603d154cbe72874d83683842ee8
Mar 16 23:10:18 0.router-partition-cac94a070a81fd8f3931.dingo-postgresql-98b09c4b36af74181ee1 confd.stderr.log:  2016-03-17T06:10:18Z 3a977637-afdc-4a51-bb8a-d82aa4f0dcd4 confd[4095]: INFO Target config /var/vcap/sys/run/router/haproxy.cfg out of sync
Mar 16 23:10:19 0.router-partition-cac94a070a81fd8f3931.dingo-postgresql-98b09c4b36af74181ee1 confd.stderr.log:  2016-03-17T06:10:19Z 3a977637-afdc-4a51-bb8a-d82aa4f0dcd4 confd[4095]: INFO Target config /var/vcap/sys/run/router/haproxy.cfg has been updated
```

The first line includes `patroni-broker.cluster.remove-node.perform`. The subsequent three lines show `/var/vcap/sys/run/router/haproxy.cfg` being updated (to remove the routed port from the configuration file).

In the first line, locate `"instance-id":"6e101b27-ee1b-4f4d-a032-4401a3709ec3"`. This is the original Pivotal Cloud Foundry GUID for the service instance that was deleted by the user.

This `instance-id` GUID is how we will locate the archived backups from which you will restore to a new database.

## <a id="confirm-backups-location"></a>Confirm backups location

NOTE: the backup location is pre-determinable; see end of section.

Search the logs again for the `instance-id` GUID (`6e101b27-ee1b-4f4d-a032-4401a3709ec3` in example above).

You will see the `backup>` and `patroni>` lines where [wal-e](https://github.com/wal-e/wal-e) uploaded regular base backups and frequent write-ahead log (WAL) segments to an offsite object store.

```
Mar 16 19:11:47 14ddd22e-719e-4aca-b318-7f291c97fbba docker/cf-c8ce128e-7b4c-4fe7-a533-e9379356f906:  patroni> upload: tmp/sysids/sysid to s3://our-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/sysids/sysid
Mar 16 19:11:48 14ddd22e-719e-4aca-b318-7f291c97fbba docker/cf-c8ce128e-7b4c-4fe7-a533-e9379356f906:  patroni>         DETAIL: Uploading "pg_xlog/000000010000000000000001" to "s3://our-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/wal_005/000000010000000000000001.lzo".
Mar 16 19:11:48 14ddd22e-719e-4aca-b318-7f291c97fbba docker/cf-c8ce128e-7b4c-4fe7-a533-e9379356f906:  patroni>         STRUCTURED: time=2016-03-17T02:11:48.811154-00 pid=231 action=push-wal key=s3://our-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/wal_005/000000010000000000000001.lzo prefix=backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/ seg=000000010000000000000001 state=begin
Mar 16 19:11:49 14ddd22e-719e-4aca-b318-7f291c97fbba docker/cf-c8ce128e-7b4c-4fe7-a533-e9379356f906:  backup>         DETAIL: Uploading to s3://our-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/basebackups_005/base_000000010000000000000002_00000040/extended_version.txt.
Mar 16 19:11:50 14ddd22e-719e-4aca-b318-7f291c97fbba docker/cf-c8ce128e-7b4c-4fe7-a533-e9379356f906:  backup>         DETAIL: Uploading to "s3://our-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/basebackups_005/base_000000010000000000000002_00000040/tar_partitions/part_00000000.tar.lzo".
...
```

From these logs we can find the location of the backups `s3://our-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal`.

In this example, it is an Amazon S3 bucket `our-postgresql-backups`, under the `/backups/SERVICE_GUID/wal` folder.

The location of backups is actually pre-determinable. When you installed the Dingo PostgreSQL tile you provided the object store credentials and bucket name. So reading the logs above is really to confirm that the backup is available.

_If you don't see any `DETAIL: Uploading to` lines then you have a big problem - there is no backup for this lost service instance._

## <a id="recreate-database"></a>Recreate database

Now recreate the Dingo PostgreSQL database on behalf of the user, into the same organization/space.

Login to Pivotal Cloud Foundry as an admin and target the user's organization/space:

```
cf target -o org -s important-space-and-all-databases
```

If the user wants you to rebind the service to an application(s) then confirm that they exist in this space:

```
cf applications
```

Regardless what service plan the user requests, initially recreate the service with the `solo` plan. This makes it easier to find a single Docker container and stop it.

```
cf create-service important-db
```
