---
title: Provision &amp; bind new Secrets vault
---

Dingo Secrets™ allows all Pivotal Cloud Foundry&reg; users to create and use Hashicorp Vault within their applications.

## <a id="provision"></a>Provision & bind

You can create a new Dingo Secrets vault using the `cf create-service` (or `cf cs` alias):

```
cf create-service dingo-secrets shared myapp-vault
```

You can then share the vault with one or more applications within the same Cloud Foundry "space".

```
cf bind-service myapp myapp-vault
```

Applications will have access to the Vault via the Vault API, root token and root path provided in the credentials (see below).

```
cf restart myapp
```

## <a id="credentials"></a>Credentials

The Vault API, root token and root path are passed to your application via environment variables, specifically [`$VCAP_SERVICES`](https://docs.cloudfoundry.org/devguide/deploy-apps/environment-variable.html#VCAP-SERVICES).

Either use a JSON parser or find a language-specific community Cloud Foundry library to make navigating this environment variable easy.

See the [Language Examples](lang-examples.html) for samples of looking up the credentials.

The `credentials` section contains the following keys:

```json
{
 "root": "secret/cc0d9c34-0d83-4666-9b09-07066d2c1b7b",
 "token": "07eef997-7fa0-4b86-bc32-9d42279f82de",
 "vault": "http://10.58.123.123:8200"
}
```
