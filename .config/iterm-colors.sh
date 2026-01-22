# Directory to color mappings for iTerm2 tab/window colors
# Uses iTerm2 proprietary escape sequences to set tab color

function set_iterm_color_by_dir() {
  # Only run in iTerm2
  [[ "$TERM_PROGRAM" != "iTerm.app" ]] && return

  local hex
  case "$PWD" in
    /Users/mark/dev/a8c/calypso*|*/calypso)
      hex="5599dd"  # light blue
      ;;
    /Users/mark/dev/a8c/jetpack*|*/jetpack)
      hex="44aa44"  # green
      ;;
    /home/wpcom/public_html*|/Users/mark/dev/a8c/sandbox/wpcom/public_html*)
      hex="224488"  # dark blue
      ;;
    /home/missioncontrol/public_html*|/Users/mark/dev/a8c/sandbox/missioncontrol/public_html*)
      hex="cc4444"  # red
      ;;
    /Users/mark/.hammerspoon*)
      hex="f5da27"  # yellow
      ;;
    *)
      # Reset to default (no custom tab color)
      printf "\033]6;1;bg;*;default\a"
      return
      ;;
  esac

  # Extract RGB components
  local r=$((16#${hex:0:2}))
  local g=$((16#${hex:2:2}))
  local b=$((16#${hex:4:2}))

  # Set iTerm2 tab color using proprietary escape sequence
  printf "\033]6;1;bg;red;brightness;%d\a" "$r"
  printf "\033]6;1;bg;green;brightness;%d\a" "$g"
  printf "\033]6;1;bg;blue;brightness;%d\a" "$b"
}
