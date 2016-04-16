---
title: Overview of Dingo S3™ for Pivotal Cloud Foundry
---

Most applications running on Pivotal Cloud Foundry require somewhere to upload & retrieve files/objects/blobs. It is an anti-pattern to use a shared file system; and as such Pivotal Cloud Foundry installations do not offer one. Instead, it is best to offer a bucket service/blob store/object store.

Amazon Simple Storage Service (Amazon S3), provides developers and IT teams with secure, durable, highly-scalable object storage.

The Dingo S3™ tile offers a bucket/blob/object store service to applications, backed by the legendary Amazon Simple Storage Service (Amazon S3). Amazon S3 provides developers and IT teams with secure, durable, highly-scalable object storage.

[![dingo-s3-architecture](/dingo-s3/images/architecture.png)](/dingo-s3/about-tile.html)

Once Dingo S3™ is installed then every developer is enabled to go fast - create new S3 buckets on demand, or create them within CI pipelines, and discard when no longer necessary.

Dingo S3™ makes Amazon S3 safe and secure across all organizations. Each application is only able to access the single S3 bucket it is bound to.

Any application written in any programming language can bind to an Amazon S3 bucket and communicate with its API. Many languages have libraries that make it even easier.

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
    <a class="button" href="/dingo-s3/download.html">
      <h3 class="title-flashy" style="padding-top: 0em; padding-left: 0em; line-height: 0.7em; margin-top: 0em;">
        <span class="title-deemph" style="font-size: 0.6em;">Download</span><br>
        <span style="font-size: 0.8em;">Dingo S3™</span>
      </h3>
    </a>
  </li>
  <li class="panel span3">
    <a class="button" href="/dingo-s3/usage-provision.html">
      <h3 class="title-flashy" style="padding-top: 0em; padding-left: 0em; line-height: 0.7em; margin-top: 0em;">
        <span class="title-deemph" style="font-size: 0.6em;">Create buckets</span><br>
        <span style="font-size: 0.8em;">Amazon S3</span>
      </h3>
    </a>
  </li>
</ul>
