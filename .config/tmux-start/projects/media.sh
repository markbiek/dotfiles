# wpcom project: commands for utility panes

run_project_commands() {
  local session="$1"

  # Left utility pane: media sync
  tmux send-keys -t "$session:claude.$UTILITY_PANE_LEFT" 'media-biek-sync' C-m

  # Right utility pane: ssh to jt
  tmux send-keys -t "$session:claude.$UTILITY_PANE_RIGHT" 'ssh jt' C-m
}
