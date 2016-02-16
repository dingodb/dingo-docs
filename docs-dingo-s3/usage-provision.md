---
title: Using Dingo S3 with Pivotal Cloud Foundry
---

Dingo S3 allows all Pivotal Cloud Foundry users to create and use Amazon S3 buckets within their applications. Applications can then use any Amazon S3 library/SDK to read & write to the Amazon S3 API.

## <a id="provision"></a>Provision & bind

You can create a new Amazon S3 bucket using the `cf create-service` (or `cf cs` alias):

```
cf create-service dingo-s3 basic myapp-bucket
```

You can then share the bucket with one or more applications within the same Cloud Foundry "space".

```
cf bind-service myapp myapp-bucket
```

Applications will have access to the bucket name and Amazon S3 API credentials when they are next pushed, restarted or restaged.

```
cf restart myapp
```

## <a id="provision"></a>Unbind & destroy
