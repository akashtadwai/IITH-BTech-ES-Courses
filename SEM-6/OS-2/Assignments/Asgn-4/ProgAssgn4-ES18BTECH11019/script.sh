#!/usr/bin/env bash

while read -r line  
do
    name="$line"
    echo "$name" > input.txt
    ./korean
done <  now.txt

