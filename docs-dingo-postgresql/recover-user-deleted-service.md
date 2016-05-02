---
title: Recover user's deleted service
---

If a user accidentally deletes their service instance, it is a disaster to them. When a user accidentally writes or deletes data from their database, it is a disaster to them.

This section documents how to recreate the database and recover it from the archive backups.

NOTE: Future versions of Dingo PostgreSQL™ will continuously improve the recovery user story - ultimately it will be placed in the hands of the user themselves, and not require operator/administrator privileges as it does now.

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

When a user submits an urgent distressed "I've deleted my Dingo PostgreSQL™ database, please help!" there are some metadata challenges to overcome before you can help them.

As at writing, Pivotal Cloud Foundry&reg; thoroughly deletes its internal metadata for deleted service instances.

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

In the first line, locate `"instance-id":"6e101b27-ee1b-4f4d-a032-4401a3709ec3"`. This is the original Pivotal Cloud Foundry&reg; GUID for the service instance that was deleted by the user.

This `instance-id` GUID is how we will locate the archived backups from which you will restore to a new database.

## <a id="confirm-backups-location"></a>Confirm backups location

NOTE: the backup location is pre-determinable; see end of section.

Search the logs again for the `instance-id` GUID (`6e101b27-ee1b-4f4d-a032-4401a3709ec3` in example above).

You will see the `backup>` and `patroni>` lines where [wal-e](https://github.com/wal-e/wal-e) uploaded regular base backups and frequent write-ahead log (WAL) segments to an offsite object store.

```
Mar 16 19:11:47 14ddd22e-719e-4aca-b318-7f291c97fbba docker/cf-c8ce128e-7b4c-4fe7-a533-e9379356f906:  patroni> upload: tmp/sysids/sysid to s3://our-dingo-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/sysids/sysid
Mar 16 19:11:48 14ddd22e-719e-4aca-b318-7f291c97fbba docker/cf-c8ce128e-7b4c-4fe7-a533-e9379356f906:  patroni>         DETAIL: Uploading "pg_xlog/000000010000000000000001" to "s3://our-dingo-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/wal_005/000000010000000000000001.lzo".
Mar 16 19:11:48 14ddd22e-719e-4aca-b318-7f291c97fbba docker/cf-c8ce128e-7b4c-4fe7-a533-e9379356f906:  patroni>         STRUCTURED: time=2016-03-17T02:11:48.811154-00 pid=231 action=push-wal key=s3://our-dingo-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/wal_005/000000010000000000000001.lzo prefix=backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/ seg=000000010000000000000001 state=begin
Mar 16 19:11:49 14ddd22e-719e-4aca-b318-7f291c97fbba docker/cf-c8ce128e-7b4c-4fe7-a533-e9379356f906:  backup>         DETAIL: Uploading to s3://our-dingo-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/basebackups_005/base_000000010000000000000002_00000040/extended_version.txt.
Mar 16 19:11:50 14ddd22e-719e-4aca-b318-7f291c97fbba docker/cf-c8ce128e-7b4c-4fe7-a533-e9379356f906:  backup>         DETAIL: Uploading to "s3://our-dingo-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/basebackups_005/base_000000010000000000000002_00000040/tar_partitions/part_00000000.tar.lzo".
...
```

From these logs we can find the location of the backups `s3://our-dingo-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal`.

In this example, it is an Amazon S3 bucket `our-dingo-postgresql-backups`, under the `/backups/SERVICE_GUID/wal` folder.

The location of backups is actually pre-determinable. When you installed the Dingo PostgreSQL™ tile you provided the object store credentials and bucket name. So reading the logs above is really to confirm that the backup is available.

_If you don't see any `DETAIL: Uploading to` lines then you have a big problem - there is no backup for this lost service instance._

## <a id="recreate-database"></a>Recreate database

Now recreate the Dingo PostgreSQL™ database on behalf of the user, into the same organization/space.

Login to Pivotal Cloud Foundry&reg; as an admin and target the user's organization/space:

```
cf target -o org -s important-space-and-all-databases
```

If the user wants you to rebind the service to an application(s) then confirm that they exist in this space:

```
cf applications
```

Regardless what service plan the user requests, initially recreate the service with the `solo` plan. This makes it easier to find a single Docker container and stop it.

```
cf create-service dingo-postgresql95 solo important-db
```

## <a id="find-docker-host"></a>Find docker host

The new service instance will backed by a single Docker container running on one of the `cell` VMs. You will need to find that Docker container, stop it, replace its new backups with the backups from above, and restart it.

Get the service's GUID:

```
cf service important-db --guid
```

The output might look like:

```
78218ded-7d88-4d69-bd44-6f478c300134
```

Search the syslog logs for the creation of this service, and identify which `cell` VM into which it was allocated. This sequence is a little elaborate at the moment, we acknowledge that, and will make it more awesome in future.

Search for the service GUID in the logs.

Find the creation of the Docker container, and then search the logs for all logs from that Docker container, say `docker/cf-52167ceb-bd3d-4bff-8699-a239d21c5379`.

At the start of the Docker container logs is the announcement of the `public address` (public to the container, private to the rest of the world):

```
Mar 17 17:37:38 14ddd22e-719e-4aca-b318-7f291c97fbba docker/cf-52167ceb-bd3d-4bff-8699-a239d21c5379:  looking up public host:port from etcd -> 10.58.111.149:4001/v2/keys/postgresql-patroni/0.cell_z1-partition-cac94a070a81fd8f3931.default.dingo-postgresql-98b09c4b36af74181ee1.microbosh:cf-52167ceb-bd3d-4bff-8699-a239d21c5379:5432 (0)
Mar 17 17:37:38 14ddd22e-719e-4aca-b318-7f291c97fbba docker/cf-52167ceb-bd3d-4bff-8699-a239d21c5379:  public address 10.58.111.150:32785
```

The `public address 10.58.111.150:32785` shows the hostname `10.58.111.150` for the Docker container.

You will now switch to using the `bosh` CLI to locate and `ssh` into the Docker host.

## <a id="bosh-ssh"></a>bosh ssh

Behind the scenes of Pivotal Ops Manager is the open source orchestration tool [BOSH](https://bosh.io). Even if you've never used BOSH before, this guide will give you steps that will work for you.

First, SSH into your Ops Manager VM, and provide the password if necessary:

```
ssh ubuntu@OPSMGR_IP
```

You need to find the `dingo-postgresql-xxxxxxxx` deployment running on BOSH and confirm which "bosh job" (a server instance) maps to `10.58.111.150` from above.

```
bosh deployments
```

This will output a table of deployments, including your `cf-xxxxxx` deployment for Pivotal Cloud Foundry&reg; itself.

```
+---------------------------------------+-...
| Name                                  |
+---------------------------------------+-...
| cf-6cd776bba8e791d40f64               |
+---------------------------------------+-...
| dingo-postgresql-98b09c4b36af74181ee1 |
+---------------------------------------+-...
...
```

Next, confirm that `dingo-postgresql-98b09c4b36af74181ee1` contains a job with IP `10.58.111.150`:

```
bosh vms dingo-postgresql-98b09c4b36af74181ee1 | grep 10.58.111.150
```

If the last line of output looks like `| cell_xxxxx/123 | running | cell_xxxxx | 10.58.111.150` then we have found the job/instance.

```
Acting as user 'director' on deployment 'dingo-postgresql-98b09c4b36af74181ee1' on 'p-bosh-f93dc37aed3d3b4d03e9'
| cell_z1-partition-cac94a070a81fd8f3931/0 | running | cell_z1-partition-cac94a070a81fd8f3931 | 10.58.111.150 |
```

To SSH into the `cell_z1-partition-cac94a070a81fd8f3931/0` job we need to download the BOSH deployment manifest (this file is created and managed by Pivotal OpsManager on behalf of the Dingo PostgreSQL™ tile).

```
bosh download manifest dingo-postgresql-98b09c4b36af74181ee1 dingo-postgresql.yml
```

To SSH into a job:

```
bosh -d dingo-postgresql.yml ssh cell_z1-partition-cac94a070a81fd8f3931/0
```

## <a id="docker-stop"></a>Stop docker container

Inside the BOSH `cell_xxxxx` job, setup the `_docker` helper alias:

```
alias _docker="/var/vcap/packages/docker/bin/docker --host unix:///var/vcap/sys/run/docker/docker.sock"
_docker ps
```

The latter command shows the list of Docker containers on the current host machine:

```
CONTAINER ID        IMAGE                                COMMAND                  CREATED             STATUS              PORTS                     NAMES
0abe124b987d        cfcommunity/postgresql-patroni:9.5   "/scripts/run.sh "       24 minutes ago      Up 24 minutes       0.0.0.0:32785->5432/tcp   cf-52167ceb-bd3d-4bff-8699-a239d21c5379
9b35a273ae9a        cfcommunity/registrator:latest       "/bin/registrator -ho"   2 days ago          Up 2 days                                     registrator
```

NOTE: the `registrator` container is an internal component of Dingo PostgreSQL™ and is expected to be running at all times.

From the [Find docker host](#find-docker-host) section above, the Docker container for our new service was called `cf-52167ceb-bd3d-4bff-8699-a239d21c5379`.

Stop this Docker container:

```
container=cf-52167ceb-bd3d-4bff-8699-a239d21c5379
_docker stop $container
```

In the system logs you might see:

```
Mar 17 18:05:20 0.cell_z1-partition-cac94a070a81fd8f3931.dingo-postgresql-98b09c4b36af74181ee1 docker.stderr.log:  time="2016-03-18T01:05:20.732631854Z" level=info msg="Container 0abe124b987d010de6c0e8079908210e89ca6562c3c08536bc118de0da2cef46 failed to exit within 10 seconds of SIGTERM - using the force"
```

By stopping the Docker container you have stopped the new PostgreSQL database from continually writing to its archive. This will allow you to replace its archive with the contents from the previous service instance - the archive you are trying to recover.

## <a id="cloning-backups"></a>Cloning backups

This section documents Amazon S3 CLI commands, as it is the only supported object store in the current version of Dingo PostgreSQL™.

The new service instance, with its new GUID, has a new target for its object store backups. To restore the old archive backups, you will need to clone them from the original archive to the new archive.

Search the logs by the service GUID `78218ded-7d88-4d69-bd44-6f478c300134` to get the target object store/bucket/folder:

```
patroni>         DETAIL: Uploading "pg_xlog/000000010000000000000004" to "s3://our-dingo-postgresql-backups/backups/ca5a7d15-1422-4408-a00d-93194350a106/wal/wal_005/000000010000000000000004.lzo".
```

The target is `s3://our-dingo-postgresql-backups/backups/ca5a7d15-1422-4408-a00d-93194350a106/wal`.

Set an environment variable for later:

```
target=s3://our-dingo-postgresql-backups/backups/ca5a7d15-1422-4408-a00d-93194350a106/wal
```

Our objective is to sync the original `/wal` folder into the target `/wal` folder above; then restart the Docker container to have it restore itself from the backup.

```
apt-get install -y awscli jq
```

You can use the Docker container's own environment variables to use the `aws` CLI:

```
env $(_docker inspect $container | jq -r ".[0].Config.Env[]" | grep "^AWS_" | xargs) aws s3 ls
```

Setup the source (user's backups):

```
source=s3://our-dingo-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal
```

*CONFIRM:* that you have the correct URIs for `$source` (the backup) and `$target` (the new backup). If you get this wrong then you will destroy their backup.

```
echo $source
echo $target
```

To delete the temporary target backup folder:

```
env $(_docker inspect $container | jq -r ".[0].Config.Env[]" | grep "^AWS_" | xargs) aws s3 rm $target --recursive --region ap-southeast-1
```

This should show about 6 files being deleted.

To then replace with a copy of the user's backup:

```
env $(_docker inspect $container | jq -r ".[0].Config.Env[]" | grep "^AWS_" | xargs) aws s3 sync $source $target --region ap-southeast-1
```

Pass the `--region` flag to the `aws s3` commands if necessary.

The output will show each of the files being sync'd to the new folder:

```
copy: s3://our-dingo-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/basebackups_005/base_000000010000000000000002_00000040/extended_version.txt to s3://our-dingo-postgresql-backups/backups/ca5a7d15-1422-4408-a00d-93194350a106/wal/basebackups_005/base_000000010000000000000002_00000040/extended_version.txt
copy: s3://our-dingo-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/wal_005/000000010000000000000006.lzo to s3://our-dingo-postgresql-backups/backups/ca5a7d15-1422-4408-a00d-93194350a106/wal/wal_005/000000010000000000000006.lzo
copy: s3://our-dingo-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/sysids/sysid to s3://our-dingo-postgresql-backups/backups/ca5a7d15-1422-4408-a00d-93194350a106/wal/sysids/sysid
copy: s3://our-dingo-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/basebackups_005/base_000000010000000000000002_00000040_backup_stop_sentinel.json to s3://our-dingo-postgresql-backups/backups/ca5a7d15-1422-4408-a00d-93194350a106/wal/basebackups_005/base_000000010000000000000002_00000040_backup_stop_sentinel.json
copy: s3://our-dingo-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/wal_005/000000010000000000000007.lzo to s3://our-dingo-postgresql-backups/backups/ca5a7d15-1422-4408-a00d-93194350a106/wal/wal_005/000000010000000000000007.lzo
copy: s3://our-dingo-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/wal_005/000000010000000000000002.00000028.backup.lzo to s3://our-dingo-postgresql-backups/backups/ca5a7d15-1422-4408-a00d-93194350a106/wal/wal_005/000000010000000000000002.00000028.backup.lzo
copy: s3://our-dingo-postgresql-backups/backups/6e101b27-ee1b-4f4d-a032-4401a3709ec3/wal/wal_005/000000010000000000000002.lzo to s3://our-dingo-postgresql-backups/backups/ca5a7d15-1422-4408-a00d-93194350a106/wal/wal_005/000000010000000000000002.lzo
```

## <a id="reinitialize-etcd"></a>Reinitialize ETCD

The new service instance's backup has been replaced by the old service instance's backup. But it has a different PostgreSQL System ID in it; and the wrong value is currently being cached in ETCD.

```
service_id=6e101b27-ee1b-4f4d-a032-4401a3709ec3
export $(_docker inspect $container | jq -r ".[0].Config.Env[]" | grep ETCD_HOST_PORT)
curl $ETCD_HOST_PORT/v2/keys/service/${service_id} | jq .
```

The results from the last two commands show the internal data about the Patroni/PostgreSQL/Docker containers in this cluster (currently one `solo` container).

The system ID in ETCD (under `/initialize`) is for the original database; not for the backed up database. So delete it in ETCD and the restoration process will recreate it from the backup:

```
curl $ETCD_HOST_PORT/v2/keys/service/${service_id}/initialize -XDELETE
curl $ETCD_HOST_PORT/v2/keys/service/${service_id}/optime/leader -XDELETE
```

## <a id="flush-local-db"></a>Flush local data

If the Docker container was started now it would resume with its local database rather than pull down the backup.

```
host_data_dir=$(_docker inspect $container | jq -r ".[0].Mounts[] | select(.Destination == \"/data\") | .Source")
sudo rm -rf $host_data_dir/*
```

## <a id="restart-and-test"></a>Restart and test

Finally, restart the Docker container.

```
_docker start $container
```

Watch the system logs to observe a fresh database being created and restored from the S3 backup.

As the container starts up, the following log line should be observed:

```
restore_leader_if_missing> preparing patroni to restore this container from wal-e backups
```

Once you've observed the WAL files being fetched from the target backup, and the database starting up successfully, you can then bind the Pivotal Cloud Foundry&reg; service instance to the user's application and check that it works as expected.

```
cf bind-service their-app important-db
cf restart their-app
```
