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

## <a id="cf-service_guid"></a>Retreive the service_guid

Login to your cf and run `cf curl /v2/services`. You will return a JSON structure with data about every service that is registered to cf. Note down the `.metadata.guid` for the dingo-postgresql service.

Example:
```
{
  "resources": [
    {
      "metadata": {
        "guid": "01c6d2a7-f14d-4a3d-88ca-6c92d4b45cbb",
        "url": "/v2/services/01c6d2a7-f14d-4a3d-88ca-6c92d4b45cbb",
        "created_at": "2016-04-22T04:27:28Z",
        "updated_at": "2016-04-29T21:47:05Z"
      },
      "entity": {
        "label": "dingo-postgresql",
        "provider": null,
        "url": null,
        "description": "Dedicated PostgreSQL 9.5",
        "long_description": null,
        "version": null,
        "info_url": null,
        "active": true,
        "bindable": true,
        "unique_id": "beb5973c-e1b2-11e5-a736-c7c0b526363d",
        "extra": "{\"displayName\":\"Dingo PostgreSQL\"}"
      },
      "tags": [
        "postgresql95",
        "postgresql"
      ],
      "requires": [],
      "documentation_url": null,
      "service_broker_guid": "baec6039-a932-42dc-b86c-4fea98522f9a",
      "plan_updateable": false,
      "service_plans_url": "/v2/services/01c6d2a7-f14d-4a3d-88ca-6c92d4b45cbb/service_plans"
    }
  ]
}
```

in this case the service_guid is: `01c6d2a7-f14d-4a3d-88ca-6c92d4b45cbb`.

## <a id="redeploy"></a>Redeploy
Redeploy Dingo Postgresql™ with the correct service_guid and cf properties set in the deployment manifest:

```
---
properties:
  cf:
    api_endpoint: api.bosh-lite.com
    skip_ssl_verification: true
    user: admin
    password: admin

  servicebroker:
    service_guid: 01c6d2a7-f14d-4a3d-88ca-6c92d4b45cbb

```

Incase you are using PCF OpsManager to deploy Dingo Postgresql™ you simply need to enter the service_guid into the 'Disaster Recovery' section of the tile settings.

## <a id="run-errand"></a>Run disaster-recovery Errand

Finally run the errand to recover all services registered in cf.
`bosh run errand disaster-recovery`

If you are using PCF OpsManager you will need to target the same Bosh that OpsManager is using and download the deployment manifest before you can run the errand.
