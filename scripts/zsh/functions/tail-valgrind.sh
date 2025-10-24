v() {
  valgrind --leak-check=full --show-leak-kinds=all "$@" 2>&1 | tail -n +6
}
