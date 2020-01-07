#!/usr/bin/env bash

NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'

npm i -g broken-link-checker -s

CONFIG_FILE=blc-config.json

echo -e "$YELLOW=========================> BROKEN LINK CHECKER <=========================$NC"
echo -e "Running broken link checker on url: $GREEN $1 $NC"

if [ -f "$CONFIG_FILE" ]; then
    IGNORE_PATTERNS=`jq '.ignorePatterns | .[] | .pattern' $CONFIG_FILE`
    FOLLOW=`jq '.follow' $CONFIG_FILE`
    echo -e "with config file: $GREEN $CONFIG_FILE$NC"

    # Create exclude string based on config file
    EXCLUDE=""
    
    for PATTERN in $IGNORE_PATTERNS; do
        EXCLUDE+="--exclude $PATTERN "
    done

    SET_FOLLOW=""
    if [ $FOLLOW ] 
    then
        SET_FOLLOW+="--follow"
    fi

    # Create command and remove extra quotes
    COMMAND=`echo "blc $1 $EXCLUDE $SET_FOLLOW" | sed 's/"//g'`

    # Put result in variable with $()
    OUTPUT=`exec $COMMAND`

else
    echo "Can't find $CONFIG_FILE"
    OUTPUT=`exec blc $1`
fi

# Count broken and total links
BROKEN_COUNT=`grep -o 'BROKEN' <<< $OUTPUT | grep 'BROKEN' -c`
TOTAL_COUNT=`grep -o '├' <<< $OUTPUT | grep '├' -c`

if [ $BROKEN_COUNT -gt 0 ]
then 
    RESULT="$BROKEN_COUNT broken url(s) found ($TOTAL_COUNT total)" 
    echo -e "$RED ✗ Failed $RESULT: $NC"
    #todo put each result on new line:
    echo `grep -E 'BROKEN' <<< $OUTPUT | awk '{print "- " $2 "\n" }'`
    exit 1
else 
    RESULT="✓ Checked $TOTAL_COUNT link(s), no broken links found!"
    echo -e "$GREEN $RESULT $NC"
fi

echo ::set-output name=result::$RESULT

echo -e "$YELLOW=========================================================================$NC"