#!/usr/bin/env bash

while read -r line  
do
    name="$line"
    echo "$name" > inp-params.txt
    ./tas 
    ./cas
    ./cas_bounded
done <  now.txt

