#!/bin/bash
function usage () {
    echo "Usage: $0 [-u] [-n] [-b]"
    echo "  -u  Update local instalation"
    echo "  -n  Clean instalation"
    echo "  -b  Backup local instalation "
    exit 1
}

function backup_old_zshrc() {
    # Backup de .zshrc existente
    echo "Haciendo backup"
}

function main() {
    local opt_update
    local opt_new
    local opt_backup

    [[ "$#" -eq 0 || "$#" -gt 2 ]] && usage

    while getopts ":unb" opt; do
        case "${opt}" in
            u) opt_update=true 
                echo "opt_update";;
            n) opt_new=true
                echo "opt_new";;
            b) opt_backup=true
                backup_old_zshrc;;
            *) usage ;;
        esac
    done
}

main "$@"