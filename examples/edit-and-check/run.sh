#!/bin/sh
# Runs the commands from README.md with the podlite version the output there came from.
cd "$(dirname "$0")"
npx -y podlite@0.0.91 lint notes.podlite
echo "exit code: $?"
npx -y podlite@0.0.91 lint notes-fixed.podlite
echo "exit code: $?"
npx -y podlite@0.0.91 query 'code[:lang<python>]' notes-fixed.podlite
npx -y podlite@0.0.91 query 'code[:lang<python>]' notes-fixed.podlite --to json
