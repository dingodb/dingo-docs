---
title: Revoke access &amp; destroy vaults
---

## Revoke Vault root token

When an application no longer needs to communicate with an Vault, or if you want to **revoke** the permissions for an application to communicate with an Vault vault, then you can unbind the service.

```
cf unbind-service myapp myapp-vault
```

## Destroy Secrets vault

When you are very sure you no longer want a Secrets vault, nor any of its contents or metadata, you can destroy it.

```
cf delete-service myapp-vault
```
