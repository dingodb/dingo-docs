---
title: Overview of Dingo S3 for Pivotal Cloud Foundry
---

Most applications running on Pivotal Cloud Foundry require somewhere to upload & retrieve files/objects/blobs. It is an anti-pattern to use a shared file system; and as such Pivotal Cloud Foundry installations do not offer one. Instead, it is best to offer a bucket service/blobstore/object store.

The Dingo S3 tile offers a bucket/blob/object store service to applications, backed by the legendary Amazon S3 public cloud service. You provide the Amazon S3 account, Dingo S3 makes it available to application developers in a safe, secure manner. Each application is only able to access the single S3 bucket it is bound to.

The Dingo S3 product tile allows Pivotal Cloud Foundry users to provision new Amazon S3 buckets, bind them to their applications, and then access the buckets using any Amazon S3 library.
