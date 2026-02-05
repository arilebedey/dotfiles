git-copy-file-diff() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Not inside a git repository."
    return 1
  fi

  local file
  file=$(git diff HEAD~1 HEAD --name-only | fzf --preview "git diff HEAD~1 HEAD -- {}")
  
  if [[ -z "$file" ]]; then
    echo "No file selected."
    return 1
  fi

  if [[ "$OSTYPE" == "darwin"* ]]; then
    git diff HEAD~1 HEAD -- "$file" | pbcopy
    echo "Diff for '$file' copied to clipboard (macOS)."
  else
    if command -v xclip >/dev/null 2>&1; then
      git diff HEAD~1 HEAD -- "$file" | xclip -selection clipboard
      echo "Diff for '$file' copied to clipboard (Linux, xclip)."
    elif command -v xsel >/dev/null 2>&1; then
      git diff HEAD~1 HEAD -- "$file" | xsel --clipboard --input
      echo "Diff for '$file' copied to clipboard (Linux, xsel)."
    else
      echo "No clipboard tool found. Install xclip or xsel."
      return 1
    fi
  fi
}
