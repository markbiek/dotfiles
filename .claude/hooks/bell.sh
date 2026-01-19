#!/bin/bash
set -euo pipefail

# Read JSON from stdin
INPUT=$(cat)
MESSAGE=$(echo "$INPUT" | jq -r '.message // "needs attention"')

# Play alert sound based on platform (works without TTY access)
case "$(uname -s)" in
	Darwin)
		# macOS: use osascript to beep
		osascript -e 'beep' &
		;;
	Linux)
		# Linux: try paplay, notify-send, or write bell to all user's PTY devices
		if command -v paplay >/dev/null 2>&1; then
			paplay /usr/share/sounds/freedesktop/stereo/bell.oga 2>/dev/null &
		elif command -v notify-send >/dev/null 2>&1; then
			notify-send "Claude Code" "$MESSAGE" &
		else
			# Write bell to all PTY devices owned by current user (for SSH sessions)
			for pty in /dev/pts/*; do
				if [ -w "$pty" ] 2>/dev/null; then
					printf '\a' > "$pty" 2>/dev/null || true
				fi
			done
		fi
		;;
esac

exit 0
