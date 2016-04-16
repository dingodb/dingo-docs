---
title: Provision &amp; bind new S3 bucket
---

Dingo S3™ allows all Pivotal Cloud Foundry users to create and use Amazon S3 buckets within their applications. Applications can then use any Amazon S3 library/SDK to read & write to the Amazon S3 API.

## <a id="provision"></a>Provision & bind

You can create a new Amazon S3 bucket using the `cf create-service` (or `cf cs` alias):

```
cf create-service dingo-s3 essential myapp-bucket
```

You can then share the bucket with one or more applications within the same Cloud Foundry "space".

```
cf bind-service myapp myapp-bucket
```

Applications will have access to the bucket name and Amazon S3 API credentials when they are next pushed, restarted or restaged.

```
cf restart myapp
```

## <a id="credentials"></a>Credentials

The bucket name and API access credentials are passed to your application via environment variables, specifically [`$VCAP_SERVICES`](https://docs.cloudfoundry.org/devguide/deploy-apps/environment-variable.html#VCAP-SERVICES).

Either use a JSON parser or find a language-specific community Cloud Foundry library to make navigating this environment variable easy.

See the [Language Examples](lang-examples.html) for samples of looking up the credentials.

The `credentials` section contains the following keys:

```json
{
  "username": "IAM_USER_NAME",
  "access_key_id": "AWS_ACCESS_KEY",
  "secret_access_key": "AWS_SECRET",
  "bucket": "BUCKET_NAME"
}
```
