#!/usr/bin/bash

for mode in prod dev; do
    mkdir -p build/js/$mode;
    cp static/index.html build/js/${mode}/index.html
done