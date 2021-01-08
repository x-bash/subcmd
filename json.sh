#! /usr/bin/env bash

# . json.sh; json.extract

json_extract(){
    echo '{
    "aa": true,
    "a": "1",
    "b": [1, 2, 3],
    "c": [ ],
    "d": { },
    "5": {
        "a": 1
    }
}' | json_main
}

# . json.sh; time cat test-data/b.json | json_main

json_main(){
    local code
    code=$(cat "./json_walk" "./json_extract")
    awk "$code" -
}


