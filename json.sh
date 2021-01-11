#! /usr/bin/env bash

# . json.sh; json_extract

# jq . <<< '{
#     "aa": true,
#     "a": "1\"\\",
#     "c": -1.3,
#     "b": [1, 2, 3],
#     "c": [ { "member": 1} ],
#     "d": { },
#     "5": {
#         "a": 1
#     }
# }'

json_extract(){
    json_main <<< '{
    a: fff, 
    "aa": true,
    "aa1": false,
    "a": "1\"\\",   // hi
    "c": -1.3,      /* hello */
    # hello
    "b": [1, 2, 3],
    "c": [ { "member": 1} ],
    "d": { },
    "5": {
        "a": 1
    }
}'
}

# . json.sh; time json_main  <test-data/b.json >/dev/null
# . json.sh; time cat test-data/b.json | json_main

json_main(){
    awk "$(cat "./json_walk" "./json_extract")" -
}


json_acc(){
    # awk "$(cat "./json_acc")" -
    awk -f ./json_acc -
}

json_acc0(){
    json_acc <<< '{
    "aa": true,
    "aa1": false,
    "a": "1\"\\",
    "c": -1.3,
    "b": [1, 2, 3],
    "c": [ { "member": 1} ],
    "d": { },
    "5": {
        "a": 1
    }
}'
}

