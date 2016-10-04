#!/bin/bash

set -e # fail fast
set -x # show commands

git clone docs docs-app

cd docs-app/docs-book
sed -i "s/^ruby.*//g" Gemfile
cat Gemfile
bundle update --local
bundle install --binstubs

./bin/bookbinder bind local --verbose
cd final_app

sed -i "s/^ruby.*//g" Gemfile
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
  routes: ${routes}
EOF

cat manifest.yml
pwd
