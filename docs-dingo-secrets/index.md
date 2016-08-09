---
title: Overview of Dingo Secrets™ for Pivotal Cloud Foundry&reg;
---

Most applications running on Pivotal Cloud Foundry&reg; require somewhere to upload & retrieve files/objects/blobs. It is an anti-pattern to use a shared file system; and as such Pivotal Cloud Foundry&reg; installations do not offer one. Instead, it is best to offer a vault service/blob store/object store.

Amazon Simple Storage Service (Amazon Secrets), provides developers and IT teams with secure, durable, highly-scalable object storage.

The Dingo Secrets™ tile offers a vault/blob/object store service to applications, backed by the legendary Amazon Simple Storage Service (Amazon Secrets). Amazon Secrets provides developers and IT teams with secure, durable, highly-scalable object storage.

[![dingo-secrets-architecture](/dingo-secrets/images/architecture.png)](/dingo-secrets/about-tile.html)

Once Dingo Secrets™ is installed then every developer is enabled to go fast - create new Secrets vaults on demand, or create them within CI pipelines, and discard when no longer necessary.

Dingo Secrets™ makes Amazon Secrets safe and secure across all organizations. Each application is only able to access the single Secrets vault it is bound to.

Any application written in any programming language can bind to an Dingo Secrets vault and communicate with its API. Many languages have libraries that make it even easier.

<ul class="panels">
  <li class="panel span3">
    <a class="button" href="http://docs.pivotal.io/pivotalcf/getstarted/pcf-docs.html">
      <h2 class="title-flashy" style="padding-top: 0em; padding-left: 0em; line-height: 0.7em; margin-top: 0em;">
        <span class="title-deemph" style="font-size: 0.6em;">Get</span><br>
        <span style="font-size: 0.8em;">Pivotal CF</span>
      </h2>
    </a>
  </li>
  <li class="panel span3">
    <a class="button" href="/dingo-secrets/download.html">
      <h3 class="title-flashy" style="padding-top: 0em; padding-left: 0em; line-height: 0.7em; margin-top: 0em;">
        <span class="title-deemph" style="font-size: 0.6em;">Download</span><br>
        <span style="font-size: 0.8em;">Dingo Secrets™</span>
      </h3>
    </a>
  </li>
  <li class="panel span3">
    <a class="button" href="/dingo-secrets/usage-provision.html">
      <h3 class="title-flashy" style="padding-top: 0em; padding-left: 0em; line-height: 0.7em; margin-top: 0em;">
        <span class="title-deemph" style="font-size: 0.6em;">Create vaults</span><br>
        <span style="font-size: 0.8em;">Amazon Secrets</span>
      </h3>
    </a>
  </li>
</ul>
