# dev profile: 2 windows for development work
# Window 1: editor (large top pane + 3 utility panes at bottom)
# Window 2: claude (two 50/50 vertical panes)

setup_layout() {
  local session="$1"
  local directory="$2"

  # Window 1: editor (single pane)
  tmux new-session -d -s "$session" -n "editor" -c "$directory"

  # Window 2: claude + utilities
  tmux new-window -t "$session" -n "claude" -c "$directory"

  # Split into left and right columns (50/50)
  tmux split-window -h -p 50 -c "$directory"

  # Split left column: claude top, utility bottom
  tmux select-pane -t 0
  tmux split-window -v -l 3 -c "$directory"

  # Split right column: claude top, utility bottom
  tmux select-pane -t 2
  tmux split-window -v -l 3 -c "$directory"

  # Return to window 1
  tmux select-window -t "$session:editor"
  tmux select-pane -t 0
}

# Pane indices (used by project scripts)
# Window 1: pane 0 = editor
# Window 2: pane 0 = left claude, pane 1 = left utility, pane 2 = right claude, pane 3 = right utility
CLAUDE_PANE_LEFT=0
UTILITY_PANE_LEFT=1
CLAUDE_PANE_RIGHT=2
UTILITY_PANE_RIGHT=3
