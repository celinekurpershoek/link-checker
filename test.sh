#!/bin/bash
# Fail when any task exits with a non zero error;
set -e

#npm run linkcheck https://developers.onna.com
blc https://developers.onna.com
