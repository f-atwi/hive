. "${BASH_SOURCE%/*}/hive"

# Delegate to the owning plugin's helper — guaranteed loaded when the transport flag is set.
_hive_lxc_targets()       { _flexed_containers; }
_hive_juju_targets()      { _fujy_units; }
_hive_multipass_targets() { _swarmpass_instances; }

_hive_ssh_targets()
{
    grep -i '^Host ' ~/.ssh/config 2>/dev/null \
        | awk '{for(i=2;i<=NF;i++) if($i !~ /[*?]/) print $i}'
}

# Only suggest subcommands whose backing plugin has been loaded.
_hive_active_subcmds()
{
    local cmds=""
    [ "$_flexed_loaded"    ] && cmds="$cmds lxc"
    [ "$_fujy_loaded"      ] && cmds="$cmds juju"
    [ "$_swarmpass_loaded" ] && cmds="$cmds multipass"
    command -v ssh >/dev/null 2>&1 && cmds="$cmds ssh"
    echo "$cmds add help"
}

# Suggest plugins that are known but not yet installed.
_hive_available_plugins()
{
    local plugin
    for plugin in flexed fujy futil nerdp swarmpass; do
        [ -d "${FLY_HOME:-$HOME}/.fly.d/plugins/$plugin" ] || echo "$plugin"
    done
}

_hive_completion()
{
    local cur subcmd

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    subcmd="${COMP_WORDS[1]}"

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=($(compgen -W "$(_hive_active_subcmds)" -- "$cur"))
        return
    fi

    if [[ $COMP_CWORD -eq 2 ]]; then
        case "$subcmd" in
            lxc)
                COMPREPLY=($(compgen -W "$(_hive_lxc_targets | tr '\n' ' ')" -- "$cur"))
                ;;
            juju)
                COMPREPLY=($(compgen -W "$(_hive_juju_targets | tr '\n' ' ')" -- "$cur"))
                ;;
            multipass)
                COMPREPLY=($(compgen -W "$(_hive_multipass_targets | tr '\n' ' ')" -- "$cur"))
                ;;
            ssh)
                COMPREPLY=($(compgen -W "$(_hive_ssh_targets | tr '\n' ' ')" -- "$cur"))
                ;;
            add)
                COMPREPLY=($(compgen -W "$(_hive_available_plugins | tr '\n' ' ')" -- "$cur"))
                ;;
        esac
        return
    fi

    if [[ $COMP_CWORD -eq 3 ]]; then
        case "$subcmd" in
            lxc|juju|multipass|ssh)
                COMPREPLY=($(compgen -W "bash zsh ksh" -- "$cur"))
                ;;
        esac
    fi
}

complete -F _hive_completion hive
