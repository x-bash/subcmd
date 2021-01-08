#! /usr/bin/env bash

json_extract(){
    local code
    code=$(cat "./json_walk" "./json_extract")
    echo '{
    "a": "1",
    "b": [1, 2, 3],
    "5": {
        "a": 1
    }
}' | awk "$code" -
}
