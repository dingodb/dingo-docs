---
title: Installing to Pivotal Ops Manager
---

## <a id="requirements"></a>Requirements

* Pivotal Cloud Foundry&reg;

## <a id="upload-tile"></a>Upload tile

The tile can be downloaded from https://www.dingotiles.com

Click "Import a Product" on the left hand side of your Ops Manager dashboard. Select the `dingo-secrets-x.y.z.pivotal` file to upload.

The "Dingo Secrets™" product will appear in the "Available Products" list. Click "Add" to move it to the Installation Dashboard.

## <a id="first-installation"></a>First installation



![install-step1-no-broker](/dingo-secrets/images/install-step1-no-broker.png)


## <a id="vault-init"></a>Vault initialization

Inside the Dingo Secrets tile, click on the "Status" tab:

![install-step2-vault-ip](/dingo-secrets/images/install-step2-vault-ip.png)

```
export VAULT_ADDR=http://10.213.0.51:8200
vault init
```

The output will look like:

```
Unseal Key 1: b893de45377f14ca73d1873144050cb559558aa83b3041dd0bb3028d5c96cb5301
Unseal Key 2: 38c60a8260c834f6c744a72a16c2f905908c7be3fd1102951eaaa44b4077a66a02
Unseal Key 3: a194cd2c91637c4c3ab53bad9edd6fe87f9fec7dceb20b111bb91ee888e6e99903
Unseal Key 4: d3751181f6b341ee8aaa32870a0417a45b54866283dda78b4604570440d806f304
Unseal Key 5: 4a27d62f07180954775bae00821b8149b44711fcb07eae0f4317eda78849490005
Initial Root Token: 60488d11-5b5b-69ae-42a3-2cc90773fe10

Vault initialized with 5 keys and a key threshold of 3. Please
securely distribute the above keys. When the Vault is re-sealed,
restarted, or stopped, you must provide at least 3 of these keys
to unseal it again.

Vault does not store the master key. Without at least 3 keys,
your Vault will remain permanently sealed.
```

Next you need to manually "unseal" your entire vault. Run `vault unseal` three times, providing the value from `vault init` for `Unseal Key 1`, `Unseal Key 2` and `Unseal Key 3` (or any 3 of the 5 `Unseal Keys`).

```
vault unseal
vault unseal
vault unseal
```

## <a id="second-installation"></a>Second installation

Next, you need to provide Dingo Secrets tile the secret `Initial Root Token` from `vault init`.

Inside the Dingo Secrets tile, under the "Settings" tab, click on the "Service Broker" section:

![install-step3-vault-token](/dingo-secrets/images/install-step3-vault-token.png)

Paste in your `Initial Root Token` into the Vault Token field.

Finish by pressing "Save", and then on the main dashboard press "Apply Changes" as you did in First installation section above.

## <a id="cf-marketplace"></a>Marketplace ready

After the tile has completed installing for the second time, you can now confirm that Dingo Secrets is ready for users:

```
cf marketplace
```
