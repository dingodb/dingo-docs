---
title: Recover from a complete disaster
---

If the installation of Dingo PostgreSQL™ gets distroyed due to an infrastructure failure or accidental deletion of the deployment itis a disaster for the entire organization.

This section documents how to bring back all databases that were effected by restoring them from the archive backups.

## <a id="disaster-problem"></a>The disaster

The disaster is that the entire deployment has gotten wiped out due to an infrastructure failure or accidental deletion in the IaaS console.

Perhaps the deployment was accidentally deleted via bosh:

```
bosh -n delete deployment dingo-postgresql
```

## <a id="reinstall"></a>Restore the deployment

First you need to ensure the restoration of the deployment by redeploying Dingo PostgreSQL™ via OpsManager or BOSH. Refer to the [installation](installation.html) guide for instructions.

## <a id="run-errand"></a>Run disaster-recovery Errand

Once the deployment has been restored run the errand to recover all services registered in cf.

```
bosh run errand disaster-recovery
```

This errand will check cf to find out which services should be present and recreate them from backups.

NOTE: When using OpsManager you must target the same BOSH and use the same manifest that is being used by OpsManager.
The simplest way to do this is to ssh into the server that has OpsManager deployed. The `bosh` command should already be installed and configured correctly. You can find the deployment manifests being used under `/var/tempest/workspaces/default/deployments`.

## <a id="configuring-disaster-recovery"></a>Configuring disaster-recovery
If you are not using OpsManager to deploy Dingo PostgreSQL™ you will need to add the following properties to the BOSH deployment manifest.yml for the errand to run properly:

```
---
properties:
  cf:
    api_endpoint: api.bosh-lite.com
    skip_ssl_verification: true
    user: admin
    password: admin

  servicebroker:
    service_id: beb5973c-e1b2-11e5-a736-c7c0b526363d

```

using the correct credentials for the cf you are using.

The `servicebroker.service_id` key should equal the unique id specified in the manifest under `broker.services.id` for the dingo-postgresql plan.

## <a id="non-cf-services"></a>Restoring non-cf services

Alternatively, if you want to restore database clusters that were not provisioned via cf you can also specify an array of service\_instance\_ids to be restored.
In that case add the following properties to the deployment manifest.yml

```
---
properties:
  restore:
    service_instance_id:
    - id-1
    - id-2
```

By running the same disaster-recovery errand these instances will be restored with data from the latest backups.
