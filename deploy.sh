#!/bin/bash

set -e # fail fast

cf t -o dingotiles -s docs-production

cd docs-book
bin/bookbinder bind local
cd final_app

cf push docs
