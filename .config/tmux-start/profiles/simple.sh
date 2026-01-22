# simple profile: single window, single pane

setup_layout() {
  local session="$1"
  local directory="$2"

  tmux new-session -d -s "$session" -n "main" -c "$directory"
}
