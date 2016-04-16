#!/bin/bash

bin/bookbinder bind local --verbose
cd final_app
bundle
rackup -p 4567
