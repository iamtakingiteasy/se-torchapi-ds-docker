#!/bin/sh
git config --global user.email "buildbot@eientei.org"
git config --global user.name "Buildbot"
curl -sf https://build.torchapi.net/job/Torch/job/Torch/job/master/api/json | 
  jq -r '.builds | .[].url' | 
  while read url; do 
    set -- $(curl -sf ${url}/api/json | jq -r '(.description | sub("-master"; "")) + " " + (.url + "/artifact/bin/torch-server.zip" | gsub("(?<x>[^:])/+"; "\(.x)/"))')
    git tag -l $1 | grep -q . && break
    echo $1 $2
    sleep 1
  done | tac | while read tag url; do
    sed "s|ADD [^ ]*|ADD ${url}|" -i Dockerfile
    git commit -a -m $tag
    git push origin master
    git tag $tag
    git push origin $tag
  done
