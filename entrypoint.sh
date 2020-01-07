#!/usr/bin/env bash

NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'

npm i -g broken-link-checker

# TODO:
# cant use the variables on the pattern
# make it overwritable
# fail when a link is broken and not ignored

# Get ignore patterns from config file: 

echo -e "${YELLOW}=========================> BROKEN LINK CHECKER <=========================${NC}"
echo "Running broken link checker on url: $1"

if [ -f "$ENV_CONFIG" ]; then
    IGNORE_PATTERNS=`jq '.ignorePatterns | .[] | .pattern' $ENV_CONFIG`
    echo -e "with config file: ${GREEN}$ENV_CONFIG${NC}"

    # Create exclude string based on config file
    EXCLUDE=""
    
    for PATTERN in $IGNORE_PATTERNS; do
        EXCLUDE+="--exclude $PATTERN "
    done

    # Create command and remove extra quotes
    COMMAND=`echo "blc $1 $EXCLUDE" | sed 's/"//g'`

    # Put result in variable with $()
    OUTPUT=$(exec $COMMAND)

else
    echo "Without a config file."
    OUTPUT=$(exec blc $1)
fi

# Count broken and total links
BROKEN_COUNT=$(grep -o 'BROKEN' <<< $OUTPUT | grep 'BROKEN' -c)
TOTAL_COUNT=$(grep -o '├' <<< $OUTPUT | grep '├' -c)

if [ $BROKEN_COUNT -gt 0 ]
then 
    RESULT="$BROKEN_COUNT broken url(s) found ($TOTAL_COUNT total)" 
    echo -e "${RED} ${RESULT}: ${NC}"
    #todo put each result on new line:
    echo $(grep -E 'BROKEN' <<< $OUTPUT | awk '{print "- " $2 "\n" }')
else 
    RESULT="Checked $TOTAL_COUNT link(s), no broken links found!"
    echo -e "${GREEN} ${RESULT} ${NC}"
fi

echo ::set-output name=result::$RESULT

echo -e "${YELLOW}=========================================================================${NC}"