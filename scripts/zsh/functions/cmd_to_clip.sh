# Copy whole command
cmd_to_clip() {
  local text="$BUFFER"

  if [[ -z "$text" ]]; then
    echo "No command to copy" >&2
    return 1
  fi

  case "$OSTYPE" in
    darwin*)  # macOS
      print -rn -- "$text" | pbcopy
      ;;
    linux*)
      if command -v wl-copy >/dev/null 2>&1; then
        print -rn -- "$text" | wl-copy -n
      elif command -v xclip >/dev/null 2>&1; then
        print -rn -- "$text" | xclip -selection clipboard
      elif command -v xsel >/dev/null 2>&1; then
        print -rn -- "$text" | xsel --clipboard --input
      else
        echo "No clipboard tool found (install wl-clipboard, xclip, or xsel)" >&2
        return 1
      fi
      ;;
    cygwin*|msys*|win32*)  # Windows / Git Bash / MSYS2
      if command -v clip.exe >/dev/null 2>&1; then
        print -rn -- "$text" | clip.exe
      else
        echo "No clipboard tool found (clip.exe missing)" >&2
        return 1
      fi
      ;;
    *)
      echo "Unsupported OS: $OSTYPE" >&2
      return 1
      ;;
  esac
}

# Register as ZLE widget and bind to Ctrl+Y
zle -N cmd_to_clip
bindkey '^Y' cmd_to_clip
