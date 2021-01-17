#! /usr/bin/env bash

source json.sh

owner='{
    name: Edwin.Junhao.Lee,
    email: edwin.jh.lee@gmail.com,
    email1: 909xxxxxx@qq.com
}'
developer="{
    Owner: $owner,
    Contributors: [
        Li Junhao,
        Li Tinghui,
        Tang Zhiwen
    ]
}"

function printContributors(){
    # local IFS=$'\n'
    for employee in "$(json.values developer.Contributors )"; do
        echo "$employee"
    done
}

echo Base assignments

json.put developer.Candidates '[ "YLJ", "Wang Li", "ZLX" ]'

echo "$(json.values developer.Candidates)"

newContributor="Zhang Chi"
echo "Pushed a new , $newContributor onto the array"
json.push developer.Contributors "$newContributor"

json.color developer
printContributors

person0=$(json.query developer.Contributors.[0])
echo "$person0"

json.shift developer.Contributors
printContributors
