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

# Using awk to parse ...
# jo b                  == json.color b
# jo b=[1,2,3]          == json.var b [1,2,3]
# jo b.hi.c=5           == json.putkv
# jo b.append(3)        == json.append b 3
# jo b.shift()          == json.shift b
# jo b.values()         == json.values b

# JSON_AWK_PATH="$(xrc.which awk/json_walk)"
JSON_AWK_PATH="./json_walk"
json.var(){
    local varname=${1:?Provide variable name} s
    shift
    s="$(awk -f "$JSON_AWK_PATH" <<<"$@")"
    eval "$varname=\"\$s\""
}

json.color(){
    local varname=${1:?Provide variable name} s
    awk -v format=1 -v color=1 -f "$JSON_AWK_PATH" <<<"${!varname}"
}

json.append(){
    local keypath=${1:?Provide variable name} opv1 opv2="${2:?Provide value}" varname s

    varname=${keypath%%.*}
    opv1=".${keypath#*.}"
    [ "$varname" == "$keypath" ] && opv1="."
    shift 2
    
    if [ "$varname" ]; then
        s="$(awk -v op=append -v opv1="$opv1" -v opv2="$opv2" -f "$JSON_AWK_PATH" <<<"${!varname}")"
    else
        s="$(awk -v op=append -v opv1="$opv1" -v opv2="$opv2" -f "$JSON_AWK_PATH")"
    fi
    eval "$varname=\"\$s\""
}

json.prepend(){
    local keypath=${1:?Provide variable name} opv1 opv2="${2:?Provide value}" varname s

    varname=${keypath%%.*}
    opv1=".${keypath#*.}"
    [ "$varname" == "$keypath" ] && opv1="."
    shift 2
    
    if [ "$varname" ]; then
        s="$(awk -v op=prepend -v opv1="$opv1" -v opv2="$opv2" -f "$JSON_AWK_PATH" <<<"${!varname}")"
    else
        s="$(awk -v op=prepend -v opv1="$opv1" -v opv2="$opv2" -f "$JSON_AWK_PATH")"
    fi
    eval "$varname=\"\$s\""
}

: <<"DOCTEST"
> b={a:1}
> json.putkv b.b 2
> echo "$b"
DOCTEST
json.putkv(){
    local keypath=${1:?Provide variable name} opv1 opv2="${2:?Provide value}" varname s

    varname=${keypath%%.*}
    opv1=".${keypath#*.}"
    [ "$varname" == "$keypath" ] && opv1="."
    shift 2
    
    if [ "$varname" ]; then
        s="$(awk -v dbg=1 -v op=putkv -v opv1="$opv1" -v opv2="$opv2" -f "$JSON_AWK_PATH" <<<"${!varname}")"
    else
        s="$(awk -v op=putkv -v opv1="$opv1" -v opv2="$opv2" -f "$JSON_AWK_PATH")"
    fi
    eval "$varname=\"\$s\""
}

: <<"DOCTEST"
> b=[1,2,3]
> json.values b
1
2
3
DOCTEST
json.values(){
    local keypath=${1:?Provide variable name} opv1 varname s

    varname=${keypath%%.*}
    opv1=".${keypath#*.}.*"
    [ "$varname" == "$keypath" ] && opv1=".*"
    shift 2
    
    if [ "$varname" ]; then
        awk -v op=extract -v opv1="$opv1" -f "$JSON_AWK_PATH" <<<"${!varname}"
    else
        awk -v op=extract -v opv1="$opv1" -f "$JSON_AWK_PATH"
    fi
}

: <<"DOCTEST"
> b=[1,2,3]
> json.del b.[0]
> echo $b
[2,3]
DOCTEST
json.del(){
    local keypath=${1:?Provide variable name} opv1 varname s

    varname=${keypath%%.*}
    opv1=".${keypath#*.}"
    [ "$varname" == "$keypath" ] && opv1="."
    shift 2
    
    if [ "$varname" ]; then
        s="$(awk -v op=del -v opv1="$opv1" -f "$JSON_AWK_PATH" <<<"${!varname}")"
    else
        s="$(awk -v op=del -v opv1="$opv1" -f "$JSON_AWK_PATH")"
    fi
    eval "$varname=\"\$s\""
}

: <<"DOCTEST"
> b=[1,2,3]
> json.shift b
> echo $b
[2,3]
DOCTEST
json.shift(){
    local keypath=${1:?Provide variable name} opv1 varname s

    varname=${keypath%%.*}
    opv1=".${keypath#*.}"
    [ "$varname" == "$keypath" ] && opv1="."
    shift 2
    
    if [ "$varname" ]; then
        s="$(awk -v dbg=1 -v op=shift -v opv1="$opv1" -f "$JSON_AWK_PATH" <<<"${!varname}")"
    else
        s="$(awk -v op=shift -v opv1="$opv1" -f "$JSON_AWK_PATH")"
    fi
    eval "$varname=\"\$s\""
}

: <<"DOCTEST"
> b=[1,2,3]
> json.pop b
> echo $b
[2,3]
DOCTEST
json.pop(){
    local keypath=${1:?Provide variable name} opv1 varname s

    varname=${keypath%%.*}
    opv1=".${keypath#*.}"
    [ "$varname" == "$keypath" ] && opv1="."
    shift 2
    
    if [ "$varname" ]; then
        s="$(awk -v op=pop -v opv1="$opv1" -f "$JSON_AWK_PATH" <<<"${!varname}")"
    else
        s="$(awk -v op=pop -v opv1="$opv1" -f "$JSON_AWK_PATH")"
    fi
    eval "$varname=\"\$s\""
}

json.array(){
    local s=
    while [ $# -gt 0 ]; do
        case "$1" in
            true|false|null)  s="$s,$1"   ;;
            # =\"*)             s="$2,${1:1}"   ;;
            *)  if [[ "$1" =~ ^[+-]?[0-9]+(.[0-9]+)*([eE][0-9]+(.[0-9]+))*$ ]];       
                then s="$s,$1" ;
                else s="$s,\"${1//\"/\\\"}\"" ;
                fi
                ;;
        esac
        shift
    done
    echo "[${s:1}]"
}

json.escape(){
    local a="${1:?Provide string}"
    a="$(echo "${a//$'\\'/\\}")"
    a="$(echo "${a//$'\n'/\\n}")"
    a="$(echo "${a//$'\t'/\\t}")"
    a="$(echo "${a//$'\b'/\\b}")"
    a="$(echo "${a//\"/\\\"}")"
    echo "\"$a\""
}

json.unescape(){
    eval echo "$@"
}

# Reference: https://github.com/jpmens/jo/blob/master/jo.md
json.dict(){
    printf "{\n"

    local key value
    local first=0
    for i in "$@"; do
        if [ "$first" -eq 0 ]; then
            first=1
        else
            printf ',\n'
        fi

        key=${i%%=*}
        if [ "$key" != "$i" ]; then
            value=${i#*=}

            case "$value" in
            true|false|null|\{*\}|\[*\])
                printf '  %s: %s' "$(json.escape "$key")" "$value" ;;
            *)
                if [[ "$value" =~ ^[+-]?[0-9]+(.[0-9]+)*([eE][0-9]+(.[0-9]+))*$ ]]; then
                    printf '  %s: %s' "$(json.escape "$key")" "$value"
                else
                    printf '  %s: %s' "$key" "$(json.escape "$value")"
                fi
            esac
            continue
        fi

        key=${i%%\:*}
        value=${i#*\:}
        printf '  %s: %s' "$(json.escape "$key")" "$(json.escape "$value")"
    done
    printf "\n}"
}

