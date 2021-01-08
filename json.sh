#! /usr/bin/env bash

json_extract(){
    local code
    code=$(cat "./json_walk")
    echo '{
        "a": "1"
    }' | awk "$code" -
}
