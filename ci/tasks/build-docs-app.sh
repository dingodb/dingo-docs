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
echo "gem 'puma'" >> Gemfile
bundle update --local
bundle install --binstubs
bundle package

cat >manifest.yml <<EOF
---
applications:
- name: docs
  memory: 256M
  instances: 1
  host: docs
  buildpack: ruby_buildpack
  domain: dingotiles.com
  hosts:
  - www
  - docs
EOF

cat manifest.yml
pwd
