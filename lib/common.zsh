read-alias-file() {
    alias $1:t="$(< $1)"
}
