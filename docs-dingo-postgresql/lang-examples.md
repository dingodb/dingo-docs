---
title: Example applications for Dingo PostgreSQL
---

The community of Cloud Foundry & PostgreSQL users have created some example applications that can bind to Dingo PostgreSQL service credentials.

| Language | Source Code |
| --- | --- |
| ruby/rails | TODO |
| node.js | [Ghost blogging platform](https://github.com/dingotiles/ghost-for-cloudfoundry) |
| java | TODO |

## Node.js

Use https://www.npmjs.org/package/cfenv ([source code](https://github.com/cloudfoundry-community/node-cfenv)) to discover service binding credentials to Dingo PostgreSQL.

See the example application [Ghost blogging platform](https://github.com/dingotiles/ghost-for-cloudfoundry) (modified from Ghost v0.7.8 release).

Assuming you have bound a service with `pg` in its name:

```
var env = process.env.NODE_ENV || 'development';
var production = env == 'production';

var appEnv = {};
var sqlCredentials = {};
if (production) {
  var cfEnv = require("cfenv");
  var appEnv = cfEnv.getAppEnv();
  var sqlCredentials = appEnv.getService(/pg/).credentials;
}
console.log(sqlCredentials);
```

The `appEnv.getService(/pg/)` command will look for the first binding whose service name matches the regular expression `/pg/`.

## Ruby on Rails

Dingo PostgreSQL is built to integrate cleanly with the [ruby-buildpack](https://github.com/cloudfoundry/ruby-buildpack) and its [expected service bindings](https://docs.cloudfoundry.org/buildpacks/ruby/ruby-service-bindings.html).

At runtime, the Ruby buildpack creates a `$DATABASE_URL` environment variable.

## PHP

https://github.com/cloudfoundry-community/cf-helper-php
