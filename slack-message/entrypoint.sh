#!/bin/bash
set -eu

if [[ -z "$SLACK_BOT_USER_TOKEN" ]]; then
  echo "Set the SLACK_BOT_USER_TOKEN secret."
  exit 1
fi

currentLib=`ls -Art ./build/libs/ | tail -n 1`
currentLib="${currentLib//.jar/}"

message="{\"channel\":\"$slack_channel\",\"attachments\":[{\"pretext\":\"$pretext\",\"title\":\"$title\",\"text\":\"$text\"}]}"
message="${message//ARTIFACT_NAME/$currentLib}"
message="${message//GITHUB_REF/$GITHUB_REF}"
message="${message//GITHUB_REPOSITORY/$GITHUB_REPOSITORY}"
message="${message//GITHUB_ACTOR/$GITHUB_ACTOR}"
message="${message//<br>/\\n}"

echo "$message"

curl -X POST \
     -H "Content-type: application/json" \
     -H "Authorization: Bearer $SLACK_BOT_USER_TOKEN" \
     -d "$message" \
     https://slack.com/api/chat.postMessage