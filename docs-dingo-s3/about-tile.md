---
title: Dingo S3™ tile and Amazon S3
---

If your Pivotal Cloud Foundry has access to the Internet, or at a minimum has access to Amazon Web Services (AWS) APIs, then you are strongly recommended to consider using Amazon S3 for all your applications' object storage needs.

To make this simple, and to make it low overhead and fast for 100s and 1000s of your developers, we created Dingo S3™.

Once Dingo S3™ is installed and is connected to Amazon S3 with a single AWS account, it can dynamically and rapidly create new Amazon S3 buckets, and create unique AWS access credentials for applications that only allow access to a specific Amazon S3 bucket.

## Fast and secure for everyone

Users of the `cf` CLI or of the Pivotal Web Console can request new buckets be created and have new credentials allocated (see section [Provision &amp; bind new S3 bucket](/dingo-s3/usage-provision.html)).

If you or your developers ever need to revoke permissions to an Amazon S3 bucket then it can be done in seconds with the standard Cloud Foundry `cf` CLI (see section [Revoke access &amp; destroy buckets](/dingo-s3/usage-delete.html)).

## Architecture

Dingo S3™ is a brokering service between the Pivotal Elastic Runtime and the public Amazon S3 service.

![dingo-s3-architecture](/dingo-s3/images/architecture.png)

Requests from the `cf` CLI or Pivotal Web Service are sent to the Pivotal Elastic Runtime API, which forwards them to the Dingo S3™ broker. Dingo S3™ then communicates with Amazon S3 API to create/destroy buckets; and with Amazon's identity management (IAM) API to create users/permissions to access the buckets.

When an application is given AWS access credentials, it will directly communicate with the Amazon S3 API. Applications do not communicate, nor are they aware, of Dingo S3™ (see sections [AWS SDKs](/dingo-s3/lang-s3-sdk.html) and [Language examples](/dingo-s3/lang-examples.html)).
