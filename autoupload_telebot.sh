#!/bin/bash

rcloneDrive='OD:/Download/'
downloadPath='/home/download'

TOKEN=
CHATID=

if [ $2 -eq 0 ]; then
  exit 0
elif [ $2 -eq 1 ]; then
  basenameStr=`basename "$3"`
  su - -c "rclone move \"$3\" $rcloneDrive"
  TEXT=$(echo $3 | sed 's|.*/||')
  curl -s -o /dev/null "https://api.telegram.org/bot$TOKEN/sendMessage?chat_id=$CHATID&text=$TEXT Uploaded"
  exit 0
else
  filePath=$3
  while true; do
    dirnameStr=`dirname "$filePath"`
    if [ "$dirnameStr" = "$downloadPath" ]; then
      basenameStr=`basename "$filePath"`
      su - -c "rclone move \"$filePath\" $rcloneDrive\"$basenameStr\""
      TEXT2=$(echo $3 | sed 's|.*/||')
      curl -s -o /dev/null "https://api.telegram.org/bot$TOKEN/sendMessage?chat_id=$CHATID&text=$TEXT2 Uploaded"
      rm -r -f "$filePath"
      exit 0
    elif [ "$dirnameStr" = "/" ]; then
      exit 0
    else
      filePath=$dirnameStr
    fi
  done
fi
