#!/bin/bash
set -euo pipefail

# Read JSON from stdin
INPUT=$(cat)
MESSAGE=$(echo "$INPUT" | jq -r '.message // "needs attention"')

# Ring the terminal bell
printf '\a'

exit 0
