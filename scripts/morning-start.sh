#!/bin/bash
# Morning routine — runs /wrap-up for yesterday then /start for today.
# Output is written to daily-notes/ by each command.
#
# SETUP: Update the paths below to match your environment.

CLAUDE_CLI="claude"   # or full path to your Claude CLI binary
PROJECT="/path/to/your/second-brain"   # update this to your vault path

# Load nvm if needed (launchd doesn't source shell profiles)
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"

# Give the desktop a moment to settle after login
sleep 30

# Wrap up yesterday first
YESTERDAY=$(date -v-1d +%Y-%m-%d)
"$CLAUDE_CLI" run --dir "$PROJECT" --command wrap-up "$YESTERDAY"

# Then start today
"$CLAUDE_CLI" run --dir "$PROJECT" --command start
