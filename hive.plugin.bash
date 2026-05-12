. "${BASH_SOURCE%/*}/hive"

# Target list functions — hive owns all transports, query binaries directly.
_hive_lxc_targets()       { lxc list --format csv 2>/dev/null | awk -F, '$1 != "" { print $1 }'; }
_hive_juju_targets()      { juju status 2>/dev/null | awk '/^[a-z][a-z0-9-]*\/[0-9]/{gsub(/\*/, "", $1); print $1}'; }
_hive_multipass_targets() { multipass list --format csv 2>/dev/null | awk -F, 'NR > 1 && $1 != "" { print $1 }'; }

_hive_ssh_targets()
{
    grep -i '^Host ' ~/.ssh/config 2>/dev/null \
        | awk '{for(i=2;i<=NF;i++) if($i !~ /[*?]/) print $i}'
}

# Only suggest subcommands whose backing binary AND plugin are both present.
_hive_active_subcmds()
{
    local cmds=""
    [ "$_flexed_loaded"   ] && command -v lxc       >/dev/null 2>&1 && cmds="$cmds lxc"
    [ "$_fujy_loaded"     ] && command -v juju      >/dev/null 2>&1 && cmds="$cmds juju"
    [ "$_swarmpass_loaded" ] && command -v multipass >/dev/null 2>&1 && cmds="$cmds multipass"
    command -v ssh >/dev/null 2>&1 && cmds="$cmds ssh"
    echo "$cmds"
}

# Suggest plugins that are known but not yet installed.
_hive_available_plugins()
{
    local plugin
    for plugin in hive-core flexed fujy futil nerdp swarmpass; do
        [ -d "${FLY_HOME:-$HOME}/.fly.d/plugins/$plugin" ] || echo "$plugin"
    done
}

_hive_completion()
{
    local cur subcmd prev

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # After -s / --shell, complete shell names
    if [[ "$prev" == "-s" || "$prev" == "--shell" ]]; then
        COMPREPLY=($(compgen -W "bash zsh ksh" -- "$cur"))
        return
    fi
    if [[ "$cur" == --shell=* ]]; then
        COMPREPLY=($(compgen -W "--shell=bash --shell=zsh --shell=ksh" -- "$cur"))
        return
    fi

    # Find the real subcommand (skip -s/--shell flags and their values)
    local i word skip=0
    subcmd=""
    for (( i=1; i<COMP_CWORD; i++ )); do
        word="${COMP_WORDS[i]}"
        if [[ $skip -eq 1 ]]; then skip=0; continue; fi
        if [[ "$word" == "-s" || "$word" == "--shell" ]]; then skip=1; continue; fi
        if [[ "$word" == --shell=* ]]; then continue; fi
        if [[ -z "$subcmd" ]]; then subcmd="$word"; fi
    done

    if [[ -z "$subcmd" ]]; then
        COMPREPLY=($(compgen -W "-s --shell $(_hive_active_subcmds)" -- "$cur"))
        return
    fi

    # Second positional (target)
    local n_positional=0
    for (( i=1; i<COMP_CWORD; i++ )); do
        word="${COMP_WORDS[i]}"
        if [[ $skip -eq 1 ]]; then skip=0; continue; fi
        if [[ "$word" == "-s" || "$word" == "--shell" ]]; then skip=1; continue; fi
        if [[ "$word" == --shell=* ]]; then continue; fi
        (( n_positional++ ))
    done

    if [[ $n_positional -eq 1 ]]; then
        case "$subcmd" in
            lxc)       COMPREPLY=($(compgen -W "$(_hive_lxc_targets | tr '\n' ' ')" -- "$cur")) ;;
            juju)      COMPREPLY=($(compgen -W "$(_hive_juju_targets | tr '\n' ' ')" -- "$cur")) ;;
            multipass) COMPREPLY=($(compgen -W "$(_hive_multipass_targets | tr '\n' ' ')" -- "$cur")) ;;
            ssh)       COMPREPLY=($(compgen -W "$(_hive_ssh_targets | tr '\n' ' ')" -- "$cur")) ;;
            add)       COMPREPLY=($(compgen -W "$(_hive_available_plugins | tr '\n' ' ')" -- "$cur")) ;;
        esac
    fi
}

complete -F _hive_completion hive
