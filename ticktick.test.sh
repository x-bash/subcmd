#! /usr/bin/env bash

source json

owner='{
    name: Edwin.Junhao.Lee,
    email: edwin.jh.lee@gmail.com,
    email1: 909xxxxxx@qq.com
}'
developer="{
    Owner: $owner,
    Contributors: [
        Tang Zhiwen,
        Li Tinghui
    ]
}"

function printContributors(){
    echo "------------------"
    echo "Contributors:"
    local IFS=$'\n'
    for employee in $(json.values developer.Contributors ); do
        echo "--- $employee"
    done
    echo "------------------"
}

echo Base assignments

json.put developer.Candidates '[ "YLJ", "Wang Li", "ZLX" ]'

json.values developer.Candidates

newContributor="Zhang Chi"
echo "Pushed a new , $newContributor onto the array"
json.push developer.Contributors "$newContributor"

json.color developer
printContributors

person0=$(json.query developer.Contributors.[0])
echo -e "First Contributor:\t $person0"

json.color developer

json.shift developer.Contributors
printContributors

json.pop developer.Contributors
printContributors
