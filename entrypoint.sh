#!/usr/bin/env bash

NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PURPLE='\033[0;34m'

npm i -g broken-link-checker -s

echo -e "$PURPLE=== BROKEN LINK CHECKER ===$NC"

# todo map variables to names
echo -e "Running broken link checker on url: $GREEN $1 $NC"

# IGNORE_PATTERNS=`jq '.ignorePatterns | .[] | .pattern' $CONFIG_FILE`
echo -e "with settings: $PURPLE skip no-follow links: $YELLOW$2, $PURPLE exclude urls that match: $YELLOW$3 $NC"

# Create exclude string based on config file
EXCLUDE=""

for PATTERN in $3; do
    EXCLUDE+="--exclude $PATTERN "
done

SET_FOLLOW=""
if [ $2 = false ] 
then
    SET_FOLLOW+="--follow"
fi

# Create command and remove extra quotes
COMMAND=`echo "blc $1 $EXCLUDE $SET_FOLLOW" | sed 's/"//g'`

# Put result in variable with $()
OUTPUT=`exec $COMMAND`

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

echo -e "$PURPLE ============================== $NC"