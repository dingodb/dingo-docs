---
title: Access S3 credentials
---

TODO: blocked on implementing support for Service Keys https://trello.com/c/V1x9a9ek/73-support-service-keys-appguid-field-required

## Binding credentials

## Service keys

There can be situations where you'd like to explicitly generate Amazon S3 access credentials without binding them to an application. Pivotal Cloud Foundry v1.6+ supports [Service Keys](http://docs.cloudfoundry.org/devguide/services/service-keys.html).

First, create a new bucket (if not already created):

```
cf create-service dingo-s3 basic mybucket
```

Next, create a Service Key:

```
cf create-service-key mybucket mybucket-key
```

The output may look like:

TODO - this is broken.


```
cf service-key mybucket-key
```
