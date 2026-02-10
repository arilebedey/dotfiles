git-copy-commit-messages() {
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

  # Include the selected commit and all commits up to HEAD
  local messages
  messages=$(git log --pretty=format:"%h%d%n%w(0,0,4)%s%n%n%w(0,0,4)%b%n---%n" "$commit_hash^..HEAD" | sed '$ s/---$//')

  if [[ -z "$messages" ]]; then
    echo "No commit messages found between $commit_hash and HEAD."
    return 1
  fi

  # Copy to clipboard
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "$messages" | pbcopy
    echo "Commit messages from $commit_hash to HEAD copied to clipboard (macOS)."
  else
    if command -v xclip >/dev/null 2>&1; then
      echo "$messages" | xclip -selection clipboard
      echo "Commit messages from $commit_hash to HEAD copied to clipboard (Linux, xclip)."
    elif command -v xsel >/dev/null 2>&1; then
      echo "$messages" | xsel --clipboard --input
      echo "Commit messages from $commit_hash to HEAD copied to clipboard (Linux, xsel)."
    else
      echo "No clipboard tool found. Install xclip or xsel."
      return 1
    fi
  fi
}

