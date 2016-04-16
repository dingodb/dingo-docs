#!/bin/bash

set -e # fail fast
set -x # show commands

git clone docs docs-app

cd docs-app/docs-book
sed -i "s/ruby '2.0.0'//g" Gemfile
cat Gemfile
bundle update --local
bundle install --binstubs

./bin/bookbinder bind local --verbose
cd final_app

sed -i "s/ruby '2.0.0'//g" Gemfile
echo "gem 'puma'" >> Gemfile
bundle update --local
bundle install --binstubs
bundle package

cat >manifest.yml <<EOF
---
applications:
- name: ${app_name}
  memory: 256M
  instances: 1
  buildpack: ruby_buildpack
  domain: dingotiles.com
  hosts: ${app_hosts}
EOF

cat manifest.yml
pwd
