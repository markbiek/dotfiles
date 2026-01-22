# wpcom project: commands for utility panes

run_project_commands() {
  local session="$1"

  # Left utility pane: sandbox sync
  tmux send-keys -t "$session:claude.$UTILITY_PANE_LEFT" 'automattic-sandbox-sync' C-m

  # Right utility pane: ssh to sandbox
  tmux send-keys -t "$session:claude.$UTILITY_PANE_RIGHT" 'ssh wpcom-sandbox' C-m
}
