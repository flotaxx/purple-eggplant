#!/usr/bin/env bash

set -e
set -o pipefail
set -v

initialGitHash=$(git rev-list --max-parents=0 HEAD)
node ./studio-build.js $initialGitHash &

curl -s -X POST https://api.stackbit.com/project/5dc7378f8619fa001b8d927f/webhook/build/pull > /dev/null
npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5dc7378f8619fa001b8d927f
curl -s -X POST https://api.stackbit.com/project/5dc7378f8619fa001b8d927f/webhook/build/ssgbuild > /dev/null
jekyll build
wait

curl -s -X POST https://api.stackbit.com/project/5dc7378f8619fa001b8d927f/webhook/build/publish > /dev/null
echo "Stackbit-build.sh finished build"
