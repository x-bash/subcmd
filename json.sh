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
    awk "$(cat "./json_walk")" -
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


# Scheme 1:
# out_color_key = "\033[0;35m"
# out_color_string = "\033[0;34m"
# out_color_number = "\033[0;32m"
# out_color_null = "\033[0;33m"   # "\033[0;31m"
# out_color_true = "\033[7;32m"
# out_color_false = "\033[7;31m"

# Scheme 2:
# out_color_key = "\033[1;34m"
# out_color_string = "\033[0;33m"
# out_color_number = "\033[1;35m"
# out_color_null = "\033[0;31m"
# out_color_true = "\033[7;32m"
# out_color_false = "\033[7;31m"

# Scheme 3:
# out_color_key = "\033[1;33m"
# out_color_string = "\033[0;34m"
# out_color_number = "\033[0;35m"
# out_color_null = "\033[0;31m"
# out_color_true = "\033[7;32m"
# out_color_false = "\033[7;31m"

json.awk.color1(){
    local IFS=$' '
    A=(
    -v out_color_key="\033[0;35m"
    -v out_color_string="\033[0;34m"
    -v out_color_number="\033[0;32m"
    -v out_color_null="\033[0;33m"
    -v out_color_true="\033[7;32m"
    -v out_color_false="\033[7;31m"
    )
    echo "${A[*]}"
}

