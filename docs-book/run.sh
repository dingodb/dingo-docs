#!/bin/bash

bin/bookbinder bind local
cd final_app
bundle
rackup -p 4567
