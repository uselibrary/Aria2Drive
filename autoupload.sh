#!/bin/bash

rcloneDrive='OD:/download/'
downloadPath='/home/download'

if [ $2 -eq 0 ]; then
  exit 0
elif [ $2 -eq 1 ]; then
  basenameStr=`basename "$3"`
  su - -c "rclone move \"$3\" $rcloneDrive"
  exit 0
else
  filePath=$3
  while true; do
    dirnameStr=`dirname "$filePath"`
    if [ "$dirnameStr" = "$downloadPath" ]; then
      basenameStr=`basename "$filePath"`
      su - -c "rclone move \"$filePath\" $rcloneDrive\"$basenameStr\""
      rm -r -f "$filePath"
      exit 0
    elif [ "$dirnameStr" = "/" ]; then
      exit 0
    else
      filePath=$dirnameStr
    fi
  done
fi
