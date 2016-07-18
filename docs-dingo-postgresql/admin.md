---
title: Administering Dingo PostgreSQL™
---

## Logs

## <a id="lookup-service-guid"></a>Lookup Service Instance GUID

```
cf service <service-name> --guid
```

## <a id="logs-service-id"></a>Move cluster to different cells/vms

When a user creates a new Dingo PostgreSQL cluster, two containers running PostgreSQL are placed on two different cells (the Dingo PostgreSQL name for a virtual machine/server that can run PostgreSQL; this name is borrowed from the Cloud Foundry Diego name for the VMs that can run containers, though we do not use Diego), in two different availability zones (if your deployment of Dingo PostgreSQL is configured with multiple availability zones). The containers running PostgreSQL are called "nodes".

Over time, as an administrator, you might wish to move the nodes from their original cells to different/bigger/emptier cells. As an administrator you can do this using the same `cf` command line tool that users used to create their cluster.

As an overview, you will run the `cf update-service` command and provide the `cell-guids` parameter to dictate which cells the nodes should be moved to:

```
cf target -o your-users-org -s your-users-space
cf update-service your-users-dingo-pg -p '{"cell-guids": ["10.1.10.20", "10.1.20.20"]}'
```

*Currently, the `cell-guids` are the IPs of the cells, though this may change in future.*

This process will be performed with minimal downtime (the time to failover the current leader/master to one of the new replicas).

The internal process for moving a two-node cluster will be:

* create two new nodes on the specified `"cell-guids"` (that is, grow the cluster from two to four nodes)
* wait until the new nodes are healthy replicas of the current leader
* remove the original nodes, whilst failing over the current leader to one of the new replicas
* update the routing mesh to reference the new leader node

To discover which cells the cluster (aka `service_instance`) is currently using:

```
instance_id=$(cf service your-users-dingo-pg --guid)
broker_uri=username:password@10.58.111.48:8889
curl -s ${broker_uri}/admin/service_instances/${instance_id} | jq .nodes
```

To discover the available cells and their cell GUIDs, you can interact with the service broker directly with the `curl` tool:

```
BROKER_URI=username:password@10.58.111.48:8889
curl -s ${BROKER_URI}/admin/cells | jq .
```

The output may look similar to:

```json
[
  {
    "guid": "10.1.10.20",
    "availability_zone": "z1",
  },
  {
    "guid": "10.1.20.20",
    "availability_zone": "z2",
  },
]
```

Since you are manually selecting cells, remember to select cells that are in two different availability zones. The two examples above are in different zones: `z1` and `z2`.

To move the cluster to the two cells above, using their `guid`:

```
cf update-service your-users-dingo-pg -p '{"cell-guids": ["10.244.21.7", "10.244.22.3"]}'
```

This is a long-running asynchronous process and the command above will return successfully before the entire orchestration has completed. To poll for completion, run either:

```
cf service your-users-dingo-pg
cf services
```

We suggest you confirm that the bound apps are working after this `cf update-service` process has completed. It may be necessary to `cf restart` each bound app if the applications do not natively reconnect to the routing mesh after the update.

## <a id="logs-service-id"></a>Search logs for service instance

Search your system logs for the service instance GUID and you will see Dingo PostgreSQL™ setting up routing and provision Docker containers.

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
