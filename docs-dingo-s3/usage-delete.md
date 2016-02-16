---
title: Revoke access &amp; destroy buckets
---

## Revoke AWS credentials

When an application no longer needs to communicate with an S3 bucket, or if you want to **revoke** the permissions for an application to communicate with an S3 bucket, then you can unbind the service.

```
cf unbind-service myapp myapp-bucket
```.

## Destroy S3 bucket

When you are very sure you no longer want an S3 bucket, nor any of its contents or metadata, you can destroy it.

```
cf delete-service myapp-bucket
```
