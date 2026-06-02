. "${BASH_SOURCE%/*}/flug"

# ── Suggest plugins not yet installed ────────────────────────────
_flug_available_plugins()
{
    local plugin
    for plugin in futil nerdp; do
        [ -d "${FLY_HOME:-$HOME}/.fly.d/plugins/$plugin" ] || echo "$plugin"
    done
}

_flug_completion()
{
    local cur shell="" subcmd=""

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    # Walk typed words: position 1 may be an optional shell name
    local i word
    for (( i=1; i<COMP_CWORD; i++ )); do
        word="${COMP_WORDS[i]}"
        case "$word" in
            bash|zsh|ksh)
                [[ -z "$shell" && -z "$subcmd" ]] && shell="$word" ;;
            lxc|juju|multipass|ssh|help)
                subcmd="$word" ;;
        esac
    done

    if [[ -z "$shell" && -z "$subcmd" ]]; then
        COMPREPLY=($(compgen -W "bash zsh ksh $(_flug_active_subcmds) help" -- "$cur"))
        return
    fi

    if [[ -n "$shell" && -z "$subcmd" ]]; then
        COMPREPLY=($(compgen -W "$(_flug_active_subcmds) help" -- "$cur"))
        return
    fi

    case "$subcmd" in
        lxc)       COMPREPLY=($(compgen -W "$(_flug_lxc_targets | tr '\n' ' ')" -- "$cur")) ;;
        juju)      COMPREPLY=($(compgen -W "$(_flug_juju_targets | tr '\n' ' ')" -- "$cur")) ;;
        multipass) COMPREPLY=($(compgen -W "$(_flug_multipass_targets | tr '\n' ' ')" -- "$cur")) ;;
        ssh)       COMPREPLY=($(compgen -W "$(_flug_ssh_targets | tr '\n' ' ')" -- "$cur")) ;;
    esac
}

complete -F _flug_completion flug
