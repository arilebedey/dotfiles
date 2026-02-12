git-copy-latest-diff() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Not inside a git repository."
    return 1
  fi

  local diff
  diff=$(git diff HEAD~1 HEAD | awk '
    /^diff --git.*package-lock\.json/ { skip=1; next }
    /^diff --git/ { skip=0 }
    !skip { print }
  ')

  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "$diff" | pbcopy
    echo "Latest commit diff copied to clipboard (macOS)."
  else
    if command -v xclip >/dev/null 2>&1; then
      echo "$diff" | xclip -selection clipboard
      echo "Latest commit diff copied to clipboard (Linux, xclip)."
    elif command -v xsel >/dev/null 2>&1; then
      echo "$diff" | xsel --clipboard --input
      echo "Latest commit diff copied to clipboard (Linux, xsel)."
    else
      echo "No clipboard tool found. Install xclip or xsel."
      return 1
    fi
  fi
}
