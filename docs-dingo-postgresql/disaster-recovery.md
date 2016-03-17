---
title: Recovering from disasters
---

This section tries to document every type of disaster you might encounter and help guide you through its recovery.

Please, practice each of these disasters in a controlled environment before they happen in real life.

## What can be recovered?

At the core of all disaster recovery is the streaming archives of all databases to a object store like Amazon S3.

When installing Dingo PostgreSQL you will specify which object store to use. Every time any user creates a new Dingo PostgreSQL service instance it will automatically create a base backup, and every 10 minutes or less a new write-ahead log (WAL) will be uploaded. This means that the worst case for data loss should be 10 minutes of data for each database.

## User disasters

If a user accidentally deletes their service instance, it is a disaster to them. When a user accidentally writes or deletes data from their database, it is a disaster to them.

In the future of Dingo PostgreSQL we want to allow user's to resolve their own disasters. It is our design philosophy for platform-as-a-service, such as Pivotal Cloud Foundry, that all database-orientated admin features be made available to end users - they in turn can decide who will do administration for their databases.

For now, a Pivotal Cloud Foundry operator will be required to help recover from user disasters. But the great news is that it is possible to recover from disasters.

* [Recover a user's deleted service instance](recover-user-deleted-service.html)

## Complete disasters

Infrastructure and software is not fault proof. Servers, disks, and software systems all fail eventually.

Humans are not fault proof. History lesson: One of the original authors of Dingo PostgreSQL accidentally destroyed an entire PostgreSQL platform - over a hundred PostgreSQL databases - prior to the implementation of recoverable backups for that platform. Never again. Dingo PostgreSQL has recoverable archives built into every database - it is a core design goal.
