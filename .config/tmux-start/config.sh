# tmux-start configuration
# Maps directory patterns to "profile:project" (project is optional)

declare -A DIR_MAPPINGS=(
  ["$HOME/dev/a8c/sandbox/wpcom"]="dev:wpcom"
  ["$HOME/dev/personal/media.biek.dev"]="dev:media"
  ["$HOME/dev/a8c/sandbox/missioncontrol/public_html"]="dev:missioncontrol"
  ["$HOME/dev/a8c/calypso"]="dev:calypso"
  ["$HOME/notes"]="simple"
)

DEFAULT_PROFILE="simple"
