#!/bin/sh
curl -sf https://torchapi.net/download/Torch | grep -v btn | sed -n '/.*a href="\([^"]*\)">\(v[0-9.]\+\).*/{s//\2 \1/p}' | awk \
  'BEGIN{
     delete tags[0];
     delete urls[0];
  }
  {
    if (system("git tag -l " $1 " | grep -q .") != 0) {
      tags[length(tags)] = $1;
      urls[length(urls)] = $2;
    } else {
      for (i = length(tags)-1; i >= 0; i--) {
        system("sed \"s|ADD [^ ]*|ADD " urls[i] "|\" -i Dockerfile; git commit -a -m " tags[0] "; git tag " tags[0] "; git push origin " tags[0]);
      }
      system("git push origin master");
      exit;
    }
  }'
