#!/bin/bash
# Fail when any task exits with a non zero error;
set -e

NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PURPLE='\033[0;34m'

# Install the broken-link-checker module globally on the docker instance
npm i -g broken-link-checker -s

echo -e "$PURPLE=== BROKEN LINK CHECKER ===$NC"

# @todo map variables to names
echo -e "Running broken link checker on url: $GREEN $1 $NC"

# Create exclude and settings strings based on configuration
EXCLUDE="" 
SET_FOLLOW=""

if [ -z "$1" ] || [ "$1" == 'https://github.com/celinekurpershoek/github-actions-link-checker' ]
then
    echo -e "$YELLOW Warning: Running test on default url, please provide an url in you action yml.$NC"
fi

# Set arguments for blc
[ "$2" == false ] && SET_FOLLOW="--follow"

for PATTERN in ${3//,/ }; do
    EXCLUDE+="--exclude $PATTERN "
done

# Echo settings if any are set
echo -e "Configuration: Honor robot exclusions: $GREEN$2$NC, Exclude urls that match: $GREEN$3$NC \n"

# Create command and remove extra quotes
# COMMAND="$(echo "blc $1 $EXCLUDE $SET_FOLLOW" | sed 's/"//g')"
# Put result in variable to be able to iterate on it later
OUTPUT="$(blc "$1" "$EXCLUDE" "$SET_FOLLOW" | sed 's/"//g')"

# Count broken and total links
BROKEN_COUNT=$(grep -o 'BROKEN' <<< "$OUTPUT" | grep 'BROKEN' -c)
TOTAL_COUNT=$(grep -o '├' <<< "$OUTPUT" | grep '├' -c)

if [ "$BROKEN_COUNT" -gt 0 ] 
then 
    RESULT="$BROKEN_COUNT broken url(s) found ($TOTAL_COUNT total)" 
    echo -e "$RED Failed $RESULT: $NC"
    # @todo put each result on new line:
    grep -E 'BROKEN' <<< "$OUTPUT" | awk '{print "[✗] " $2 "\n" }'
    echo -e "$PURPLE ============================== $NC"
    echo ::set-output name=result::"$RESULT"
    exit 1
elif [ "$TOTAL_COUNT" == 0 ]
then
    echo -e "Did'nt find any links to check"
else 
    RESULT="✓ Checked $TOTAL_COUNT link(s), no broken links found!"
    echo -e "$GREEN $RESULT $NC"
    echo ::set-output name=result::"$RESULT"
    echo -e "$PURPLE ============================== $NC"
fi
exit 0