. "${FLY_HOME:-$HOME}/.fly.d/plugins/flug/flug"

# ── zsh completion ────────────────────────────────────────────────

_flug_completion()
{
    local shell="" subcmd=""
    local -i i

    # Walk typed words: position 1 may be an optional shell name
    for (( i=2; i<CURRENT; i++ )); do
        case "${words[i]}" in
            bash|zsh|ksh)
                [[ -z "$shell" && -z "$subcmd" ]] && shell="${words[i]}" ;;
            lxc|juju|multipass|ssh|help)
                subcmd="${words[i]}" ;;
        esac
    done

    if [[ -z "$shell" && -z "$subcmd" ]]; then
        local -a subcmds=(bash zsh ksh help)
        command -v lxc       &>/dev/null && subcmds+=(lxc)
        command -v juju      &>/dev/null && subcmds+=(juju)
        command -v multipass &>/dev/null && subcmds+=(multipass)
        command -v ssh       &>/dev/null && subcmds+=(ssh)
        compadd -- $subcmds
        return
    fi

    if [[ -n "$shell" && -z "$subcmd" ]]; then
        local -a subcmds=(help)
        command -v lxc       &>/dev/null && subcmds+=(lxc)
        command -v juju      &>/dev/null && subcmds+=(juju)
        command -v multipass &>/dev/null && subcmds+=(multipass)
        command -v ssh       &>/dev/null && subcmds+=(ssh)
        compadd -- $subcmds
        return
    fi

    case "$subcmd" in
        lxc)       compadd -- ${(f)"$(_flug_lxc_targets)"} ;;
        juju)      compadd -- ${(f)"$(_flug_juju_targets)"} ;;
        multipass) compadd -- ${(f)"$(_flug_multipass_targets)"} ;;
        ssh)       compadd -- ${(f)"$(_flug_ssh_targets)"} ;;
    esac
}

compdef _flug_completion flug
