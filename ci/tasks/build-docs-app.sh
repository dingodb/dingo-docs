#!/bin/bash

set -e # fail fast

cd docs

cd docs-book
sed -i "s/ruby '2.0.0'/ruby '2.2.4'/g" Gemfile
bundle update

bin/bookbinder bind local
cd final_app

sed -i "s/ruby '2.0.0'/ruby '2.2.4'/g" Gemfile
bundle update

cat >manifest.yml <<EOF
---
applications:
- name: docs
  memory: 256M
  instances: 1
  host: docs
  domain: dingotiles.com
EOF
