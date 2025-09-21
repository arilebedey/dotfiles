tx() {
    if [ -z "$1" ]; then
        echo "Usage: touchx <filename>"
        return 1
    fi
    touch "$1" && chmod +x "$1"
    echo "Created and made executable: $1"
}
