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
    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=($(compgen -W "$(_flug_complist "${COMP_WORDS[@]:1:COMP_CWORD-1}")" -- "$cur"))
}

complete -F _flug_completion flug
