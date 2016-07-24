---
title: Release Notes
---

## <a id="v0.9"></a> v0.9

This version was created for the platform administrators, who we love dearly.

### To upgrade

You will be required to upgrade the number of cells (see "Resource Config") to 2 each ("Cell - Availability Zone 1" and "Cell - Availability Zone 2"). See below for discussion.

This edition includes a rewrite of the scheduling planner for cluster changes (new clusters and updated clusters). It both fixes a bug in placing new nodes in different availability zones, and implements "moving" nodes to different cells.

*Moving nodes* is an exciting new feature for Dingo PostgreSQL - which isn't offered by any other Pivotal Network tile as far as we are aware. Administrators can now "move" the nodes in a cluster to different cells. They can even move the entire cluster, including the current leader/master.

In reality the nodes aren't "moved". Rather, the cluster is expanded, replicated, and collapsed. For each node that must be "moved", a new node is added (the cluster expands) and the contents of the leader are replicated to the new nodes. Then, the nodes being moved are deleted. If this includes the leader, then a new leader is elected and the routing mesh is updated.

An administrator can perform this function using the built-in `cf update-service` command, passing `cells` parameters:

```
cf target -o their-org -s their-space
cf update-service their-db -c '{"cells": ["10.244.22.2", "10.244.21.7"]}'
```

In the example above, assume that `their-db` is a two-node cluster. If both of the `cells` specified are different from the cells currently being used by the nodes then the cluster will grow from two nodes to four nodes, then the original two nodes will be deleted. One of the two new nodes will become the new leader and the routing mesh will be updated.

*The minimum footprint for cells is now four* - two each in two different availability zones. This is to allow the `sanity-test` errand to test that it can move a cluster's nodes to two different cells.

Where do the `["10.244.22.2", "10.244.21.7"]` values for `cells` come from?

We now introduce some administrator-only API endpoints provided by the service broker itself (where as the `cf update-service` command operates via the Cloud Foundry API).

This release provides the following broker API endpoints:

* GET /admin/cells
* GET /admin/service_instances/UUID

The former `GET /admin/cells` can be used to get a list of all available cells and determine which availability zones they are in. Currently the `cf update-service -c '{"cells": [UUIDs]}'` command uses the UUID values from `/admin/cells` endpoint.

The latter `GET /admin/service_instances/ID` can be used to determine which cells are currently being used by any given service instance. The `UUID` is the Cloud Foundry UUID for the service instance.

One way to determine the UUID for a service instance is:

```
cf service their-db --uuid
```

Alternately, you can use the `cf curl /v2/service_instances` or similar commands to discover service instances and their UUIDs.

## <a id="v0.8"></a> v0.8

First version made available on [Pivotal Network](https://network.pivotal.io/products/dingo-postgresql-for-pcf).
