# calypso project: commands for utility panes

run_project_commands() {
  local session="$1"

  # Left utility pane: start dev server with increased memory
  tmux send-keys -t "$session:claude.$UTILITY_PANE_LEFT" 'export NODE_OPTIONS="--max-old-space-size=8192" && yarn && yarn start' C-m

  # Right utility pane: empty shell (no command)
}
