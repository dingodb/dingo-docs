#!/bin/bash

set -e # fail fast
set -x # show commands

cd docs/docs-book
sed -i "s/ruby '2.0.0'//g" Gemfile
cat Gemfile
bundle update --local
bundle install --binstubs

./bin/bookbinder bind local
cd final_app

sed -i "s/ruby '2.0.0'//g" Gemfile
bundle update --local
bundle install --binstubs

cat >manifest.yml <<EOF
---
applications:
- name: docs
  memory: 256M
  instances: 1
  host: docs
  domain: dingotiles.com
EOF
