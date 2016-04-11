---
title: Provision &amp; bind new PostgreSQL service
---

Dingo PostgreSQL allows all Pivotal Cloud Foundry users to create and use PostgreSQL within their applications. Applications can then use any PostgreSQL library/SDK or JDBC library to read & write with their database.

## <a id="provision"></a>Provision & bind

You can create a new PostgreSQL database using the `cf create-service` (or `cf cs` alias):

```
cf create-service dingo-postgresql solo myapp-pg
```

You can then share the database with one or more applications within the same Cloud Foundry "space".

```
cf bind-service myapp myapp-pg
```

Applications will have access to the connection credentials when they are next pushed, restarted or restaged.

```
cf restart myapp
```

## <a id="credentials"></a>Credentials

The PostgreSQL connection credentials are passed to your application via environment variables, specifically [`$VCAP_SERVICES`](https://docs.cloudfoundry.org/devguide/deploy-apps/environment-variable.html#VCAP-SERVICES).

Either use a JSON parser or find a language-specific community Cloud Foundry library to make navigating this environment variable easy.

See the [Language Examples](lang-examples.html) for samples of looking up the credentials.

The `credentials` section contains the following keys:

```json
{
  "host": "10.58.111.151",
  "port": 33003,
  "username": "USERNAME",
  "password": "PASSWORD",
  "uri": "postgres://USERNAME:PASSWORD@10.58.111.151:33003/postgres",
  "jdbcUrl": "jdbc:postgresql://10.58.111.151:33003/postgres?username=USERNAME\u0026password=PASSWORD",
  "superuser_username": "SUPERUSERNAME",
  "superuser_password": "SUPERPASSWORD",
  "superuser_uri": "postgres://SUPERUSERNAME:SUPERPASSWORD@10.58.111.151:33003/postgres",
  "superuser_jdbcUrl": "jdbc:postgresql://10.58.111.151:33003/postgres?username=SUPERUSERNAME\u0026password=SUPERPASSWORD"
}
```

Only use the superuser credentials when specifically necessary. If used for general database client connections then there is a risk of bypassing the connection pool limits and accidentally preventing the cluster's replication for functioning, which will adversely prevent high availability failover in future.
