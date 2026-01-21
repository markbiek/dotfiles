# Directory to color mappings - edit this list in one place
function set_tmux_color_by_dir() {
  [[ -z "$TMUX" ]] && return

  local color
  case "$PWD" in
    /Users/mark/dev/a8c/calypso*|*/calypso)
      color="#5599dd"  # light blue
      ;;
    /Users/mark/dev/a8c/jetpack*|*/jetpack)
      color="#44aa44"  # green
      ;;
    /home/wpcom/public_html*|/Users/mark/dev/a8c/sandbox/wpcom/public_html*)
      color="#224488"  # dark blue
      ;;
    /home/missioncontrol/public_html*|/Users/mark/dev/a8c/sandbox/missioncontrol/public_html*)
      color="#cc4444"  # red
      ;;
    *)
      color="#444444"  # default gray
      ;;
  esac

  tmux set -g status-style "bg=$color,fg=#ffffff"
}
