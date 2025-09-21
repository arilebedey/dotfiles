git-copy-latest-diff() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Not inside a git repository."
    return 1
  fi

  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    git diff HEAD~1 HEAD | pbcopy
    echo "Latest commit diff copied to clipboard (macOS)."
  else
    # Linux (requires xclip or xsel)
    if command -v xclip >/dev/null 2>&1; then
      git diff HEAD~1 HEAD | xclip -selection clipboard
      echo "Latest commit diff copied to clipboard (Linux, xclip)."
    elif command -v xsel >/dev/null 2>&1; then
      git diff HEAD~1 HEAD | xsel --clipboard --input
      echo "Latest commit diff copied to clipboard (Linux, xsel)."
    else
      echo "No clipboard tool found. Install xclip or xsel."
      return 1
    fi
  fi
}
