---
title: Overview of Dingo S3 for Pivotal Cloud Foundry
---

Most applications running on Pivotal Cloud Foundry require somewhere to upload & retrieve files/objects/blobs. It is an anti-pattern to use a shared file system; and as such Pivotal Cloud Foundry installations do not offer one. Instead, it is best to offer a bucket service/blobstore/object store.

Amazon Simple Storage Service (Amazon S3), provides developers and IT teams with secure, durable, highly-scalable object storage.

The Dingo S3 tile offers a bucket/blob/object store service to applications, backed by the legendary Amazon Simple Storage Service (Amazon S3). Amazon S3 provides developers and IT teams with secure, durable, highly-scalable object storage.

Once Dingo S3 is installed then every developer is enabled to go fast - create new S3 buckets on demand, or create them within CI pipelines, and discard when no longer necessary.

Dingo S3 makes Amazon S3 safe and secure across all organizations. Each application is only able to access the single S3 bucket it is bound to.

Any application written in any programming language can bind to an Amazon S3 bucket and communicate with its API. Many languages have libraries that make it even easier.
