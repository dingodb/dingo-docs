---
title: Example applications for Dingo PostgreSQL
---

The community of Cloud Foundry & PostgreSQL users have created some example applications that can bind to Dingo PostgreSQL service credentials.

| Language | Source Code |
| --- | --- |
| ruby/rails | TODO |
| node.js | TODO |
| java | TODO |

## Ruby on Rails

Dingo PostgreSQL is built to integrate cleanly with the [ruby-buildpack](https://github.com/cloudfoundry/ruby-buildpack) and its [expected service bindings](https://docs.cloudfoundry.org/buildpacks/ruby/ruby-service-bindings.html).

At runtime, the Ruby buildpack creates a `$DATABASE_URL` environment variable.
