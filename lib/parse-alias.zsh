#!/bin/zsh

# Parse alias definitions with the format `{command} --flag | {command}`
# where commands between {} must exist on the system for the alias to be
# created.
# Does not parse {commands} correctly unless surrounded by whitespace,
# e.g. cmd $({cmd} --flag) will not work.

parse-alias() {
    while getopts ':d' opt; do
        case "$opt" in
            d) list_deps=true ;;
        esac
    done
    shift $((OPTIND - 1))

    [[ $# -eq 0 ]] && return 2

    out=()

    for i in "$@"; do
        if dep="$(expr "$i" : '{\(.*\)}')"; then
            out+=("$dep")
        elif ! ${list_deps-false}; then
            out+=("$i")
        fi
    done

    [[ -z "${out[*]}" ]] && return 1

    echo $out
}
