d() {
  local exclude_top exclude_nested exclude_pattern selected_dir
  local top_level_dirs nested_dirs original_dir
  original_dir="$PWD"
  top_level_dirs=(".local/share" ".nvm/versions/node" "Backups/OBSIDIAN" ".tmux/plugins")
  nested_dirs=("node_modules" ".git" "obsidian-notes")

  cd "$HOME" || { echo "Failed to change directory to home"; return 1; }

  for dir in "${top_level_dirs[@]}"; do
    exclude_top+=" -path './$dir' -o"
  done
  for dir in "${nested_dirs[@]}"; do
    exclude_nested+=" -path '*/$dir' -o"
  done

  exclude_pattern="${exclude_top} ${exclude_nested}"
  exclude_pattern=${exclude_pattern::-3}

  selected_dir=$(eval "find . -type d \( $exclude_pattern \) -prune -o -type d -print" | fzf)

  cd "$original_dir" || return
  [[ -z "$selected_dir" ]] && { echo "No directory selected."; return; }

  if [[ "$selected_dir" == "." ]]; then
    selected_dir="$HOME"
  else
    selected_dir="$HOME/${selected_dir#./}"
  fi

  if cd "$selected_dir"; then
    export SELECTED_DIR="$PWD"
  else
    echo "Failed to change directory to $selected_dir"
  fi
}
