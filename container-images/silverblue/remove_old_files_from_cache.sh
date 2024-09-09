#!/bin/env bash


DIRECTORY=$1
MAX_FILES=3

FILES=$(ls -1 "$DIRECTORY")

FILE_COUNT=$(echo "$FILES" | wc -l)

if [ "$FILE_COUNT" -gt "$MAX_FILES" ]; then
  FILES_TO_DELETE=$((FILE_COUNT - MAX_FILES))
  
  FILES_TO_DELETE_LIST=$(echo "$FILES" | head -n "$FILES_TO_DELETE")
  
  for FILE in $FILES_TO_DELETE_LIST; do
    sudo rm "$DIRECTORY/$FILE"
  done
fi
