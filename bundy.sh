#!/bin/bash

set -eu

WORK_DIR="$HOME/bundy"
OUTPUT_FILE="$WORK_DIR/bundy.csv"

if [[ ! -d $WORK_DIR ]]; then
    echo "Creating workdir: $WORK_DIR"
    mkdir $WORK_DIR
fi

if [[ ! -f $OUTPUT_FILE ]]; then
    echo "Creating record file: $OUTPUT_FILE"
    echo "date,start,end" > $OUTPUT_FILE
fi

BUNDY_DATE="$(date +%d-%m-%Y)"
BUNDY_TIME="$(date +%H:%M)"

set +e
ACTIVE_SESSION=$(cat $OUTPUT_FILE | grep --extended-regexp ^${BUNDY_DATE},[0-9]+:[0-9]+,$)
set -e

# If there isn't an active session, start one
if [[ "$ACTIVE_SESSION" == "" ]]; then
    echo "Starting Session $BUNDY_DATE - $BUNDY_TIME"
    echo "$BUNDY_DATE,$BUNDY_TIME," >> $OUTPUT_FILE
else #complete session
    echo "Completing Session $BUNDY_TIME"
    sed -i '' "s/^$ACTIVE_SESSION$/${ACTIVE_SESSION}${BUNDY_TIME}/g" $OUTPUT_FILE
fi
