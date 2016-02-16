#!/bin/bash

set -e # fail fast
set -x # show commands

ruby_version=2.1.5

cd docs/docs-book
sed -i "s/ruby '2.0.0'/ruby '${ruby_version}'/g" Gemfile
cat Gemfile
bundle update

bin/bookbinder bind local
cd final_app

sed -i "s/ruby '2.0.0'/ruby '${ruby_version}'/g" Gemfile
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
