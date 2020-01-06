#!/usr/bin/env bash

NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'

npm i -g broken-link-checker

# TODO:
# Pass ignorable urls
# Make it itegrateable? (throw warning?)

echo -e "${YELLOW}=========================> BROKEN LINK CHECKER <=========================${NC}"
echo "Running broken link checker on url: $1"

# Use tee to also log output:
# OUTPUT=$(exec blc $1 | tee /dev/stderr)
OUTPUT="$(exec blc $1)"

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

echo -e "${YELLOW}=========================================================================${NC}"