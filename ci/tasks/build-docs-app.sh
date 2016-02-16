#!/bin/bash

set -e # fail fast

cd docs

cd docs-book
bundle
bin/bookbinder bind local
cd final_app

cat >manifest.yml <<EOF
---
applications:
- name: docs
  memory: 256M
  instances: 1
  host: docs
  domain: dingotiles.com
EOF
