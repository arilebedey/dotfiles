git-copy-diff-fzf() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Not inside a git repository."
    return 1
  fi

  local commit
  commit=$(git log --oneline -n 50 | fzf --preview 'git show --color=always {1}' --preview-window=right:70%)

  if [[ -z "$commit" ]]; then
    echo "No commit selected."
    return 1
  fi

  local commit_hash
  commit_hash=$(echo "$commit" | awk '{print $1}')

  if [[ "$OSTYPE" == "darwin"* ]]; then
    git show "$commit_hash" | pbcopy
    echo "Diff for commit $commit_hash copied to clipboard (macOS)."
  else
    if command -v xclip >/dev/null 2>&1; then
      git show "$commit_hash" | xclip -selection clipboard
      echo "Diff for commit $commit_hash copied to clipboard (Linux, xclip)."
    elif command -v xsel >/dev/null 2>&1; then
      git show "$commit_hash" | xsel --clipboard --input
      echo "Diff for commit $commit_hash copied to clipboard (Linux, xsel)."
    else
      echo "No clipboard tool found. Install xclip or xsel."
      return 1
    fi
  fi
}
