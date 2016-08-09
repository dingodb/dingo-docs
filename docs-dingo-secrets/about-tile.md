---
title: Dingo Secrets™ tile and Hashicorp Vault
---

Dingo Secrets tile for Pivotal Cloud Foundry provides all developers' applications a tool for managing their secrets.

Dingo Secrets packages and deploys [Hashicorp Vault](https://www.vaultproject.io/).

Vault secures, stores, and tightly controls access to tokens, passwords, certificates, API keys, and other secrets in modern computing. Vault handles leasing, key revocation, key rolling, and auditing. Through a unified API, users can access an encrypted Key/Value store and network encryption-as-a-service, or generate AWS IAM/STS credentials, SQL/NoSQL databases, X.509 certificates, SSH credentials, and more.

Features include:

* Secret storage
* Key rolling
* Audit logs

Every Dingo Secrets service instance gets its own policy, its own credentials/root token, and its own area in the secret path hierarchy.

Example credentials from a service binding within an application:

```json
{
 "root": "secret/cc0d9c34-0d83-4666-9b09-07066d2c1b7b",
 "token": "07eef997-7fa0-4b86-bc32-9d42279f82de",
 "vault": "http://10.58.123.123:8200"
}
```
