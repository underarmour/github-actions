#!/bin/bash
set -eu

echo "Processing Slack message"

if [[ -z "$SLACK_BOT_USER_TOKEN" ]]; then
  echo "Set the SLACK_BOT_USER_TOKEN secret."
  exit 1
fi

message="{\"channel\":\"$slack_channel\",\"attachments\":[{\"pretext\":\"$slack_pretext\",\"title\":\"$slack_title\",\"text\":\"$slack_text\"}]}"
message="${message//GITHUB_REF/$GITHUB_REF}"
message="${message//GITHUB_REPOSITORY/$GITHUB_REPOSITORY}"
message="${message//GITHUB_ACTOR/$GITHUB_ACTOR}"
message="${message//<br>/\\n}"

if [[ $message == *"ARTIFACT_NAME"* ]]; then
  currentLib=`ls -Art ./build/libs/ | tail -n 1`
  currentLib="${currentLib//.jar/}"
  echo "ArtifactName is $currentLib"

  message="${message//ARTIFACT_NAME/$currentLib}"
fi

echo "Message to Slack: $message"

curl -X POST \
     -H "Content-type: application/json" \
     -H "Authorization: Bearer $SLACK_BOT_USER_TOKEN" \
     -d "$message" \
     https://slack.com/api/chat.postMessage