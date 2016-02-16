---
title: Administration
---

## <a id="dingo-s3-logs"></a>Dingo S3 logs

Dingo S3 is installed as an application running on your Pivotal Cloud Foundry in the `system` organization.

You can use the `cf logs` command to see recent or incoming logs:

```
cf t -o system -s dingo-s3
cf logs s3-cf-service-broker --recent
cf logs s3-cf-service-broker
```
