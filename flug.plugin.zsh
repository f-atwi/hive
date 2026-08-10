. "${FLY_HOME:-$HOME}/.fly.d/plugins/flug/flug"

# ── zsh completion ────────────────────────────────────────────────

_flug_completion()
{
    compadd -- $(_flug_complist $words[2,CURRENT-1])
}

compdef _flug_completion flug
