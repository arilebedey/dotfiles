notify() {
  cmd="$*"
  short_cmd="${cmd:0:120}"
  [[ ${#cmd} -gt 120 ]] && short_cmd="${short_cmd}..."

  bash -c "$cmd"
  osascript -e "display notification \"Command completed.\" with title \"$short_cmd\" sound name \"Glass\""
}
